# This script is for cleaning new rodent data.  Data must first be entered in two separate sheets in
# an excel file, by two different people to reduce entry error.

library(XLConnect)

source('compare_raw_data.r')
source('compare_tags.r')
source('check_reproductive_status.r')
source('check_all_plots_present.r')
source('check_stake_duplicates.r')
source('check_missing_data.r')

##############################################################################
# New file to be checked
##############################################################################

newperiod = '447'
filepath = 'C:/Users/EC/Dropbox/Portal/PORTAL_primary_data/Rodent/Raw_data/New_data/'

newfile = paste(filepath, 'newdat', newperiod, '.xlsx', sep='')
scannerfile = paste(filepath, 'tag scans/tags', newperiod, '.txt', sep='')

##############################################################################
# 1. Compare double-entered data -- will return 'Worksheets identical' if versions match
##############################################################################

compare_worksheets(newfile)

##############################################################################
# 2. Quality control - some general error checks
##############################################################################

# load data from excel workbook
wb = loadWorkbook(newfile)
ws = readWorksheet(wb, sheet = 1, header = TRUE,colTypes = XLC$DATA_TYPE.STRING)

# Compare tag numbers entered on sheets to scanner download
compare_tags(ws,scannerfile)

# Check that reproductive charactaristics match M/F designation
male_female_check(ws)

# Check all plots present in data
all_plots(ws)

# Check for duplicate stake numbers within a plot
suspect_stake(ws)

# Flag missing data
#   -fields all lines of data should have
check_missing_data(ws,fields = c('mo','dy','yr','period','plot'))
#   -fields that should be filled, excluding cases that already have a flag
#    in the note1 field
check_missing_data(ws[is.na(ws$note1),],fields=c('stake','species','sex','hfl','wgt'))
#   - NOTE: does not check for missing tag or sexual characteristics


