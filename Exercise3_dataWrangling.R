# Name: Abel Szkalisity
# Date: 21st Nov 2022
# This is my data-wrangling script for IODS week 3
# The data in this exercise was downloaded from: https://archive.ics.uci.edu/ml/machine-learning-databases/00320/student.zip

library(tidyverse)
library(magrittr)

# 3. ----
matDf = as_tibble(read.csv('data/student-mat.csv', sep = ';'))
porDf = as_tibble(read.csv('data/student-por.csv', sep = ';'))

dim(matDf)
# 395 observation and 33 variable
str(matDf)
# Some characters and integers as variables.
# The variable names make sense

dim(porDf)
# 649 observation and 33 variable
str(porDf)
# Similar to mat df.
# Are they identical?
all(names(matDf) == names(porDf))
# Yes.

# 4. ----
# Note: the data is on 2 courses on probably similar students. So indeed joining makes sense,
# but pay attention to the conflicting variable names.
free_cols = c("failures", "paid", "absences", "G1", "G2", "G3");
join_cols = setdiff(names(porDf), free_cols)
df = inner_join(matDf, porDf, by = join_cols)


# 5. Get rid of the duplications ----
# Could it be that it's easier to do this by first binding the rows?
# Important: we have to keep only the groups where both had observations
tmp = bind_rows(math = matDf, portugese = porDf, .id = "source") %>% group_by(across(join_cols)) %>% 
  mutate(inGroups = length(unique(source))) %>% filter(inGroups == 2)
df = inner_join(
  tmp %>% select(contains(join_cols) | where(is.numeric)) %>% summarise(across(contains(free_cols),function(x)(round(mean(x))))) %>% ungroup(),
  tmp %>% select(contains(join_cols) | !where(is.numeric)) %>% summarise(across(contains(free_cols),first)) %>% ungroup()
)

#full_join(df,as_tibble(alc)) gives the same amount of rows, so this is identical. And I think more elegant.

# 6. Make an alc_use column, and the bool ----
df %<>% {mutate( . ,alc_use = rowMeans( (.) %>% select(contains("alc"))))} %>% 
  mutate(high_use = if_else(alc_use>2,TRUE,FALSE))

# 7. Glimpse ----
df
# 370 observations
write_csv(df,'data/student_joint.csv')
