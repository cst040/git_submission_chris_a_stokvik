# CDC file, birth 

library(dplyr)
library(tidyr)
library(readr)
library(ggplot2)

# Make a list of the colum names

kolonne.navn <- c("start", "end", "width", "name"
              

# Define the row that I wish to exstract 

data_exstraction <- matrix(
  475,475,1,SEX 
  504,507,4,DBWT 
  13,14,2,DOB_MM Birth Month
)

# Read the data (I did't manage to un-zip the file. It seems like Mac users
# need to buy a program to un-zip it )

birth <- read.csv("birth", col.names = kolonne.navn, header = FALSE)

# gruppere data etter kjønn og dele på hverandre for å få et fordelings ratio. 

gender.ratio <- (sum(birth$sex == M ) / sum(birth$sex == F))


# Avg. birth weight 

mean.BW <- (sum(birth$weight) / sum(count.row(birth$weight)))


# plot of the distribution of birth weight 

ggplot(birth$weight, 
       group_by(months), 
       geom_plot()


                                      



