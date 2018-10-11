library(tidyverse)
library(bootstrap)
library(formatR)
library(reshape)
library(lme4)
library(lmerTest)
library(plyr)

# helpers

theta <- function(x,xdata,na.rm=T) {mean(xdata[x],na.rm=na.rm)}

ci.low <- function(x,na.rm=T) {
  mean(x,na.rm=na.rm) - quantile(bootstrap(1:length(x),1000,theta,x,na.rm=na.rm)$thetastar,.025,na.rm=na.rm)}
ci.high <- function(x,na.rm=T) {
  quantile(bootstrap(1:length(x),1000,theta,x,na.rm=na.rm)$thetastar,.975,na.rm=na.rm) - mean(x,na.rm=na.rm)}

# load data

setwd("~/Documents/GitHub/ad_qp")

d <- read.csv("results/6scale_full/results.csv",header = TRUE, stringsAsFactors = FALSE)

d <- data.frame(lapply(d, function(x) {
  gsub('"', '', x)
}))

d <- data.frame(lapply(d, function(x) {
  gsub('\\\\', '', x)
}))

rawcounts <- d %>%
  group_by(Answer.list) %>%
  summarize(n = n()/32)

# exclusions (using the "lax exclude" criterion)

d$correct <- 0
d[d$id %in% c("high_right1","high_right2","high_right3"),]$correct <- "high"
d[d$id %in% c("low_right1","low_right2","low_right3"),]$correct <- "low"

d$response <- as.numeric(d$response)

d_excl <- d %>%
  group_by(workerid, id, correct, Answer.list) %>%
  summarize(response) %>%
  filter((correct == "high" && response < 50) || (correct == "low" && response > 50)) %>%
  group_by(workerid, Answer.list) %>%
  summarize(n_mistakes = n()) %>%
  filter(n_mistakes > 1)

d <- d %>%
  filter(!(workerid %in% d_excl$workerid)) %>%
  filter(type %in% c("prime","crit"))

# primetype of critical trials is currently 'na' when really it should be the primetype of the prime

fillTheBlanks <- function(x, missing="na"){
  rle <- rle(as.character(x))
  empty <- which(rle$value==missing)
  rle$values[empty] <- rle$value[empty-1] 
  inverse.rle(rle)
}

d$primetype <- fillTheBlanks(d$primetype)

# chunk data into both experiments

d_exh <- d %>%
  filter(Answer.list %in% c("list1_exh","list2_exh"))

counts <- d %>%
  group_by(Answer.list) %>%
  summarize(n = n()/24)

d_str <- d %>%
  filter(Answer.list %in% c("list1_str","list2_str"))

# plotting functions 

dodge = position_dodge(.9)

toplot <- function (data) {
  output <- data %>% 
    filter(type == "crit") %>%
    group_by(target, primetype) %>%
    summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response),n=n()) %>%
    ungroup() %>%
    mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)
  return(output)
}

plot_means <- function (toplot) {
  ggplot(toplot, aes(x=primetype,y=Mean)) +
    facet_wrap(~target) +
    geom_bar(stat="identity") +
    theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
    geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25) + 
    labs(x = "Prime", y = "Interpretation (100 = maximum exhaustivity inference)") +
    ggtitle("Strength of exhaustivity interpretations by prime type")
}

toplot_subjectvar <- function(data){
  output = data %>%
    filter((type == "crit" | type == "prime")) %>%
    group_by(primetype,type,target) %>%
    summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response),n=n()) %>%
    ungroup() %>%
    mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)
  output$type <- relevel(output$type, ref = "prime")
  return(output)
} 

toplot_subjectvar_bysubject <- function(data) {
  output = data %>%
    filter((type %in% c("crit","prime"))) %>%
    group_by(primetype,type,target,workerid) %>%
    summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
    ungroup() %>%
    mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)
  output$type <- relevel(output$type, ref = "prime")
  return(output)
}

plot_subjectvar <- function(subjectvar, subjectvar_bysubject) {
  ggplot(subjectvar, aes(x=type,y=Mean)) +
    geom_bar(stat="identity") +
    facet_grid(primetype ~ target) +
    geom_line(data = subjectvar_bysubject, aes(group=workerid), color = "red", alpha = 0.5) + 
    theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
    geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25) +  
    geom_point(data = subjectvar_bysubject) +
    ggtitle("Change in behavior between priming and critical trials, \n broken down by subject") +
    labs(x = "Trial type", y = "Interpretation (100 = maximum exhaustivity inference)") +
    scale_x_discrete(labels=c("Priming trials (mean)", "Critical trial"))
}


toplot_byitem <- function (data) {
  output <- data %>% 
    filter(type %in% c("prime", "crit")) %>%
    group_by(target, id, primetype) %>%
    summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response),n=n()) %>%
    ungroup() %>%
    mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)
  return(output)
}

toplot_byitem(d_str) -> byitem_str
toplot_byitem(d_exh) -> byitem_exh

library(plyr)

# byitemprime_str$id <- factor(byitemprime_str$id, levels = c("inherit","birthday","mail","party","reunion","vote","yoga","football","rain","car","son","golden","library","chairs","cookies","bus","foodtruck","beer","wine","indian","homework","hospital","education","calculus"))
byitem_str$id <- mapvalues(byitem_str$id, from = c("inherit","birthday","mail","party","reunion","vote","yoga","football","rain","car","son","golden","library","chairs","cookies","bus","foodtruck","beer","wine","indian","homework","hospital","education","calculus"),  to = rep(c("Prime 1", "Prime 2", "Prime 3", "Critical"), 6))
byitem_exh$id <- mapvalues(byitem_exh$id, from = c("inherit","birthday","mail","party","reunion","vote","yoga","football","rain","car","son","golden","library","chairs","cookies","bus","foodtruck","beer","wine","indian","homework","hospital","education","calculus"),  to = rep(c("Prime 1", "Prime 2", "Prime 3", "Critical"), 6))

byitem_exh$id <- factor(byitem_exh$id, levels = c("Prime 1", "Prime 2", "Prime 3", "Critical"))
byitem_exh$primetype <- relevel(factor(byitem_exh$primetype), ref = "no")

detach("package:plyr", unload=TRUE) 

plot_means_byitem <- function (toplot) {
  ggplot(toplot, aes(x=id,y=Mean, fill = primetype)) +
    facet_wrap(~target) +
    geom_bar(stat="identity", position=dodge) +
    theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
    geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25,position=dodge) + 
    labs(x = "Trial type", y = "Interpretation (100 = maximum exhaustivity inference)") +
    ggtitle("Change in behavior from prime to critical trials") 
}


# analysis 

d_exh$primetype <- factor(d_exh$primetype)
d_exh$primetype <- relevel(d_exh$primetype,ref="no")

# maxial models (don't work) can't include interaction in random effect - participant doesn't see both noprime and prime for one scale!!!
m_max_str<- lmer(response ~ primetype * target + (primetype+target|workerid), data =d_str %>% filter(type == "crit"))
m_max_exh<- lmer(response ~ primetype * target + (primetype*target|workerid), data = d_exh %>% filter(type == "crit"))

m_exh <- lmer(response ~ primetype + (1 + primetype|workerid) + (1|target), data = d_exh %>% filter(type == "crit"))
m_str <- lmer(response ~ primetype * target + (1|workerid) + (1|id), data =d_str %>% filter(type == "crit"))


ggplot(d_exh %>% filter(type == "crit"), aes(x = response, fill = target)) + 
  geom_histogram()




