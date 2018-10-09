library(rvest)
library(tidyverse)
library(dplyr)
library(stringr)
library(lubridate)

# Lese link til side med informasjon 

br <- read_html("https://w2.brreg.no/kunngjoring/kombisok.jsp?datoFra=01.01.2018&datoTil=08.10.2018&id_region=100&id_fylke=19&id_kommune=-+-+-&id_niva1=51&id_niva2=-+-+-&id_bransje1=0")

#Used selectorgaget to subset data, so that get a indicidual lists of numbers and dates 

br_nummer <- br%>%html_nodes("td:nth-child(4) p")%>% html_text()
br_dato <- br%>%html_nodes("tr~ tr+ tr td:nth-child(6) p")%>% html_text()


#Remove blanckspaces 

br_nummer <- str_replace_all(br_nummer, pattern = " ", replacement = "" )

# Filtrere out birthdays 

br_org <- subset(br_nummer, br_nummer > 9)

# Change br_nummer to numeric from charackter 

br_org <- as.numeric(br_org)

# Change the type to date 

br_dato2 <- as.Date(br_dato, "%d.%m.%Y")



# Combine the to lists 

br_datasett <- cbind(br_org, br_dato)

# Plot 

ggplot(br_datasett,


