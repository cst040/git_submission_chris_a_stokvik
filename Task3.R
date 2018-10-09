library(rvest)
library(tidyverse)
install.packages("dplR")
library(dplyr)
library(stringr)

# Lese link til side med informasjon 

br <- read_html("https://w2.brreg.no/kunngjoring/kombisok.jsp?datoFra=01.01.2018&datoTil=08.10.2018&id_region=100&id_fylke=19&id_kommune=-+-+-&id_niva1=51&id_niva2=-+-+-&id_bransje1=0")

#Brukt selector gaget til ?? subset uthenting av data slik at jeg f??r to lister med nummer (org + per) og en med dato. 

br_nummer <- br%>%html_nodes("td:nth-child(4) p")%>% html_text()
br_dato <- br%>%html_nodes("tr~ tr+ tr td:nth-child(6) p")%>% html_text()


#Fjerne mellomrom i organisasjonsnummer 

br_nummer <- str_replace_all(br_nummer, " ", "" )

# Gj??re br_nummer om til numeric fra charackter 

br_nummer <- as.numeric(br_nummer)

# Gj??re br_dato om til dato 

br_dato <- lubridate::dmy(br_dato)

# Filtrere ut f??dselsdatoer 

br_org <- filter(br_nummer, numeric(length = 9L))


# Gj??re det om til et dataset 

br_datasett <- data.frame(br_org, br_dato)


# Plot 

ggplot(br_datasett, 


