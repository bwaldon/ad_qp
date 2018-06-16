library(tidyverse)
library(lme4)
library(lmerTest)
theme_set(theme_bw())
library(bootstrap)
theta <- function(x,xdata,na.rm=T) {mean(xdata[x],na.rm=na.rm)}

ci.low <- function(x,na.rm=T) {
  mean(x,na.rm=na.rm) - quantile(bootstrap(1:length(x),1000,theta,x,na.rm=na.rm)$thetastar,.025,na.rm=na.rm)}
ci.high <- function(x,na.rm=T) {
  quantile(bootstrap(1:length(x),1000,theta,x,na.rm=na.rm)$thetastar,.975,na.rm=na.rm) - mean(x,na.rm=na.rm)}


setwd("~/Documents/GitHub/ad_qp")
d <- read.csv("results/pilot4_data.csv")
summary(d)

p = d %>%
  filter(type == "filler")

# If you messed up the second practice trial, we exclude you? 

exclude = c()

for(worker in p$workerid) {
  if(p[p$workerid == worker & p$order == 2,]$error == "true") {
    exclude = c(exclude, worker)
  }
}

exclude = unique(exclude)

d <- d %>%
  filter(!(workerid %in% exclude)) 

d$meaningprime = sapply(strsplit(as.character(d$Answer.condition),"_"), "[", 3)
d[d$meaningprime == "exclu",]$meaningprime <- "exclusive_interpretation" 
d[d$meaningprime == "exlcu",]$meaningprime <- "exclusive_interpretation" #typo from experiment collection
d[d$meaningprime == "orthog",]$meaningprime <- "orthogonal_interpretation" 
d$utteranceprime = sapply(strsplit(as.character(d$Answer.condition),"_"), "[", 2)
d$firstconj = sapply(strsplit(as.character(d$Answer.condition),"_"), "[", 4)

n <- d %>%
  group_by(meaningprime, utteranceprime, firstconj) %>%
  summarize (n = n()/7)

# utterance prime graph, checking by meaning prime 

toplot = d %>%
  filter((type == "crit" | type == "prime") & !(meaningprime == "oneshot") & meaningprime == "exclu" & is.na(firstconj)) %>%
  group_by(utteranceprime,type) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

dodge <- position_dodge(.9)

ggplot(toplot, aes(x=utteranceprime,y=Mean, fill = type)) +
  geom_bar(stat="identity",position = dodge) +
  theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
  geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25,position=dodge) + 
  labs(x = "Priming condition", y = "Mean likelihood of exclusive inference") +
  ggtitle("Participants asked about exclusivity inference on every trial")

toplot = d %>%
  filter(type == "crit" & !(meaningprime == "oneshot") & meaningprime == "orthog" & is.na(firstconj)) %>%
  group_by(utteranceprime) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

ggplot(toplot, aes(x=utteranceprime,y=Mean)) +
  geom_bar(stat="identity") +
  theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
  geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25) + 
  labs(x = "Priming condition", y = "Mean likelihood of exclusive inference") +
  ggtitle("Participants asked about orthogonal inference on priming trials")

# various 'noprime' conditions 

d[!(is.na(d$firstconj)),]$meaningprime <- "orthog_firstconj"

toplot_noprime = d %>%
  filter(type == "crit" & utteranceprime == "noprime") %>%
  group_by(meaningprime) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

ggplot(toplot_noprime, aes(x=meaningprime,y=Mean)) +
  geom_bar(stat="identity",position = "dodge") +
  theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
  geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25) + 
  labs(x = "Priming condition", y = "Mean likelihood of exclusive inference") +
  ggtitle("Behavior in the various 'no prime' conditions")


toplot_prime = d %>%
  filter(type == "prime" || type == "filler" ) %>%
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
  filter(type != "filler") %>%
  group_by(Answer.condition,type) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

toplot_subjectvar_bysubject = d %>%
  filter(type != "filler") %>%
  group_by(Answer.condition,type,workerid) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

toplot_subjectvar$type <- relevel(toplot_subjectvar$type, ref = "prime")

ggplot(toplot_subjectvar, aes(x=type,y=Mean)) +
  geom_bar(stat="identity") + 
  facet_wrap(~Answer.condition) +
  geom_line(data = toplot_subjectvar_bysubject, aes(group=workerid), color = "red", alpha = 0.5) + 
  theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
  geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25) + 
  geom_point(data = toplot_subjectvar_bysubject)
  labs(x = "Priming condition", y = "Mean likelihood of exclusive inference")

fillers = d %>%
  filter(type == "\"filler\"")

p <- ggplot(fillers, aes(x=response)) +
  geom_histogram() + 
  facet_wrap(~workerid)

p
  
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

d$utteranceprime <- factor(d$utteranceprime)
d$utteranceprime <- relevel(d$utteranceprime, ref="noprime")

model = lm(response ~ utteranceprime*meaningprime, data=d[d$type == "crit" & is.na(d$firstconj) & !(d$meaningprime == "oneshot"),]) 
model1 = lm(response ~ utteranceprime, data=d[d$type == "crit" & d$meaningprime == "exclu",])
model2 = lm(response ~ utteranceprime, data=d[d$type == "crit" & d$meaningprime == "orthog",])


