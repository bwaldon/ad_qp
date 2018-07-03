setwd("~/Documents/GitHub/ad_qp")
d_orig <- read.csv("results/or/pilot4_data.csv")
d_rev <- read.csv("results/or/pilot5_data.csv")

# cleaning and transforming data 

d_orig$meaningprime = sapply(strsplit(as.character(d_orig$Answer.condition),"_"), "[", 3)
d_orig[d_orig$meaningprime == "exclu",]$meaningprime <- "exclusive_interpretation" 
d_orig[d_orig$meaningprime == "exlcu",]$meaningprime <- "exclusive_interpretation" #typo from experiment collection
d_orig[d_orig$meaningprime == "orthog",]$meaningprime <- "orthogonal_interpretation" 
d_orig$utteranceprime = sapply(strsplit(as.character(d_orig$Answer.condition),"_"), "[", 2)
d_orig$firstconj = sapply(strsplit(as.character(d_orig$Answer.condition),"_"), "[", 4)

d_orig <- d_orig %>% 
  filter(meaningprime == "exclusive_interpretation")

d_orig_summary = d_orig %>%
  filter(id == "inherit" & is.na(firstconj)) %>%
  group_by(utteranceprime) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

d_rev <- data.frame(lapply(d_rev, function(x) {
            gsub('"', '', x)
             }))

d_rev <- data.frame(lapply(d_rev, function(x) {
  gsub('\\\\', '', x)
}))

d_rev$utteranceprime = sapply(strsplit(as.character(d_rev$Answer.condition),"_"), "[", 2)

d_orig[d_orig$utteranceprime == "andprime",]$utteranceprime <- "and" 
d_orig[d_orig$utteranceprime == "eitherorprime",]$utteranceprime <- "either" 
d_orig[d_orig$utteranceprime == "notbothprime",]$utteranceprime <- "notboth" 
d_orig$utteranceprime <- factor(d_orig$utteranceprime)

d_rev$utteranceprime <- factor(d_rev$utteranceprime)

d_rev$response <- as.numeric(d_rev$response) / 100

d_rev$primeorder <- "reversed"
d_orig$primeorder <- "original"

d_rev_summary = d_rev %>%
  filter(id == "inherit") %>%
  group_by(utteranceprime) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

d_rev$workerid <- as.integer(d_rev$workerid)

d_orig <- d_orig[,c("workerid","response","utteranceprime","primeorder","type","id")]
d_rev <- d_rev[,c("workerid","response","utteranceprime","primeorder","type","id")]

d <- full_join(d_rev,d_orig)

# visualizations 

toplot = d %>%
  filter(id == "inherit" & !(utteranceprime == "noprime") ) %>%
  group_by(primeorder,utteranceprime) %>%
  summarize(Mean = mean(response),CILow=ci.low(response),CIHigh =ci.high(response)) %>%
  ungroup() %>%
  mutate(Ymin=Mean-CILow,Ymax=Mean+CIHigh)

ggplot(toplot, aes(x=primeorder,y=Mean)) +
  facet_wrap(~utteranceprime) +
  geom_bar(stat="identity") +
  theme(axis.text.x=element_text(angle=20,hjust=1,vjust=1)) +
  geom_errorbar(aes(ymin=Ymin,ymax=Ymax),width=.25) + 
  labs(x = "Order", y = "Interpretation (1 = maximum exclusivity inference)") +
  ggtitle("Change in exclusive interpretation between \n'original' and 'reverse' experimental orderings")

