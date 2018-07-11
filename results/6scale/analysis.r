setwd("~/Documents/GitHub/ad_qp")
d <- read.csv("results/6scale/6scale_anonymized2.csv",header = TRUE, stringsAsFactors = FALSE)

theta <- function(x,xdata,na.rm=T) {mean(xdata[x],na.rm=na.rm)}

ci.low <- function(x,na.rm=T) {
  mean(x,na.rm=na.rm) - quantile(bootstrap(1:length(x),1000,theta,x,na.rm=na.rm)$thetastar,.025,na.rm=na.rm)}
ci.high <- function(x,na.rm=T) {
  quantile(bootstrap(1:length(x),1000,theta,x,na.rm=na.rm)$thetastar,.975,na.rm=na.rm) - mean(x,na.rm=na.rm)}

library(tidyverse)
library(bootstrap)

# there were some major problems with data collection, but thankfull enough identifying information to recover the dataset.

d <- data.frame(lapply(d, function(x) {
  gsub('"', '', x)
}))

d <- data.frame(lapply(d, function(x) {
  gsub('\\\\', '', x)
}))

d$utteranceprime <- 0

d[d$target == "or" & d$Answer.list == "list1",]$utteranceprime <- "exhaustive"
d[d$target == "or" & d$Answer.list == "list2",]$utteranceprime <- "noprime"
d[d$target == "or" & d$Answer.list == "list3",]$utteranceprime <- "strong_alternative"

d[d$target == "some" & d$Answer.list == "list1",]$utteranceprime <- "strong_alternative"
d[d$target == "some" & d$Answer.list == "list2",]$utteranceprime <- "exhaustive"
d[d$target == "some" & d$Answer.list == "list3",]$utteranceprime <- "noprime"

d[d$target == "lookslike" & d$Answer.list == "list1",]$utteranceprime <- "noprime"
d[d$target == "lookslike" & d$Answer.list == "list2",]$utteranceprime <- "strong_alternative"
d[d$target == "lookslike" & d$Answer.list == "list3",]$utteranceprime <- "exhaustive"

d[d$target == "n" & d$Answer.list == "list1",]$utteranceprime <- "exhaustive"
d[d$target == "n" & d$Answer.list == "list2",]$utteranceprime <- "noprime"
d[d$target == "n" & d$Answer.list == "list3",]$utteranceprime <- "strong_alternative"

d[d$target == "hard" & d$Answer.list == "list1",]$utteranceprime <- "noprime"
d[d$target == "hard" & d$Answer.list == "list2",]$utteranceprime <- "strong_alternative"
d[d$target == "hard" & d$Answer.list == "list3",]$utteranceprime <- "exhaustive"

d[d$target == "tasty" & d$Answer.list == "list1",]$utteranceprime <- "strong_alternative"
d[d$target == "tasty" & d$Answer.list == "list2",]$utteranceprime <- "exhaustive"
d[d$target == "tasty" & d$Answer.list == "list3",]$utteranceprime <- "noprime"

d$response <- as.numeric(d$response)

d$correct <- 0
d[d$id %in% c("high_right1","high_right2","high_right3"),]$correct <- "high"
d[d$id %in% c("low_right1","low_right2","low_right3"),]$correct <- "low"

# one type of exclude: any high_right < 50, or any low_right > 50

exclude_list <- d %>%
  group_by(workerid, id, correct) %>%
  summarize(response) %>%
  filter((correct == "high" && response < 50) || (correct == "low" && response > 50))

# length(unique(exclude_list$workerid))
  
# another type of exclude: avg of high_right < 50, or avg of low_right > 50

exclude_list <- d %>%
  group_by(workerid, correct) %>%
  filter(correct %in% c("high","low")) %>%
  summarize(Mean = mean(response)) %>%
  filter((correct == "high" && Mean < 50) || (correct == "low" && Mean > 50))

# length(unique(exclude_list$workerid))

# last type of exclude: 2 or more mistakes

exclude_list <- d %>%
  group_by(workerid, id, correct) %>%
  summarize(response) %>%
  filter((correct == "high" && response < 50) || (correct == "low" && response > 50)) %>%
  group_by(workerid) %>%
  summarize(n_mistakes = n()) %>%
  filter(n_mistakes > 1)
  
# length(unique(exclude_list$workerid))

d_filtered <- d %>% 
  filter(!(workerid %in% exclude_list$workerid))

toplot <- d_filtered %>% 
  filter(type == "crit") %>%
  group_by(target, utteranceprime) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

ggplot(toplot, aes(x=utteranceprime,y=Mean)) +
  facet_wrap(~target) +
  geom_bar(stat="identity") +
  theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
  geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25) + 
  labs(x = "Prime", y = "Interpretation (100 = maximum exhaustivity inference)") +
  ggtitle("Strength of exhaustivity interpretations by prime type")

