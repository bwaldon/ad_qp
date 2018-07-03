setwd("~/Documents/GitHub/ad_qp")
d <- read.csv("results/6scale/6scale_anonymized.csv",header = TRUE, stringsAsFactors = FALSE)

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

levels(d$target) <- c("none","some","or","n","lookslike", "tasty", "hard")

d[d$id %in% c("reunion","vote","yoga","football"),]$target <- "some"
d[d$id %in% c("inherit","birthday","mail","party"),]$target <- "or"
d[d$id %in% c("rain","car","son","golden"),]$target <- "lookslike"
d[d$id %in% c("library","cookies","chairs","bus"),]$target <- "n"
d[d$id %in% c("homework","hospital"),]$target <- "hard"
d[d$id %in% c("foodtruck","beer","wine","indian"),]$target <- "tasty"

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

d$response <- as.numeric(d$response) / 100

toplot <- d %>% 
  filter(target %in% c("or","some","lookslike","n") & type == "crit") %>%
  group_by(target, utteranceprime) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

ggplot(toplot, aes(x=utteranceprime,y=Mean)) +
  facet_wrap(~target) +
  geom_bar(stat="identity") +
  theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
  geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25) + 
  labs(x = "Prime", y = "Interpretation (1 = maximum exhaustivity inference)") +
  ggtitle("Strength of exhaustivity interpretations by prime \ntype")

