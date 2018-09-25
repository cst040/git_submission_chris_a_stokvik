
install.packages("data.table")
install.packages("dplyr")
install.packages("tidyverse")
install.packages("gdata")
install.packages("lubridate")
library(gdata)
library(readr)
library(ggplot2)
library(dplyr)
library(data.table)
library(lubricate)
install.packages("ggfortify")
library(ggfortify)
library(tidyverse)

# Lese inn data fra internettkilde og formater første kolonne om til dato

eqnr <- read_csv("https://www.netfonds.no/quotes/paperhistory.php?paper=EQNR.OSE&csv_format=csv", 
                 col_types = cols(quote_date = col_date(format = "%Y%m%d")))


# Lese inn data fra internettkilde og formater første kolonne om til dato

nhy <- read_csv("https://www.netfonds.no/quotes/paperhistory.php?paper=NHY.OSE&csv_format=csv", 
                col_types = cols(quote_date = col_date(format = "%Y%m%d")))


# Filtrere data etter angitt kutt of dato, dette gjør vi med filter funksjon og angir data som dato. 

eqnr2 <- eqnr %>% 
  filter(quote_date >= as.Date("2010-01-04"))

nhy2 <- nhy %>% 
  filter(quote_date >= as.Date("2010-01-04"))


# Merge datasett og lage et felles dataplot.  



ne <- rbind(nhy2, eqnr2)
      
ggplot(NE, aes(x = quote_date, y = close, colour = paper)) +
geom_line()



## “Bells & Whistles”

tail(eqnr2)
tail(nhy2)

eqnr3 <- mutate(eqnr2 , eqnr2$close = eqnr2$close / 1,48)

nhy3 <- mutate(nhy2 , nhy2$close = nhy2$close / 0.503)

ne2 <- rbind(nht3, eqnr3)

ggplot(NE2, aes(x = quote_date, y = close, colour = paper)) +
  geom_line()



