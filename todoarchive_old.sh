#!/bin/sh

cd ~/Library/Application\ Support/Notational\ Data/Archive/

# save current to do list, "Work.txt", as my work to-do as of today
scp ../Work.txt work_today.txt

# compare the current to do list to the previous to do list:
# note removed, "completed" (let's hope!) items; dash included in grep
# because that's how i format action items as opposed to day headings
# since work_yesterday is now sorted, we need to sort work_today too 
# and clean up the white space at the beginning
# sort work_today.txt | sed '/./!d' > work_today_so.txt
diff work_today.txt work_yesterday.txt | grep "> " > completed_items.txt
# remove less than sign and whitespace
cat completed_items.txt | while read line
do
	echo $line | tail -c +3
done > completed_items2.txt
# remove items on the completed_items list that are also on the new items list
diff completed_items2.txt all_new_items_sorted.txt | grep "< " > completed_items_final.txt
cat completed_items_final.txt | while read line
do
	echo $line | tail -c +3
done > completed_items_final2.txt

sort completed_items_final2.txt | uniq -d > completed_items_final3.txt

# first make a directory folder if it doesn't exist
mkdir -p "$(date +%Y/%m)"
# save to the archive
scp completed_items_final3.txt "$(date +%Y/%m/%m-%d-%Y)_Completed_Items.txt"
# echo "Completed items successfully saved to disk: "
# echo "" | more completed_items_final3.txt

# cleanup: copy today's work to file for later comparison
scp work_today.txt work_yesterday.txt
scp work_today.txt work_today_temp.txt
rm work_today.txt
rm completed_items.txt
rm completed_items2.txt
rm completed_items_final.txt
rm completed_items_final2.txt
rm completed_items_final3.txt
# delete this and then create it again to wipe it
rm all_new_items_sorted.txt