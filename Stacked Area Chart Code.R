library(ggplot2)
library(lubridate)
library(tidyr)
library(dplyr)
theme_set(theme_bw())

#veriseti1
drug_age <- read.csv("C:\\Users\\ECE KANLI\\Desktop\\deaths-from-drug-use-disorders-by-age.csv")
#code degiskenini veriden cikarma
drug_age <- subset(drug_age, select = -Code)
#veri setinde kayıp gozlem kontrolu
colSums(is.na(drug_age))
#veri setinde yeniden isimlendirme
colnames(drug_age) <- c("Country","Year","Age.Under.5","Age.70.years","Age.15.49.years",
                        "Age.50.69.years","Age.5.14.years")
attach(drug_age)
#Year degiskenini Date veri tipi yapma
drug_age$Year <- ymd(drug_age$Year, truncated = 2L)

#veriseti2
drug_sub <- read.csv("C:\\Users\\ECE KANLI\\Desktop\\deaths-drug-overdoses.csv")
#code degişkenini veriden cikarma
drug_sub <- subset(drug_sub, select = -Code)
#veri setinde kayıp gözlem 
colSums(is.na(drug_sub))
#veri setinde yeniden isimlendirme
colnames(drug_sub) <- c("Country","Year","Amphetamine","Cocaine",
                    "Opioid","Other.drugs")
attach(drug_sub)
#Year degiskenini Date veri tipi yapma
drug_sub$Year <- ymd(drug_sub$Year, truncated = 2L)

# Country ve Year sutunları eslesiyor mu?
Country_comparison <- identical(drug_sub$Country, drug_age$Country)
Year_Comparison <- identical(drug_sub$Year, drug_age$Year)

#veriseti1 ve veriseti2 nin birlestirilmesi
drug <- inner_join(drug_age, drug_sub, by = c("Country", "Year"))

#Country degiskeninden ulke olmayan kategorik degerlerin cikarilmasi
drug <- drug %>%
  filter(Country != "African Region (WHO)" & Country != "East Asia & Pacific (WB)" & Country != "Eastern Mediterranean Region (WHO)" &
           Country != "Europe & Central Asia (WB)" & Country != "European Region (WHO)" & Country != "Latin America & Caribbean (WB)" &
           Country != "Middle East & North Africa (WB)" & Country != "North America (WB)" & Country != "Region of the Americas (WHO)" &
           Country != "South Asia (WB)" & Country != "South-East Asia Region (WHO)" & Country != "Sub-Saharan Africa (WB)" &
           Country != "Western Pacific Region (WHO)" & Country != "World" & Country != "World Bank High Income" & 
           Country != "World Bank Low Income" & Country !=  "World Bank Lower Middle Income" & Country != "World Bank Upper Middle Income" &
           Country != "OECD Countries" & Country != "G20")

#veri gorsellestirme:
# 1
# Uyusturucu kullanimina bagli olarak yas gruplarına gore olum sayilarini veren %100 yigilmis alan grafigi

# filtreleme
# veri setinde sutunlari birlestirme
# Age_Groups degiskeni olusturma 
drug_age_groups <- pivot_longer(
  drug,
  cols = c(Age.Under.5,Age.5.14.years,Age.15.49.years,Age.50.69.years,Age.70.years),
  names_to = "Age_Groups",
  values_to = "Death_values"
)

# %100 yigilmis alan grafigi
graph1 <- drug_age_groups  %>%
  group_by(Year, Age_Groups) %>%
  summarise(n = sum(Death_values)) %>%
  mutate(percentage = n / sum(n))

ggplot(graph1, aes(x=Year, y=percentage, fill=Age_Groups)) + 
  geom_area(alpha=0.6 , size=1, colour="black") +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") +  
  ylab("Ölüm Oranı(%)") + 
  ggtitle("Uyuşturucu Kullanımının Yaş Gruplarına Göre Ölüm Oranları")

#2
# Olum orani yuksek olan 5 ulkenin 15-49 yas grubuna gore olum sayilarini veren yigilmis alan grafigi

#ulkelerdeki toplam olum sayilari
toplam_age <- drug_age_groups %>%
  group_by(Country) %>%
  summarise(toplam_olum = sum(Death_values))
toplam_age <- toplam_age[order(toplam_age$toplam_olum), ]

graph2 <- drug[drug$Country %in% c("United States", "China", "Russia", "India","Iran"), ]
ggplot(graph2, aes(x=Year, y=Age.15.49.years, fill=Country)) + geom_area() +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") + 
  ylab("15-49 Yaş Grubu Ölüm Sayıları") + 
  ggtitle("Ölüm Sayısı En Yüksek Olan 5 Ülkenin 15-49 Yaş Grubuna Ait Ölüm Sayıları")

#3
# Kulanilan uyusturucuya bagli olarak olum oranini veren %100 yigilmis alan grafigi

# filtreleme
# veri setinde sutunlari birlestirme
# Drugs degiskeni olusturma
drug_sub_groups <- pivot_longer(
  drug,
  cols = c(Amphetamine,Cocaine,Opioid,Other.drugs),
  names_to = "Drugs",
  values_to = "Death_values2"
)

#%100 stacked area chart
graph3 <- drug_sub_groups  %>%
  group_by(Year, Drugs) %>%
  summarise(n = sum(Death_values2)) %>%
  mutate(percentage = n / sum(n))

# Plot
ggplot(graph3, aes(x=Year, y=percentage, fill=Drugs)) + 
  geom_area(alpha=0.6 , size=1, colour="black") +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") +  
  ylab("Ölüm Oranı(%)") + 
  ggtitle("Kullanılan Uyuşturucuya Göre Ölüm Oranları")

#4
#Dünyadaki bölgelere göre amfetamin kullanımına Bagli Olum Sayilari

drug_filtered <- drug_sub[drug_sub$Country %in% c("African Region (WHO)","Eastern Mediterranean Region (WHO)",
                        "European Region (WHO)","Region of the Americas (WHO)",
                        "South-East Asia Region (WHO)","Western Pacific Region (WHO)"),]
ggplot(drug_filtered, aes(x=Year, y=Amphetamine, fill=Country)) + geom_area() +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") + 
  ylab("Amfetamin Kullanıma Bağlı Ölüm Sayıları") +  
  ggtitle("Bölgelere Göre Amfetamin Kullanımına Bağlı Ölüm Sayıları")

#Gelir Duzeyine gore kokain kullanimina bagli olum sayilari

drug_filtered1 <- drug_sub[drug_sub$Country %in% c("World Bank High Income","World Bank Low Income",
                                                  "World Bank Lower Middle Income","World Bank Upper Middle Income"),]
ggplot(drug_filtered1, aes(x=Year, y=Cocaine, fill=Country)) + geom_area() +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") + 
  ylab("Kokain Kullanıma Bağlı Ölüm Sayıları") +  
  ggtitle("Gelir Düzeyine Göre Kokain Kullanımına Bağlı Ölüm Sayıları")

#Gelir Duzeyine gore opioid kullanimina bagli olum sayilari

drug_filtered1 <- drug_sub[drug_sub$Country %in% c("World Bank High Income","World Bank Low Income",
                                                   "World Bank Lower Middle Income","World Bank Upper Middle Income"),]
ggplot(drug_filtered1, aes(x=Year, y=Opioid, fill=Country)) + geom_area() +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") + 
  ylab("Opioid Kullanıma Bağlı Ölüm Sayıları") +  
  ggtitle("Gelir Düzeyine Göre Opioid Kullanımına Bağlı Ölüm Sayıları")

#diger grafikler:

# Olum orani yuksek olan 5 ulkenin Amfetamine gore olum sayilarini veren yigilmis alan grafigi

graph4 <- drug[drug$Country %in% c("United States", "China", "Russia", "India","Iran"), ]
ggplot(graph4, aes(x=Year, y=Amphetamine, fill=Country)) + geom_area() +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") +  
  ylab("Amfetamin Kullanıma Bağlı Ölüm Sayıları") +  
  ggtitle("Ölüm Sayısı En Yüksek Olan 5 Ülkenin Amfetamin Kullanımına Bağlı Ölüm Sayıları")

# Olum orani yuksek olan 5 ulkenin Kokaine gore olum sayilarini veren yigilmis alan grafigi

graph4 <- drug[drug$Country %in% c("United States", "China", "Russia", "India","Iran"), ]
ggplot(graph4, aes(x=Year, y=Cocaine, fill=Country)) + geom_area() +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") + 
  ylab("Kokain Kullanıma Bağlı Ölüm Sayıları") + 
  ggtitle("Ölüm Sayısı En Yüksek Olan 5 Ülkenin Kokain Kullanımına Bağlı Ölüm Sayıları")

# Olum orani yuksek olan 5 ulkenin Opioide gore olum sayilarini veren yigilmis alan grafigi

graph4 <- drug[drug$Country %in% c("United States", "China", "Russia", "India","Iran"), ]
ggplot(graph4, aes(x=Year, y=Opioid, fill=Country)) + geom_area() +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") +  
  ylab("Opioid Kullanıma Bağlı Ölüm Sayıları") +  
  ggtitle("Ölüm Sayısı En Yüksek Olan 5 Ülkenin Opioid Kullanımına Bağlı Ölüm Sayıları")


#Amerika'da Kullanılan Uyusturucuya Gore Olum Oranlari
drug_abd <- drug_sub_groups[drug_sub_groups$Country %in% c("United States"), ]
graph5 <- drug_abd  %>%
  group_by(Year, Drugs) %>%
  summarise(n = sum(Death_values2)) %>%
  mutate(percentage = n / sum(n))

# Plot
ggplot(graph5, aes(x=Year, y=percentage, fill=Drugs)) + 
  geom_area(alpha=0.6 , size=1, colour="black") +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") +  
  ylab("Ölüm Oranı(%)") + 
  ggtitle("Amerika'da Kullanılan Uyuşturucuya Göre Ölüm Oranları")

#Cin'de Kullanilan Uyusturucuya Gore Olum Oranlari
drug_china <- drug_sub_groups[drug_sub_groups$Country %in% c("China"), ]
graph6 <- drug_china  %>%
  group_by(Year, Drugs) %>%
  summarise(n = sum(Death_values2)) %>%
  mutate(percentage = n / sum(n))

# Plot
ggplot(graph6, aes(x=Year, y=percentage, fill=Drugs)) + 
  geom_area(alpha=0.6 , size=1, colour="black") +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") +  
  ylab("Ölüm Oranı(%)") + 
  ggtitle("Çin'de Kullanılan Uyuşturucuya Göre Ölüm Oranları")

#Rusya'da Kullanilan Uyusturucuya Gore Olum Oranlari
drug_russia <- drug_sub_groups[drug_sub_groups$Country %in% c("Russia"), ]
graph7 <- drug_russia  %>%
  group_by(Year, Drugs) %>%
  summarise(n = sum(Death_values2)) %>%
  mutate(percentage = n / sum(n))

# Plot
ggplot(graph7, aes(x=Year, y=percentage, fill=Drugs)) + 
  geom_area(alpha=0.6 , size=1, colour="black") +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") +  
  ylab("Ölüm Oranı(%)") + 
  ggtitle("Rusya'da Kullanılan Uyuşturucuya Göre Ölüm Oranları")

#Turkiye'de Kullanilan Uyusturucuya Gore Olum Oranlari
drug_turkey <- drug_sub_groups[drug_sub_groups$Country %in% c("Turkey"), ]
graph8 <- drug_turkey  %>%
  group_by(Year, Drugs) %>%
  summarise(n = sum(Death_values2)) %>%
  mutate(percentage = n / sum(n))

# Plot
ggplot(graph8, aes(x=Year, y=percentage, fill=Drugs)) + 
  geom_area(alpha=0.6 , size=1, colour="black") +
  scale_fill_brewer(palette = "Dark2") +
  xlab("Yıl") +  
  ylab("Ölüm Oranı(%)") + 
  ggtitle("Türkiye'de Kullanılan Uyuşturucuya Göre Ölüm Oranları")




