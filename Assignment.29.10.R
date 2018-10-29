# Task 29.10

library(tidyverse)
library(dplyr)

# Read the following accounting dataset DS:
  
  DS = tribble(
    ~fk_account_code, ~Ansvar, ~fk_function_code, ~fk_project_code, ~amount,
    101030,40220,"Det",3432,1493.00,
    101030,40220,"Met",3586,2827.00,
    101030,40320,"Det",3456,49440.00,
    101030,40330,"Sal",NA,870716.00,
    101030,40350,"Met",NA,559928.00,
    101030,40360,"Sal",NA,125534.00,
    101030,40280,"Pol",NA,251611.00)

# 1) Remove the "fk_project_code" variable from DS.

DS <-  select( DS, fk_account_code, Ansvar, fk_function_code, amount)


#2) Sum the "amount" by the 3 first digits of "Ansvar"; 402, 403, etc.

DS$Ansvar <- as.character(DS$Ansvar)
str(DS)

DS <- separate(DS, Ansvar, into = c("Ansvar 1_3", "rest"), sep = 3) 

DS %>% group_by(`Ansvar 1_3`) %>% summarise(sum=sum(amount)) 


# 3) Make new "labels" for "fk_function_code", where:
#  "Det" and "Sal" is "supplies",
# "Met" is "inventories" and
# "Pol" is "other expenses"

DS <- DS %>% mutate(new_funtion_code = 
                case_when(fk_function_code == "Det" ~ "supplies",
                         fk_function_code == "sal" ~ "supplies",
                         fk_function_code == "Met" ~ "inventories",
                         fk_function_code == "Pol" ~ "Other expenses"))
                  
# Task 2


# Read the following small dataset df:

library(data.table)
  
  
  df <- data.frame(Product=gl(3,10,labels=c("A","B", "C")), 
                   Year=factor(rep(2002:2011,3)), 
                   Sales=1:30)

# Calculate the share of sales per product per year. 
# The sum over the 3 shares per year is 100. Make a plot of the sales and shares per year per company.
  
DT <- data.table(df)
str(DT)
setkey(DT, "Year")
DT <- DT[, Share := Sales/sum(Sales), by=list(Year)]

install.packages("latticeExtra")
library(latticeExtra)

asTheEconomist(
xyplot(Sales +Share ~ Year, group=Product, data = DT, 
       t="b", scales = list(relation="free", x=list(rot=45)),
       auto.key=list(space = "top", column=3),
       main="Product Information"))