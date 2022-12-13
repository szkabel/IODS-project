# Abel Szkalisity
# Data wrangling for IODS Week 6

library(tidyverse)
library(magrittr)

# 1) read and interrpet (1p)
bprs = as_tibble(read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep = ' ', header = T))
bprs
str(bprs)

# 40 observations (20 subjects in 2 treatment groups each) and 11 variables. 
# 2 variables (treatment and subject are identifiers of the subject the other 9 are the weekly measurements.
# The BPRS (brief psychiatric rating scale) measures 18 pschyological conditions on a scale (likely it's a sum of it)
# so it's on at least an interval scale, it's not categorical.

rats = as_tibble(read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep = '\t', header = T))
rats
str(rats)

# 16 observations on 13 variables
# Again, 2 variables are identifiers (subject id and treatment ID).
# This data contains Weights of rats on days followed for 9 week, the variable identifiers WD refers to Weight on Day X.
# only the identifiers are categorical

# 2) convert to factor (1p)
bprs %<>% mutate(treatment = as_factor(treatment), subject = as_factor(subject))
rats %<>% mutate(ID = as_factor(ID), Group = as_factor(Group))

# 3) Convert to long form (1p)
bprs_long = bprs %>% pivot_longer(cols = -c("treatment","subject"), names_to = "Week", values_to="BPRS")
rats_long = rats %>% pivot_longer(cols = -c("ID","Group"), names_to = "Time", values_to="Weight")

# 4) Understand pivoted forms (2p)
bprs_long
str(bprs_long)
rats_long
str(rats_long)
# Pivoting transforms the data so that it is "tidy" namely that each measurement is in its own row.
# It makes sense for bprs e.g. we had 40 observations over 9 weeks translating to 360 observations in total.
# This is exactly how many rows bprs_long has.
# I would not like to over-explain this (it's not that difficult) I hope this prooves that I "seriously" got the point.

# I have defined myself the variable names, the identifier columns are the same in both long format.
# Week and Time ofc contains the original time-points for the measurement. Note: it may worth converting these
# time-point variables to a factor so that the ordering of the time-points is increasing.
# However, that conversion would not be saved anyways by the write_csv so I'd keep this for the analysis exercise.
# BPRS and Weight are the measurement values themselves (usually named just "value" after pivoting).

bprs_long %>% write_csv('data/bprs_long.csv')
rats_long %>% write_csv('data/rats_long.csv')
