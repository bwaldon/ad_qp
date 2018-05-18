library(tidyverse)
library(lme4)
library(lmerTest)
theme_set(theme_bw())
d <- read.csv("/Users/bwaldon/Documents/GitHub/Submiterator/pilot2.csv")
write.csv(d, file = "pilot2_data.csv")

setwd("~/Documents/GitHub/ad_qp")
d <- read.csv("pilot2_data.csv")
nrow(d[d$type == "\"filler\"",])
head(d)
table(d$workerid)
length(unique(d$workerid))

library(bootstrap)
theta <- function(x,xdata,na.rm=T) {mean(xdata[x],na.rm=na.rm)}

ci.low <- function(x,na.rm=T) {
  mean(x,na.rm=na.rm) - quantile(bootstrap(1:length(x),1000,theta,x,na.rm=na.rm)$thetastar,.025,na.rm=na.rm)}
ci.high <- function(x,na.rm=T) {
  quantile(bootstrap(1:length(x),1000,theta,x,na.rm=na.rm)$thetastar,.975,na.rm=na.rm) - mean(x,na.rm=na.rm)}

levels(d$Answer.condition)
levels(d$Answer.condition) <- c("and","either-or","[none]","or-but-not-both")

toplot = d %>%
  filter(type == "\"crit\"") %>%
  group_by(Answer.condition) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

ggplot(toplot, aes(x=Answer.condition,y=Mean)) +
  geom_bar(stat="identity") +
  theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
  geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25) + 
  labs(x = "Priming condition", y = "Mean likelihood of exclusive inference")

toplot_prime = d %>%
  filter(type == "\"prime\"") %>%
  group_by(Answer.condition) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

ggplot(toplot_prime, aes(x=Answer.condition,y=Mean)) +
  geom_bar(stat="identity") +
  theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
  geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25) + 
  labs(x = "Priming condition", y = "Mean likelihood of exclusive inference")

toplot_subjectvar = d %>%
  filter(type != "\"filler\"") %>%
  group_by(Answer.condition,type) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

toplot_subjectvar_bysubject = d %>%
  filter(type != "\"filler\"") %>%
  group_by(Answer.condition,type,workerid) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

toplot_subjectvar$type <- relevel(toplot_subjectvar$type, ref = "\"prime\"")

ggplot(toplot_subjectvar, aes(x=type,y=Mean)) +
  geom_bar(stat="identity") + 
  facet_wrap(~Answer.condition) +
  geom_line(data = toplot_subjectvar_bysubject, aes(group=workerid), color = "red", alpha = 0.5) + 
  theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
  geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25) + 
  labs(x = "Priming condition", y = "Mean likelihood of exclusive inference")

fillers = d %>%
  filter(type == "\"filler\"")

p <- ggplot(fillers, aes(x=response)) +
  geom_histogram() + 
  facet_wrap(~workerid)
  
ggsave("fillers_bysubject.png", width = 20, height = 40)

table(unique(d$workerid))

unique(d[,c("type","Answer.condition")])
View(toplot_subjectvar)
head(d)

summary(d)

l <- lmer(response ~ Answer.condition + (1|workerid), data = d)
summary(l)

d$Answer.condition <- relevel(d$Answer.condition, ref = "[none]")
labels(d)
