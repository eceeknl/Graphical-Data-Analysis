# Yığılmış Alan Grafiği (Stacked Area Chart)

Bu proje, 1990-2019 yılları arasında ülke bazında yaş gruplarına ve farklı uyuşturucu madde kullanımına bağlı olarak gerçekleşen ölüm sayıları ile ilgili olan bir veri seti üzerinde çizdirilen yığılmış alan grafiklerini içermektedir.

## Veri Seti

Yığılmış alan grafiği, Kaggle üzerinden alınan [veri seti1](https://www.kaggle.com/datasets/programmerrdai/cocaineopioidscannabis-and-illicit-drugs?select=deaths-from-drug-use-disorders-by-age.csv) ve [veriseti2](https://www.kaggle.com/datasets/programmerrdai/cocaineopioidscannabis-and-illicit-drugs?select=deaths-drug-overdoses.csv) veri setlerinin birleştirilmesi ile oluşturulan yeni veri seti üzerinde uygulanmıştır. 

Değişkenler:

• *Country* : Ülkeleri, bölgeleri ve gelir düzeyine göre ülkeleri içeren değişken.
(veri tipi: string)

• *Year* : 1990-2019 yıllarını içeren değişken. (veri tipi: date)

• *Age.Under.5, Age.70.years, Age.15.49.years, Age.50.69.years, Age.5.14.years* : Uyuşturucu kullanımına bağlı olarak yaş gruplarına göre ölüm sayılarını veren
değişkenler. (veri tipi: integer)

• *Amphetamine, Cocaine, Opioid, Other.drugs* : Kullanılan uyuşturucuya
göre tüm yaş gruplarında ölüm sayılarını veren değişkenler. (veri tipi: integer)

Veri seti, toplamda 6840 gözlem ve 11 değişkenden oluşmaktadır.

## Rapor İçeriği 

- Yığılmış Alan Grafiği  
  - Tanımı ve Yorumlanması 
  - %100 Yığılmış Alan Grafiği
  - Kullanılmaması Gereken Durumlar 
- Veri Seti Üzerinde Uygulanması
  - Veri Seti Hakkında 
- Veri Görselleştirme 
- Kodların İncelenmesi
 
## Kod İçeriği  
- Veri Ön İşleme
- Veri Görselleştirme 