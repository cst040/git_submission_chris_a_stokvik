library(readr)
library(dplyr)
library(ggplot2)
library(tidyr)
library(data.table)
library(stringr)


# I load the datasetts 95247 and 95276 from SBB with info about county and national accomedation stats.   

fylker <- read.csv2("http://data.ssb.no/api/v0/dataset/95274.csv?lang=no", sep = ";")

nasjonalt <- read.csv2("http://data.ssb.no/api/v0/dataset/95276.csv?lang=no", sep = ";")



# I use the spread funktion in tidyr to spread the statistikkvariabel to multiple colums so that each time unit has just one row

fylker2 <- spread(fylker, statistikkvariabel, Hotell.og.liknande.overnattingsbedrifter..Kapasitetsutnytting.og.pris.per.rom..etter.region..m.ned.og.statistikkvariabel)

nasjonalt2 <- spread(nasjonalt, statistikkvariabel, Hotell.og.liknande.overnattingsbedrifter..Kapasitetsutnytting.og.pris.per.rom..etter.region..m.ned.og.statistikkvariabel)


# I used the rbind function to combine the data on county and national level.  

samlet <- rbind(fylker2, nasjonalt2)

# I used the subset function to remove the zero values 

samlet2 <- subset(samlet, `Pris per rom (kr)` > 0)

# I use the group_by funtion to calculate the mean price pr region 

mean.Price <- samlet2%>%
  group_by(region)%>%
  summarize(meanPrice  =  mean(`Pris per rom (kr)`))
   
# Then i subtract the mean price of the national avg to view the difference 
# and put the changed data into the mean.Price datasett, 

mean.Price$meanPrice <- as.data.frame(mean.Price$meanPrice - 753.28)

# I use the cor function to check the correaltion between price and used capasity. 

cor(samlet2$`Pris per rom (kr)`, samlet2$`Kapasitetsutnytting av rom (prosent)`)



 

                  
                