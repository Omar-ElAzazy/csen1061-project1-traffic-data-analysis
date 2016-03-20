                           # reading data
data <- read.csv(file="~/Desktop/Tools/trafficdata/traffic-data.csv", sep=",")

                           # exploring data a bit
summary(data)
# count duplicates
nrow(data) - nrow(unique(data)) #0
# see if there are meaningful names
names(data)
# check ratio of NA
length(data[is.na(data)]) / (nrow(data) * ncol(data)) #0.0713
# count unique values in each column
col_uniq_cnt <- sapply(data, function(x) length(unique(x)))
# get columns with unique values less than 5
sparse_columns <- unique_count[unique_count < 5]
# remove constant columns
data <- data[,names(col_uniq_cnt[col_uniq_cnt > 1])]

# <<<INFORMATION>>>
# rd.nm        = road name
# rd.rp.nm     = name of user
# rd.rp.fullnm = full name of user

# get user names
usrs <- unique(data$rd.rp.nm)
# count unique users
length(usrs) #16759
# calculate frequency of each user
usr_freq <- table(data$rd.rp.nm)
# check if count of unique user names and user full names match
length(unique(data$rd.rp.nm)) - length(unique(data$rd.rp.fullnm)) # NO!
# group user names and user full names to see the different, group by user name
# TODO: group by full name, group by user name !!!!!!!!!!!

# get unique road names
rd_nm <- unique(data$rd.nm)
# count them
length(rd_nm) #301
# read some examples
head(rd_nm)
tail(rd_nm)

# <<<INFORMATION>>>
# road format is area;segment_and_direction

# sort road names and explore them
sort(rd_nm)

# <<<INFORMATION>>>
# each segment exists in both directions, yet to be confirmed


# play around dates
# TODO: play around dates !!!!!!!!!!!