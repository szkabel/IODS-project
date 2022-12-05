# Abel Szkalisity
# Data wrangling for week 5 (part of week 4 exercises)
# Continued data wrangling on week 5.

# ************** WEEK 4 ************** ----

library(tidyverse)
library(magrittr)

# 1. load

hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# Links to metadata just to have it at hand
# https://hdr.undp.org/data-center/human-development-index#/indicies/HDI
# https://hdr.undp.org/system/files/documents//technical-notes-calculating-human-development-indices.pdf

# 2. structure

dim(hd)
# 195 obs with 8 variable
str(hd)
# Mostly numerical, but a "Country" variable is character (should be likely factor)

dim(gii)
# 195 var 10 variable
str(gii)
# Mostly numerical, but again countries as character

# 3-4. renaming and creating the new variables
hd %<>% rename(hdi.rank = `HDI Rank`, 
              HDI = `Human Development Index (HDI)`,
              Life.exp = `Life Expectancy at Birth`,
              Edu.Exp = `Expected Years of Education`,
              Edu.Mean = `Mean Years of Education`,
              GNI = `Gross National Income (GNI) per Capita`,
              GNI.HDI.diff = `GNI per Capita Rank Minus HDI Rank`)

gii %<>% rename(gii.rank = `GII Rank`,
               gii = `Gender Inequality Index (GII)`,
               Mat.Mor = `Maternal Mortality Ratio`,
               Ado.Birth = `Adolescent Birth Rate`,
               Parli.F = `Percent Representation in Parliament`,
               Edu2.F = `Population with Secondary Education (Female)`,
               Edu2.M = `Population with Secondary Education (Male)`,
               Labo.F = `Labour Force Participation Rate (Female)`,
               Labo.M = `Labour Force Participation Rate (Male)`) %>% 
        mutate(Edu2.FM = Edu2.F / Edu2.M,
               Labo.FM = Labo.F / Labo.M)

# Creation of human dataset
human = inner_join(hd,gii)
  
dim(human)
# 195 19, this is correct
human %>% write_csv('data/human.csv')

# ************** WEEK 5 ************** ----
# Continued wranling

human = read_csv('data/human.csv')

# The data contains various social features of countries of the world including Humen development index (HDI) ,
# the proportion of women in parliement, the participation of sexes in the labour market etc.
# For complete explanation see the rows above where the longer variable names were reduced to the short forms.
# It contains altogether 19 variables on 195 countries

# 1 GNI mutation
# Well, by using the tidyverse functions the GNI is already in numeric (well double, but double is numeric) form
# so nothing to be done here
is.numeric(human$GNI)

human2 = read.table("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human1.txt", 
                              sep =",", header = T)
all(as.integer(str_replace(human2$GNI,',','')) == as.integer(human$GNI))

# 2. exlude variables
human %<>% select(Country, Edu2.FM,Labo.FM, Edu.Exp, Life.exp, GNI, Mat.Mor, Ado.Birth, Parli.F)

# 3. remove missing data
human %<>% filter(!apply(is.na(human),1,any))

# 4. remove regions
# After inpsecting the data the following rows are regions
human %<>% filter(! Country %in% c("Arab States","East Asia and the Pacific","Europe and Central Asia","Latin America and the Caribbean","South Asia","Sub-Saharan Africa","World"))

# 5. making rownames
human %<>% column_to_rownames("Country")
# I think we loose the tibble with this operation
str(human)
# 155 obs and 8 var, looks fine

human %>% write.csv('data/human2.csv')
# I prefer to name it differently