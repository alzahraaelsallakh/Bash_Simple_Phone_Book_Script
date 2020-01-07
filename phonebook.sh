#!/bin/bash

fileName=$HOME/Documents/phoneBookDB.txt

#Checking if database exists or not, if not then create new one
if  test -f $fileName
then
	:
else
	touch $fileName
fi



#Checking for options
if test -z $1
then 
	#Running script without options
	echo '- Insert new contact name and number, with the option "-i"
- View all saved contacts details, with the option "-v"
- Search by contact name, with the option "-s"
- Delete all records, with "-e"
- Delete only one contact name, with "-d"'

else
	option=$1
	case $option in
	#insert option
	-i)
		multipleNumbers=1

		#Getting new contact data from user
		read -p 'Enter Contact Name: ' contactName
		#Writing new data to file text
		echo Name: $contactName >> $fileName
		
		while [ $multipleNumbers -eq 1 ] 
		do
			read -p 'Enter Contact Number: ' contactNumber
			echo Number: $contactNumber >> $fileName
			read -p 'Do you want to add another number (y/n)? ' decision
			if [ $decision = y ]
			then :
			else multipleNumbers=0
			fi
		done
		echo Adding New Contact is Done...;;
	#view all saved contacs
	-v)
		cat $fileName;;
	
	#search by contact name
	-s)
		read -p 'Search By Contact Name: ' searchName
		linesOfName=`grep -in "$searchName" $fileName | cut -f1 -d:`
		if test -z "$linesOfName"
		then
			echo No results found
		else
			for lineOfName in $linesOfName
				do
				lineOfNumber=$((lineOfName+1))
				cat -n $fileName | grep "^ *$lineOfName" | cut -f2
				cat -n $fileName | grep "^ *$lineOfNumber" | cut -f2
			done
		fi;;
	
	#delete all records	
	-e)
		echo Deletion Completed...
		> $fileName;;

	#delete one contact 
	-d)
		read -p 'Delete Contact Name: ' deletedName
		lineOfContact=`grep -in $deletedName $fileName | cut -f1 -d:`
		if test -z $lineOfContact
		then
			echo No results found
		else
			sed -i $lineOfContact,$((lineOfContact+1))'d' $fileName
			echo Deletion Completed...
		fi;;
	*)
		echo invalid option;;
	esac

fi 




##Creating phonebook dictionary
#declare -A phonebook
 
##Adding new data to dictionary, The keys are contcant names and values are contcat numbers
#phonebook[$contactName]=$contactNumber;;


#read -p 'Enter Contact Name to search: ' searchContact

#echo $searchContact
#echo ${phonebook[$searchContact]}
#echo ${!phonebook[*]}
#echo ${phonebook[@]}


