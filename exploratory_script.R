library(dplyr)
                           # reading data
data <- read.csv(file="~/Desktop/Tools/trafficdata/traffic-data.csv", sep=",")

                           # exploring data a bit
data %>% summary()
# count duplicates
data %>% nrow() - data %>% unique() %>% nrow() #0
# see if there are meaningful names
data %>% names()
# check ratio of NA
data %>% is.na() %>% mean() #0.0713
# count unique values in each column
col_uniq_cnt <- data %>% sapply(function(x) x %>% unique() %>% length)
# get columns with unique values less than 5
sparse_columns <- col_uniq_cnt[col_uniq_cnt < 5]
# remove constant columns
data <- data[,col_uniq_cnt[col_uniq_cnt > 1] %>% names()]

# <<<INFORMATION>>>
# rd.nm        = road name
# rd.rp.nm     = name of user
# rd.rp.fullnm = full name of user

# get user names
uniq_usr_nm <- data$rd.rp.nm %>% unique()
# count unique users
uniq_usr_nm %>% length() #16759
# calculate frequency of each user
usr_freq <- data$rd.rp.nm %>% table()
# check if count of unique user names and user full names match
data$rd.rp.nm %>% unique() %>% length() - data$rd.rp.fullnm %>% unique() %>% length() # NO!
# group user names and user full names to see the different, group by user name
# TODO: group by full name, group by user name !!!!!!!!!!!

# get unique road names
rd_nm <- data$rd.nm %>% unique()
# count them
rd_nm %>% length() #301
# read some examples
rd_nm %>% head()
rd_nm %>% tail()

# <<<INFORMATION>>>
# road format is area;segment_and_direction

# sort road names and explore them
rd_nm %>% sort()

# add columns rd.area, rd.from and rd.to
extract_area_and_direction <- function(road_name){
  tokens <- road_name %>% as.character() %>% sapply(function(x){
      a <- x%>% strsplit(split = ';') %>% unlist() %>% trimws()
      b <- a[2] %>% strsplit(split = 'To') %>% unlist() %>% trimws()
      c(a[1], b[1], b[2])
  })
  data.frame(
    rd.area = tokens[1,],
    rd.from = tokens[2,],
    rd.to = tokens[3,]
  )
}

# Try to find any relation among unknown road related columns and with the fact of having an area without (from,to) pair
data <- data %>% cbind(data$rd.nm %>% extract_area_and_direction())
data <- data %>% cbind(data$rd.from %>% sapply(function(x) x %>% is.na()))
data$rd.from.na <- data$rd.from.na %>% as.numeric()
cols <- c('rd.cmrq', 'rd.stid', 'rd.strq', 'rd.ri', 'rd.new', 'rd.from.na')
cor_mat = cor(data[,cols], use = 'complete')
corrplot(cor_mat, method='complete')
# There seem to be a strong inverse relation between rd.cmrq and rd.strq but not sure what that means
data$rd.strq.eq.cmrq <- !xor(data$rd.strq, data$rd.cmrq) %>% as.numeric()
cor_mat = cor(data[,c('rd.strq.eq.cmrq', 'rd.from.na')], use = 'complete')
corrplot(cor_mat, method = 'shade')
# There seem to be a strong relation between the 2 columns, but yet not meaningful

# <<<INFORMATION>>>
# each segment exists in both directions, yet to be confirmed


# play around dates
# TODO: play around dates !!!!!!!!!!!