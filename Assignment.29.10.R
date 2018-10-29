# Forelesning 29.10 

rm(list=ls())

library(tidyverse)
library(readr)
library(lubridate)

superstore <- read_csv("https://github.com/ywchiu/rcookbook/raw/master/chapter7/superstore_sales.csv", 
                       col_types = cols(`Order Date` = col_date(format = "%Y/%m/%d")))

str(superstore)
names(superstore) <- c("Order_ID", "Order_Date","Order_Quantity","Sales","Profit","Unit_Price",
                       "Province","Customer_Segment","Product_Category")

#' Exploratory Data Analysis
install.packages("DataExplorer") 
library(DataExplorer)

str(superstore)
plot_str(superstore)
plot_missing(superstore)
plot_histogram(superstore)
plot_density(superstore)
plot_correlation(superstore, type = 'continuous')

# For character/factors
plot_bar(superstore)

#' Summarize the total sales amount by year, month, and province

#' All days in a month set to 1
superstore %>% select(Sales, Province, Order_Date) %>% 
  group_by(Year_Month = as.Date(strftime(Order_Date,"%Y/%m/01")), Province) %>% 
  summarise(Total_Sales = sum(Sales))

#' Make a plot of the total sales in Alberta and Youkon in 2010 and 2011
superstore %>% select(Sales, Province, Order_Date) %>% 
  group_by(Year_Month = as.Date(strftime(Order_Date,"%Y/%m/01")), Province) %>% 
  summarise(Total_Sales = sum(Sales)) %>% filter(Province %in% c("Alberta","Yukon")) %>% 
  filter(Year_Month >= '2010-01-01' & Year_Month <= '2011-12-01') %>% 
  ggplot(., aes(x=Year_Month, y=Total_Sales, color=Province)) + geom_line() +  ## Punktum i ggplot som en proxi for df variabel
  xlab("Year Month") + ylab("Sale Amount") + ggtitle("Monthly Total Sale Amount By Province")

#' Changing aesthetics
p <- superstore %>% select(Sales, Province, Order_Date) %>% 
  group_by(Year_Month = as.Date(strftime(Order_Date,"%Y/%m/01")), Province) %>% 
  summarise(Total_Sales = sum(Sales)) %>% filter(Province %in% c("Alberta","Yukon")) %>% 
  filter(Year_Month >= '2010-01-01' & Year_Month <= '2011-12-01') %>% 
  ggplot(., aes(x=Year_Month, y=Total_Sales, color=Province)) + 
  xlab("Year Month") + ylab("Sale Amount") 


p + geom_line(linetype="dashed", size=2) + ggtitle('Change Linetype and Size')
p + geom_bar(stat = "identity", aes(fill=Province) , position = "stack") + ggtitle('Stack Position')
p + geom_bar(stat = "identity", aes(fill=Province), position = "fill") + ggtitle('Fill Position')
p + geom_bar(stat = "identity", aes(fill=Province), position = "dodge") + ggtitle('Dodge Position')
p + geom_bar(stat = "identity", aes(fill=Province), position = "dodge") + ggtitle('Dodge Position') +
  scale_fill_brewer(palette=2) + ggtitle('Refill Bar Colour')
p + geom_point(size=3) + geom_smooth() + ggtitle('Adding Smoother')
p + geom_point(size=3) + geom_smooth(se=FALSE) + ggtitle('Adding Smoother')
p + geom_point(size=3) + geom_smooth(method=lm,se=FALSE) + ggtitle('Adding Linear Regression')
p + geom_point(size=3) + geom_point(stat = "summary", fun.y = "mean", colour = "red", size = 4) + ggtitle('Adding Mean Points')

p + geom_point(aes(size=Total_Sales)) + scale_size_continuous(range=c(1,10)) + ggtitle('Resize The Point')
p + geom_point(aes(colour=Total_Sales), size=5) + scale_color_gradient() + ggtitle('Repaint The Point in Gradient Color')

p + geom_point(size = 5) + facet_wrap(~Province) + ggtitle('Create Multiple Subplots by Province')
p + geom_point(size = 5) + facet_wrap(~Province, ncol=1) + ggtitle('Multiple Subplots in Vertical Direction')

p + geom_point(size=5) + theme_bw()+ ggtitle('theme_bw Example')
p + geom_point(size=5) + theme_dark()+ ggtitle('theme_dark Example')

p + geom_point(size=5) + scale_color_manual(values=c("#E69F00", "chartreuse")) +
  theme(
    axis.text = element_text(size = 12),
    legend.background = element_rect(fill = "white"),
    panel.grid.major = element_line(colour = "yellow"),
    panel.grid.minor = element_blank(),
    panel.background = element_rect(fill = "blue")
  ) + ggtitle('Customized Theme')

library(grid)
grid.newpage()

plot1 <- p + geom_point(size=5) + ggtitle('Scatter Plot')
plot2 <- p + geom_line(size=3) + ggtitle('Line Chart')

pushViewport(viewport(layout = grid.layout(1, 2)))
print(plot1, vp =viewport(layout.pos.row = 1, layout.pos.col = 1))
print(plot2, vp =viewport(layout.pos.row = 1, layout.pos.col = 2))

install.packages("gridExtra")
library(gridExtra)
grid.arrange(plot1,plot2, ncol=2)
library(dplyr)
library(tidyverse)
library(lubridate)

# ----------------------------------------------

#' Min and Max date
summarise(superstore, min(Order_Date))
summarise(superstore, max(Order_Date))

#' Find weekday of date
superstore %>% 
  select(Order_Date) %>% 
  mutate(weekday = wday(Order_Date, label=TRUE))

#' Q: Find average sales by weekday, but exclude Saturdays and Sundays.
#' Call the table weekdays

weekdays <- superstore %>% 
  select(Order_Date, Sales) %>% 
  mutate(weekday = wday(Order_Date, label=TRUE)) %>% 
  filter(!weekday %in% c("Sat", "Sun")) %>%
  group_by(weekday) %>% 
  summarise(Average_Sales = mean(Sales))


#' Q: Find average sales by weekday and Customer Segment. Make one column per Customer Segment.
#' Call the table customer Segment. 

segments <- superstore %>% 
  select(Order_Date, Sales, Customer_Segment) %>% 
  mutate(weekday = wday(Order_Date, label=TRUE)) %>% 
  filter(!weekday %in% c("Sat", "Sun")) %>%
  group_by(weekday, Customer_Segment) %>% 
  summarise(Average_Sales = mean(Sales))
spread(Customer_segment, Average_sales)

#' Your boss loves excel (sigh), and would like a speadsheet with the weekdays and segments report in it.
browseURL("https://cran.r-project.org/web/packages/openxlsx/index.html")

sheets <- list(weekdays=weekdays, segments=segments)
getwd()
openxlsx::write.xlsx(sheets, file= "dataset.xlsx")

install.packages("openxlsx")
library(openxlsx)

#' Find average profit per customer segment and product category in 2011, for all provinces except
#' Nunavut, Newfoundland and Manitoba.
#' What segment produced the highest profit?