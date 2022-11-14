# Name: Abel Szkalisity
# Date: 13rd Nov 2022
# This is my data-wrangling script for IODS week 2
# Of note, I still find the course organization very-very messy. Information is scattered around R markdown and moodle pages,
# and the descriptions are very fuzzy. For instance it is not clear if we need to write an own R script, or just use the R markdown provided in moodle.

library(tidyverse)
library(magrittr)
df = as_tibble(read.csv('http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt', sep = '\t'))

dim(df)
# The data consist of 183 rows (likely observations) and 60 columns (likely variables).
# Most of the variables are integers except for the last one (gender) which is of character type
# I saved this dataframe into a tibble

#df %>% select("gender", "Age", "Attitude","Points") # And the others are missing... so we cannot start with this.

df = df %>% mutate(Attitude = Attitude/10) # Horrible burnt-in number

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning 
deepColumns = df %>% select(one_of(deep_questions))
# and create column 'deep' by averaging # yuk - this should be done all with tidyverse somehow
df = df %>% mutate(deep = rowMeans(deepColumns))

# select the columns related to surface learning 
surface_columns = df %>% select(one_of(surface_questions))
# and create column 'surf' by averaging
df$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning 
strategic_columns = df %>% select(one_of(strategic_questions))
# and create column 'stra' by averaging
df = df %>% mutate(stra = rowMeans(strategic_columns))

df = df %>% select("gender", "Age", "Attitude","deep","stra","surf","Points")
# We took care of scaling for everything except Attitude with the rowMeans 

df %<>% filter(Points != 0)

dim(df)
str(df)
# This matches with the desc in the ex

write_csv(df,'data/learning2014.csv')
# That's it for data wrangling.