setwd("~/Documents/GitHub/ad_qp")

d <- read.csv("results/6scale_full/results.csv",header = TRUE, stringsAsFactors = FALSE)

theta <- function(x,xdata,na.rm=T) {mean(xdata[x],na.rm=na.rm)}

ci.low <- function(x,na.rm=T) {
  mean(x,na.rm=na.rm) - quantile(bootstrap(1:length(x),1000,theta,x,na.rm=na.rm)$thetastar,.025,na.rm=na.rm)}
ci.high <- function(x,na.rm=T) {
  quantile(bootstrap(1:length(x),1000,theta,x,na.rm=na.rm)$thetastar,.975,na.rm=na.rm) - mean(x,na.rm=na.rm)}

library(tidyverse)
library(bootstrap)
library(formatR)
library(reshape)

# there were some major problems with data collection, but thankfull enough identifying information to recover the dataset.

d <- data.frame(lapply(d, function(x) {
  gsub('"', '', x)
}))

d <- data.frame(lapply(d, function(x) {
  gsub('\\\\', '', x)
}))

d$response <- as.numeric(d$response)

# functions for plotting 

toplot <- function (data) {
 output <- data %>% 
    filter(type == "crit") %>%
    group_by(target, utteranceprime) %>%
    summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response),n=n()) %>%
    ungroup() %>%
    mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)
  return(output)
}

plot_means <- function (toplot) {
  ggplot(toplot, aes(x=utteranceprime,y=Mean)) +
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
  group_by(utteranceprime,type,target) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response),n=n()) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)
  output$type <- relevel(output$type, ref = "prime")
  return(output)
} 

toplot_subjectvar_bysubject <- function(data) {
    output = data %>%
    filter((type %in% c("crit","prime"))) %>%
    group_by(utteranceprime,type,target,workerid) %>%
    summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
    ungroup() %>%
    mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)
    output$type <- relevel(output$type, ref = "prime")
    return(output)
}
  
plot_subjectvar <- function(subjectvar, subjectvar_bysubject) {
  ggplot(subjectvar, aes(x=type,y=Mean)) +
    geom_bar(stat="identity") +
    facet_grid(utteranceprime ~ target) +
    geom_line(data = subjectvar_bysubject, aes(group=workerid), color = "red", alpha = 0.5) + 
    theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
    geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25) +  
    geom_point(data = subjectvar_bysubject) +
    ggtitle("Change in behavior between priming and critical trials, \n broken down by subject") +
    labs(x = "Trial type", y = "Interpretation (100 = maximum exhaustivity inference)") +
    scale_x_discrete(labels=c("Priming trials (mean)", "Critical trial"))
}

# Plotting with no exclusions

toplot_noexcl <- toplot(d)

# plot_means(toplot_noexcl)

toplot_subjectvar_noexcl <- toplot_subjectvar(d)

toplot_subjectvar_bysubject_noexcl <- toplot_subjectvar_bysubject(d)

# plot_subjectvar(toplot_subjectvar_noexcl, toplot_subjectvar_bysubject_noexcl)

# Strict exclude: any high_right < 50, or any low_right > 50

d$correct <- 0
d[d$id %in% c("high_right1","high_right2","high_right3"),]$correct <- "high"
d[d$id %in% c("low_right1","low_right2","low_right3"),]$correct <- "low"

strictexclude_list <- d %>%
  group_by(workerid, id, correct) %>%
  summarize(response) %>%
  filter((correct == "high" && response < 50) || (correct == "low" && response > 50))

d_strictfiltered <- d %>% 
  filter(!(workerid %in% strictexclude_list$workerid))

toplot_strictexcl <- toplot(d_strictfiltered)

# plot_means(toplot_strictexcl)

toplot_subjectvar_strictexcl <- toplot_subjectvar(d_strictfiltered)

toplot_subjectvar_bysubject_strictexcl <- toplot_subjectvar_bysubject(d_strictfiltered)

# plot_subjectvar(toplot_subjectvar_strictexcl, toplot_subjectvar_bysubject_strictexcl)

# absolute-mean criterion: avg of high_right < 50, or avg of low_right > 50

absmeanexclude_list_low <- d %>%
  group_by(workerid, correct) %>%
  filter(correct %in% c("high","low")) %>%
  summarize(Mean = mean(response)) %>%
  filter(Mean > 50) %>%
  filter(correct == "low") 

absmeanexclude_list_high <- d %>%
  group_by(workerid, correct) %>%
  filter(correct %in% c("high","low")) %>%
  summarize(Mean = mean(response)) %>%
  filter(Mean < 50) %>%
  filter(correct == "high") 

d_absmeanfiltered <- d %>% 
  filter(!(workerid %in% absmeanexclude_list_low$workerid)) %>%
  filter(!(workerid %in% absmeanexclude_list_high$workerid))

# relative-mean exclusion: avg of high_right < avg of low_right 

subjmeans <- cast(d, workerid ~ correct, mean, value = "response", subset = correct %in% c("high","low"))

relmeanexclude_list <- subjmeans %>%
  filter(high < low)

# bad-better-than-good exclusion: any high < any low

bad_better <- function(data, worker) {
  worker_highfillerdata <- data %>%
    filter(workerid == worker) %>% 
    filter(correct == "high")
  worker_lowfillerdata <- data %>%
    filter(workerid == worker) %>% 
    filter(correct == "low")
  result <- FALSE
  for(high_observation in worker_highfillerdata$response){
    for(low_observation in worker_lowfillerdata$response){
      if(high_observation < low_observation) {
        result <- TRUE
      }
    }
  }
  return(result)
}

# for(worker in unique(d$workerid)){
#  if(bad_better(d, worker)){
#    print(worker)
#  }
# }

# difference-in-means exclude: participants are excluded if mean(high) - mean(low) < N 

diffmeanexclude_list <- subjmeans %>%
  filter(abs(high - low) < 10)

# lax exclude: participants are excluded for making N or more mistakes, for N > 1.

laxexclude_list <- d %>%
  group_by(workerid, id, correct) %>%
  summarize(response) %>%
  filter((correct == "high" && response < 50) || (correct == "low" && response > 50)) %>%
  group_by(workerid) %>%
  summarize(n_mistakes = n()) %>%
  filter(n_mistakes > 1)



