install.packages("PogromcyDanych")
library(PogromcyDanych)
auta2012

install.packages("dplyr")
library(dplyr)

install.packages("tidyr")
library(tidyr)


# 1. Sprawd� ile jest aut z silnikiem diesla wyprodukowanych w 2007 roku?


auta2012 %>% 
  filter(Rodzaj.paliwa == "olej napedowy (diesel)" & Rok.produkcji == "2007" ) %>% 
  count()

# Odp: 11621

# 2. Jakiego koloru auta maj� najmniejszy medianowy przebieg?

auta2012 %>% 
  group_by(Kolor) %>% 
  summarise(mediana = median(Przebieg.w.km, na.rm = TRUE)) %>% 
  top_n(1, -mediana)

#Odp: bialy-metallic
  

# 3. Gdy ograniczy� si� tylko do aut wyprodukowanych w 2007, kt�ra Marka wyst�puje najcz�ciej w zbiorze danych auta2012?


auta2012 %>% 
  filter(Rok.produkcji == "2007") %>% 
  group_by(Marka) %>% 
  summarise(n = n()) %>% 
  arrange(-n) %>% 
  head(1)

# Odp: Volkswagen 

# 4. Spo�r�d aut z silnikiem diesla wyprodukowanych w 2007 roku kt�ra marka jest najta�sza?

auta2012 %>% 
  filter(Rok.produkcji == "2007", Rodzaj.paliwa == "olej napedowy (diesel)") %>% 
  group_by(Marka) %>% 
  summarise(srednia = mean(Cena.w.PLN, na.rm = TRUE)) %>% 
  arrange(srednia) %>% 
  head(1)

# Odp: Aixam

# 5. Spo�r�d aut marki Toyota, kt�ry model najbardziej straci� na cenie pomi�dzy rokiem produkcji 2007 a 2008.


df1 <- auta2012 %>% 
  filter(Rok.produkcji == "2007", Marka =="Toyota") %>% 
  group_by(Model) %>% 
  summarise(srednia = mean(Cena.w.PLN, na.rm = TRUE)) 

df2 <- auta2012 %>% 
  filter(Rok.produkcji == "2008", Marka =="Toyota") %>% 
  group_by(Model) %>% 
  summarise(srednia2 = mean(Cena.w.PLN, na.rm = TRUE)) 

df1 %>% 
  inner_join(df2) %>%
  mutate(roznica = srednia2-srednia) %>% 
  arrange(roznica) %>% 
  head(1)

# Odp: Hiace

# 6. W jakiej marce klimatyzacja jest najcz�ciej obecna?

## Samochodow ktorej marki jest najwiecej w grupie samochodow majacych kimatyzacje (podejscie ilosciowe) 
auta2012 %>% 
  select(Marka, Wyposazenie.dodatkowe) %>% 
  mutate(wypos = as.character(Wyposazenie.dodatkowe)) %>% 
  mutate(jest = ifelse(grepl("klimatyzacja", wypos, fixed = TRUE), 1, 0)) %>% 
  filter(jest == 1) %>% 
  count(Marka) %>% 
  arrange(-n) %>% 
  head(1)

# Odp: Volkswagen

## Ktora marka ma najwiekszy udzial samochodow z klimatyzacja we wszystkich swoich samochodach (podejscie procentowe)

df5 <- auta2012 %>% 
  select(Marka, Wyposazenie.dodatkowe) %>% 
  mutate(wypos = as.character(Wyposazenie.dodatkowe)) %>% 
  mutate(jest = ifelse(grepl("klimatyzacja", wypos, fixed = TRUE), 1, 0)) %>% 
  filter(jest == 1) %>% 
  count(Marka)

df6 <- auta2012 %>% 
  select(Marka) %>% 
  count(Marka)


df5 %>% 
  inner_join(df6, by = c("Marka")) %>% 
  mutate(procent = n.x/n.y) %>% 
  arrange(-procent) %>% 
  head(7)

# U 7 marek samochody z klimatyzacja stanowily 100 procent wszystkich (Brilliance, DFSK, GMC, Saturn, Scion, Shuanghuan,	Vauxhall) 
 

# 7. Gdy ograniczy� si� tylko do aut z silnikiem ponad 100 KM, kt�ra Marka wyst�puje najcz�ciej w zbiorze danych auta2012?

auta2012 %>% 
  filter(KM > 100) %>% 
  count(Marka) %>% 
  top_n(1)

# Odp: Volkswagen

# 8.  Gdy ograniczy� si� tylko do aut o przebiegu poni�ej 50 000 km o silniku diesla, kt�ra Marka wyst�puje najcz�ciej w zbiorze danych auta2012?
auta2012 %>% 
  filter(Przebieg.w.km < 50000, Rodzaj.paliwa == "olej napedowy (diesel)") %>% 
  count(Marka) %>% 
  top_n(1)

# Odp: BMW

# 9. Spo�r�d aut marki Toyota wyprodukowanych w 2007 roku, kt�ry model jest �rednio najdro�szy?

auta2012 %>% 
  filter(Marka == "Toyota", Rok.produkcji == "2007") %>% 
  group_by(Model) %>% 
  summarise(srednia = mean(Cena.w.PLN, na.rm = TRUE)) %>% 
  arrange(-srednia) %>% 
  head(1)

# Odp: Land Cruiser

# 10.  Spo�r�d aut marki Toyota, kt�ry model ma najwi�ksz� r�nic� cen gdy por�wna� silniki benzynowe a diesel?

df3 <- auta2012 %>% 
  filter(Rodzaj.paliwa == "olej napedowy (diesel)", Marka =="Toyota") %>% 
  group_by(Model) %>% 
  summarise(srednia = mean(Cena.w.PLN, na.rm = TRUE)) 

df4 <- auta2012 %>% 
  filter(Rodzaj.paliwa == "benzyna", Marka =="Toyota") %>% 
  group_by(Model) %>% 
  summarise(srednia2 = mean(Cena.w.PLN, na.rm = TRUE)) 

df3 %>% 
  inner_join(df4) %>%
  mutate(roznica = abs(srednia2-srednia)) %>% 
  arrange(-roznica) %>% 
  head(1)

# Odp: Camry
