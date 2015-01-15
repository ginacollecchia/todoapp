#!/bin/sh
#
# Name: todomonthlydigest.sh
# Author: Regina Collecchia (ginacollecchia@gmail.com)
# Date: Jan 15, 2015
# Description: 
# Shell script to create a monthly digest of to-dos from a month's worth
# of to-do list text files. Looks to the prior month, since setting a 
# cron job requires the day of the month, which changes depending on the 
# month. So this runs on the first of every month, at midnight.
#
# Works with todolistupdate.sh and todoarchive.sh.

# create monthly digest from all text files
cd ~/Library/Application\ Support/Notational\ Data/Archive/
# since this runs on the first of the month, subtract one month and cd to that directory
cd $(date -v -1m +%Y/%m)
touch "$(date -v -1m +%m-%Y)_Monthly_Digest.txt" | exit

# combine all text files into 1
cat *.txt > "$(date -v -1m +%m-%Y)_Monthly_Digest.txt"
# maybe i'll want to sort in the futch
# sort "$(date -v -1m +%m-%Y)_Monthly_Digest.txt | uniq > Monthly_Digest.txt"
echo "Monthly digest created for the month of $(date -v -1m +%m/%Y)."