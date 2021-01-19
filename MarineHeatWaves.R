# -------------------------------------------------------------------------------------------- #
# - FILE NAME:   MarineHeatWaves.R         
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
# 2. Download Sea Surface Temperature (SST) data from NOAA
# 3. Calculate Marine HeatWaves (MHWs) at the location where the filamentous morphology was found



############ 1. Load libraries and data ####
### Load required packages
library(heatwaveR)
library(dplyr)
library(ggplot2)
library(tidyverse)
library(rerddap)


## Package example
sst_WA

ts <- ts2clm(sst_WA, climatologyPeriod = c("1982-01-01", "2018-12-31")) ## Calculate climatology
mhw <- detect_event(ts)

event_line(mhw, spread = 600, metric = "intensity_max", 
           start_date = "2011-01-01", end_date = "2012-12-31")



############ 2. Download SST data from NOAA ####

### Ponta Veslo (Montenegro)
# Minimum distance allowed between coordinates is 0.25
OISST_sub <- function(time_df){
  oisst_res <- griddap(x = "ncdc_oisst_v2_avhrr_by_time_zlev_lat_lon", 
                       url = "https://www.ncei.noaa.gov/erddap/", 
                       time = c(time_df$start, time_df$end), 
                       depth = c(0, 0),
                       latitude = c(42.15, 42.40),  ## Coordinates of interest
                       longitude = c(18.45, 18.70), ## Coordinates of interest
                       fields = "sst")$data %>% 
    mutate(time = as.Date(stringr::str_remove(time, "T00:00:00Z"))) %>% 
    dplyr::rename(t = time, temp = sst) %>% 
    select(lon, lat, t, temp) %>% 
    na.omit()
}


## Select the years to extract the data. The download does not allow to download more than 9 years
## So we have to create packages of "dates"
dl_years <- data.frame(date_index = 1:5,
                       start = as.Date(c("1985-01-01", "1990-01-01", 
                                         "1998-01-01", "2006-01-01","2016-01-01")),
                       end = as.Date(c("1989-12-31", "1997-12-31", 
                                       "2005-12-31", "2015-12-31","2019-12-31")))


system.time(
  OISST_Veslo <- dl_years %>% 
    group_by(date_index) %>% 
    group_modify(~OISST_sub(.x)) %>% 
    ungroup() %>% 
    select(lon, lat, t, temp)
)
## Sometimes it can take some time to download the data, depending on your area of study and the years extracted



############ 3. Calculate MHWs at the study site and for the period of interest ####

## Calculate climatology with downloaded data
ts_veslo <- ts2clm(OISST_Veslo, climatologyPeriod = c("1985-01-01", "2019-12-31")) 
mhw <- detect_event(ts_veslo)

## Plot the grapth for the period of interest
event_line(mhw, spread = 220, metric = "intensity_max", 
           start_date = "2018-01-01", end_date = "2018-12-31")

event_line(mhw, spread = 220, metric = "intensity_max", 
           start_date = "2018-01-01", end_date = "2018-12-31", category=T)


######## Hand made grapth
# Select the region of the time series of interest
mhw2 <- mhw$climatology %>% 
  slice(48213:49908)

mhw2
tail(mhw2)

# It is necessary to give geom_flame() at least one row on either side of 
# the event in order to calculate the polygon corners smoothly

mhw_top <- mhw2 %>% 
  slice(575:850)

ggplot(data = mhw2, aes(x = t)) +
  geom_flame(aes(y = temp, y2 = thresh, fill = "All"), show.legend = T) +
  geom_flame(data = mhw_top, aes(y = temp, y2 = thresh, fill = "Most Severe"),  show.legend = T) +
  geom_line(aes(y = temp, colour = "2018 Sea Surface Temperature")) +
  geom_line(aes(y = thresh, colour = "Threshold"), size = 1.0, alpha=0.8) +
  geom_line(aes(y = seas, colour = "Climatology"), size = 1.2, alpha=0.7) +
  scale_colour_manual(name = "Temperatures",
                      values = c("2018 Sea Surface Temperature" = "black", 
                                 "Threshold" =  "forestgreen", 
                                 "Climatology" = "grey50")) +
  scale_fill_manual(name = "Marine Heat Waves", 
                    values = c("All" = "tomato", 
                               "Most Severe" = "red3")) +
  scale_x_date(date_labels = "%b %Y") +
  scale_y_continuous(limit=c(13,30), breaks=seq(15,30,5)) +
  guides(colour = guide_legend(override.aes = list(fill = NA))) +
  labs(y = expression(paste("Temperature [", degree, "C]")), x = NULL) +
  theme(axis.line = element_line(colour = "black"),
        panel.background = element_rect(fill = "white"),
        panel.grid.major.x = element_blank(),
        panel.grid.major.y =element_line(size = 0.5, linetype = 'solid',colour = "grey90"),
        panel.grid.minor.x = element_blank(),
        plot.title = element_text(size=14, face="bold.italic", hjust=0.5),
        legend.title = element_text(size=13, face="bold"),
        legend.text = element_text(size = 11),
        axis.title = element_text(face = "bold"),
        axis.title.y = element_text(vjust= -1.5, size=13),
        axis.title.x = element_text(vjust= -0.5, size=13),
        axis.text.y = element_text(size=11, face="bold"),
        axis.text.x = element_text(size=11, face="bold"))


####### Lolli-Plot
lolli_plot(mhw, metric="intensity_max")

ggplot(mhw$event, aes(x = date_peak, y = intensity_max)) +
  geom_lolli(colour = "firebrick") +
  labs(x = "Peak Date", 
       y = expression(paste("Max. intensity [", degree, "C]")), x = NULL) +
  theme_linedraw()

### Do the lolli-plot graph from 2015 onwards
summary(mhw$event$date_peak)

mhw_20152018 <- subset(mhw$event, date_peak>"2014-12-31")

ggplot(mhw_20152018, aes(x = date_peak, y = intensity_max)) +
  geom_lolli(colour = "salmon", colour_n = "darkred", n=2) +
  labs(x = "Peak Date", 
       y = expression(paste("Max. intensity [", degree, "C]")), x = NULL) +
  theme_linedraw()
