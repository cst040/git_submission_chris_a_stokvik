# Task 5 and 5 

library(tidyverse)


#Task 1


#Read the following accounting dataset DS:
  
  DS = tribble(
    ~fk_account_code, ~Ansvar, ~fk_function_code, ~fk_project_code, ~amount,
    101030,40220,"Det",3432,1493.00,
    101030,40220,"Met",3586,2827.00,
    101030,40320,"Det",3456,49440.00,
    101030,40330,"Sal",NA,870716.00,
    101030,40350,"Met",NA,559928.00,
    101030,40360,"Sal",NA,125534.00,
    101030,40280,"Pol",NA,251611.00)
  
  DS2<- as.data.frame(DS)

# 1) Remove the "fk_project_code" variable from DS.
  
  DS2 <- DS2 %>% 
    select(Ansvar, fk_function_code, amount)


# 2) Sum the "amount" by the 3 first digits of "Ansvar"; 402, 403, etc.
  
  
 svar <-  DS2 %>% 
        filter(amount < 50000)
 
 sum(svar$amount)
         
# 53769        

#3) Make new "labels" for "fk_function_code", where:
#  "Det" and "Sal" is "supplies",
# "Met" is "inventories" and
# "Pol" is "other expenses"
 
 
DS2$fk_function_code <- DS2$fk_function_code %>%
 str_replace("Det", "supplies") %>% 
  str_replace("Sal", "supplies") %>% 
  str_replace("Met", "inventories") %>% 
  str_replace("Pol", "other expences")
