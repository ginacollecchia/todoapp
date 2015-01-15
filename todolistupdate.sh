#!/bin/sh
#
# Name: todolistupdate.sh
# Author: Regina Collecchia (ginacollecchia@gmail.com)
# Date: Jan 15, 2015
# Description: 
# Shell script to track changes in a to-do list text file. Additions and
# deletions are tracked separately and then compared at the end of the day,
# in the separate script todoarchive.sh.
# At the start of the day, these files should be in the Archive folder:
# 	- work_yesterday.txt
#	- work_today_temp.txt
#	- the folder "2015" which contains subfolders of each month
# They will be the same at the end of the day. "work_yesterday" only changes
# once a day, while work_today_temp gets updated every 30 minutes to reflect
# the second-to-most recent update of the Work.txt file.
#
# The files that should hang around after this script runs are:
#	- work_yesterday.txt
#	- work_today_temp.txt
#	- all_completed_items_sorted.txt
# 	- all_new_items_sorted.txt
#	- 2015
#
# Monthly digests are generated in todomonthlydigest.sh.

cd ~/Library/Application\ Support/Notational\ Data/Archive/
# save current to do list, "Work.txt", as my work to-do as of today
scp ../Work.txt work_today.txt
# make a copy only if it doesn't exist
cp -n work_yesterday.txt work_today_temp.txt

# note new items; these are on unsorted lists
diff work_today.txt work_today_temp.txt | grep "< " > new_and_moved_items.txt
# note removed items
diff work_today.txt work_today_temp.txt | grep "> " > completed_items.txt
# remove less than sign and whitespace
cat new_and_moved_items.txt | while read line
do
	echo $line | tail -c +3
done > new_and_moved_items2.txt

# create this file if it doesn't exist
touch all_new_items_sorted.txt | exit
# combine newly added items with existing added items
echo "$(cat new_and_moved_items2.txt all_new_items_sorted.txt)" > updated_items.txt
# sort and remove duplicates
sort updated_items.txt | uniq > all_new_items_sorted.txt
# create this file if it doesn't exist
touch all_completed_items_sorted.txt | exit
# remove less than sign and whitespace
cat completed_items.txt | while read line
do
	echo $line | tail -c +3
done > completed_items2.txt
# combine newly completed items with existing completed items
echo "$(cat completed_items2.txt all_completed_items_sorted.txt)" > updated_completed_items.txt
# remove dupes
sort updated_completed_items.txt | uniq > all_completed_items_sorted.txt

# print message to console
# echo "The following items were added or moved around on today's to-do list: "
# echo "" | more all_new_items_sorted.txt

# cleanup
rm new_and_moved_items.txt
rm new_and_moved_items2.txt
rm completed_items.txt
rm completed_items2.txt
rm updated_completed_items.txt
# now we can just compare the updated "work_today" files; "work_yesterday" should only be the work done yesterday, not an intermediate file
scp work_today.txt work_today_temp.txt
rm work_today.txt
rm updated_items.txt