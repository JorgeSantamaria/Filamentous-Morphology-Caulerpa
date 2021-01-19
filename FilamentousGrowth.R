# -------------------------------------------------------------------------------------------- #
# - FILE NAME:   FilamentousGrowth.R         
# - DATE:        19/01/2021
# - TITLE: Stressful Conditions Give Rise to a Novel and Cryptic Filamentous Form of Caulerpa cylindracea
# - AUTHORS: Jorge Santamaría, Raül Golo, Emma Cebrian, María García, Alba Vergés
# - SCRIPT: J. Santamaría (jorge.santamaria@udg.edu) & R. Golo (raul.gonzalez@udg.edu)
# - JOURNAL: Frontiers in Marine Science
# -------------------------------------------------------------------------------------------- #

# DISCLAMER: This script has been developed by an ecologist, not a programer, 
# so please take into account that the code may have room to be omptimized. 
# Positive feedback will always be more than welcome.


# Script Content------------------------------------------------ 
# 1. Load libraries and data
# 2. Compare area of Caulerpa cylindracea, between treatments, at the beginning and end of the extreme temperature experiment
# 3. Compare thickness of C. cylindracea filaments vs thickness of C. cylindracea stolons from different populations



############ 1. Load libraries and data ####
### Load required packages
library(dplyr)
library(ggplot2)
library(ggpubr)
library(car)
library(rstatix)
library(lme4)
library(emmeans)
library(lmerTest)

### Set workind directory to the place where you have the data stored
setwd("DataPath")



############ 2. Compare area of C. cylindracea at beginning/end of experiment ####

### Load the data
load("Area.RData")
summary(Area)


#### DATA SUMMARY ####
### Summarize data with dplyr to get the mean, sd, se, ...

## Group data and get the summarized information
# 1) By Time
Start_End <- group_by(Area, Treatment, Time) %>%
  summarise(mean_area=mean(Area), sd=sd(Area), se=sd(Area)/sqrt(length(Time)), n=length(Time))
Start_End

Start_End$Time <- factor(Start_End$Time, levels=c("Start", "End"))


#### BARPLOTS to plot the data ####
ggplot(Start_End, aes(x=Treatment, y=mean_area, fill=Time)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=mean_area-se, ymax=mean_area+se),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9)) +
  scale_y_continuous(name = c(expression(paste(bold("Mean area of "), bolditalic("Caulerpa cylindracea "), bold("± S.E")))), limit=c(0,10), breaks=seq(0,10,1)) +
  ## ggtitle("Menorca") +
  ## scale_x_discrete(limits=c("October", "July")) +  If you want to change the order of the levels in the x axis and only choose some
  theme(axis.line = element_line(colour = "black"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y =element_line(size = 0.5, linetype = 'solid',colour = "grey90"),
        panel.grid.minor.x = element_blank(),
        axis.title = element_text(face = "bold"),
        axis.title.y = element_text(vjust= 1.8, size=20),
        axis.title.x = element_text(vjust= -0.5, size=20),
        axis.text.y = element_text(size=18, face="bold"),
        axis.text.x = element_text(size=18, face="bold"), 
        legend.title = element_text(size=20, face="bold"),
        legend.text = element_text(size=18), 
        legend.position = "bottom",
        plot.title = element_text(size=20, face="bold", hjust=0.5))


######## MODEL to analyze the data ####

## Check for outliers in the data
Area %>%
  group_by(Treatment, Time) %>%
  identify_outliers(Area)
# No outliers


## Check normality of data
Area %>%
  group_by(Treatment, Time) %>%
  shapiro_test(Area)
# Data normally distributed at each level


## Model to assess whether there are significant differences between treatments at the end
# We do a mixed model to take into account the repeated measurements of the Replicates
model <- lmer(Area~Treatment*Time+(1|Replicate), data=Area)
summary(model)
Anova(model, test="F")

qqPlot(residuals(model))

## Tukey post-hoc test
pairs(emmeans(model, ~ Treatment | Time)) ## Significant differences at the end between the 2 treatments
pairs(emmeans(model, ~ Time | Treatment)) ## Significant differences at each treatment between times



############ 3. Compare the thickness of C. cylindracea structures ####

### Load the data
load("Filaments.RData")
summary(Filaments)


#### DATA SUMMARY ####
### Summarize data with dplyr to get the mean, sd, se, ...

## Group data and get the summarized information
# 1) By Morphology
Fil_Stol <- group_by(Filaments, Morphology) %>%
  summarise(mean_size=mean(Size_Mean), sd=sd(Size_Mean), se=sd(Size_Mean)/sqrt(length(Morphology)), n=length(Morphology))
Fil_Stol


#### BARPLOTS to plot the data ####
ggplot(Fil_Stol, aes(x=Morphology, y=mean_size, fill=Morphology)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=mean_size-se, ymax=mean_size+se),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9)) +
  scale_y_continuous(name = c(expression(paste(bold("Mean width of "), bolditalic("Caulerpa cylindracea "), bold("± S.E")))), limit=c(0,2400), breaks=seq(0,2400,200)) +
  ## ggtitle("Menorca") +
  ## scale_x_discrete(limits=c("October", "July")) +  If you want to change the order of the levels in the x axis and only choose some
  theme(axis.line = element_line(colour = "black"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y =element_line(size = 0.5, linetype = 'solid',colour = "grey90"),
        panel.grid.minor.x = element_blank(),
        axis.title = element_text(face = "bold"),
        axis.title.y = element_text(vjust= 1.8, size=20),
        axis.title.x = element_text(vjust= -0.5, size=20),
        axis.text.y = element_text(size=18, face="bold"),
        axis.text.x = element_text(size=18, face="bold"), 
        legend.title = element_text(size=20, face="bold"),
        legend.text = element_text(size=18), 
        legend.position = "bottom",
        plot.title = element_text(size=20, face="bold", hjust=0.5))


## Group data and get the summarized information
# 1) By Location
Fil_Stol_Loc <- group_by(Filaments, Morphology, Location) %>%
  summarise(mean_size=mean(Size_Mean), sd=sd(Size_Mean), se=sd(Size_Mean)/sqrt(length(Morphology)), n=length(Morphology))
Fil_Stol_Loc


#### BARPLOTS to plot the data ####
ggplot(Fil_Stol_Loc, aes(x=Morphology, y=mean_size, fill=Location)) + 
  geom_bar(position=position_dodge(), stat="identity") +
  geom_errorbar(aes(ymin=mean_size-se, ymax=mean_size+se),
                width=.2,                    # Width of the error bars
                position=position_dodge(.9)) +
  scale_y_continuous(name = c(expression(paste(bold("Mean width of "), bolditalic("Caulerpa cylindracea "), bold("± S.E")))), limit=c(0,2400), breaks=seq(0,2400,200)) +
  ## ggtitle("Menorca") +
  ## scale_x_discrete(limits=c("October", "July")) +  If you want to change the order of the levels in the x axis and only choose some
  theme(axis.line = element_line(colour = "black"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y =element_line(size = 0.5, linetype = 'solid',colour = "grey90"),
        panel.grid.minor.x = element_blank(),
        axis.title = element_text(face = "bold"),
        axis.title.y = element_text(vjust= 1.8, size=20),
        axis.title.x = element_text(vjust= -0.5, size=20),
        axis.text.y = element_text(size=18, face="bold"),
        axis.text.x = element_text(size=18, face="bold"), 
        legend.title = element_text(size=20, face="bold"),
        legend.text = element_text(size=18), 
        legend.position = "bottom",
        plot.title = element_text(size=20, face="bold", hjust=0.5))


######## MODEL to analyze the data ####

## Check for outliers in the data
Filaments %>%
  group_by(Location, Morphology) %>%
  identify_outliers(Size_Mean)
# 2 extreme outliers


## Check normality of data
Filaments %>%
  group_by(Location, Morphology) %>%
  shapiro_test(Size_Mean)
# Roses, Rovinj and Split not normally distributed, but QQPlot from model seems OK


## Model to assess whether there are significant differences between filaments and stolons
summary(Filaments)

# Create location_morphology variable
Filaments$Location_Morphology <- interaction(Filaments$Location, Filaments$Morphology)


model_filaments <- lm(Size_Mean~Location_Morphology, data=Filaments)
summary(model_filaments)
Anova(model_filaments, test="F")


qqPlot(residuals(model_filaments))

## Tukey post-hoc test
pairs(emmeans(model_filaments, ~ Location_Morphology)) ## Significant differences between filaments and stolons but not between stolons


