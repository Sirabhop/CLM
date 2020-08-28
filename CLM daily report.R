setwd("C:\\Users\\sirabho\\Desktop\\CLM Analysis")

library(psych)
library(dplyr)
library(stringr)
library(ggplot2)

df = read.csv("CLM Daily Status Updates for Request Portal as of 8_27_2020.csv")

drop <- c("Summary", "Request.Channel", "Reference.Key", "Assignee", "Resolution",
          "Reject.Reason", "Reject.Reason..Others.", "Waiting.Reason", "Resolved", 
          "Resolved.Date")
df = df[, !(names(df) %in% drop)]


df %>% filter(Lifestage.Name == "Heavy Duty" & Lifestyle.Name == "Food and Drink") %>%
  select(Key, Status, Total.Leads, Campaign.Channel, Telesale.Project.Name, Preferred_date) %>%
  filter(Status != "10. Rejected (Resolved)", Campaign.Channel == "Call-Center")

#Date & Time setting
launch = data.frame(str_split_fixed(df$Preferred.Campaign.Launch, " ", 2))
df$Preferred_date = launch[, 1]
df$Preferred_time = launch[, 2]
df$Preferred_date = as.Date(df$Preferred_date, format = '%m/%d/%Y')
df$Preferred_time = as.Date(df$Preferred_time, format = 'h:m:s')

campaign_planning = df %>% select(Lifestage.Name, Lifestyle.Name, Preferred_date)
campaign_planning = na.omit(campaign_planning)

LifeStages = c("High School", "University", "Start Career", "Established Family", 
               "Experienced Professional Urban", "Experienced Professional Rural", 
               "Heavy Duty", "Family with Toddler", "Family with Grown Up Kid",
               "Retirement")

campaign_planning$month = strftime(campaign_planning$Preferred_date,"%m")
calendar = campaign_planning %>% group_by(Lifestage.Name, month) %>% count()
