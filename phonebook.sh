#!/bin/bash

fileName=$HOME/Documents/phoneBookDB.txt

#Checking if database exists or not, if not then create new one
if  test -f $fileName
then
	:
else
	touch $fileName
fi

#Enabling Script access to database
chmod +rw $fileName


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
		#multiple numbers flag
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
		#Getting lines of all occurances of search name
		linesOfName=`grep -in "$searchName" $fileName | cut -f1 -d:`
		#checking if the search name has matches in file or not
		if test -z "$linesOfName"
		then
			echo No results found
		else
			#looping through all matches
			for lineOfName in $linesOfName
				do
				#printing the name and the first number of search name
				lineOfNumber=$((lineOfName+1))
				sed -n -e $lineOfName'p' -e $lineOfNumber'p' $fileName
				
				#checking if the contact has more than one number and printing them all
				lineOfNumber=$((lineOfNumber+1))
				label=`sed -n $lineOfNumber'p' $fileName | cut -f1 -d:`
				while [ "$label" == Number ]
				do
					sed -n $lineOfNumber'p' $fileName
					lineOfNumber=$((lineOfNumber+1))
					label=`sed -n $lineOfNumber'p' $fileName | cut -f1 -d:`
				done
				
			done
		fi;;
	
	#delete all records	
	-e)
		echo Deletion Completed...
		> $fileName;;

	#delete one contact 
	-d)
		read -p 'Delete Contact Name: ' deletedName
		#getting numbers of lines that have the deleted name
		linesOfContact=`grep -in "$deletedName" $fileName | cut -f1 -d:`
		#getting number of matches with deleted name
		numberOfOccurances=`grep -in "$deletedName" $fileName | cut -f1 -d:|wc -w`
		if test -z "$linesOfContact"
		then
			echo No results found
		else
			if [ $numberOfOccurances -ne 1 ] 
			#if there in not only one exact match, then prompt a message
			then
				echo There are many contacts with the same name: $deletedName
				#printing all matches
				for lineOfContact in $linesOfContact
					do
					sed -n $lineOfContact'p' $fileName
				done
				read -p 'Do you want to delete them all (y/n)? ' deleteDecision
				if [ $deleteDecision = y ]
				then
					#deleting all matches with deleted name
					occurance=0
					while [ $occurance -lt $numberOfOccurances ]
						do
						#getting line by line
						lineOfContact=${linesOfContact:0:1}
						sed -i $lineOfContact,$((lineOfContact+1))'d' $fileName
						#updating list of lines that contain the deleted name
						linesOfContact=`grep -in "$deletedName" $fileName | cut -f1 -d:`
						occurance=$((occurance+1))
						
					done
					echo Deletion Completed...	
				else
					#program needs more details to delete a contact
					echo Please Enter the Full Name
				fi

			else
			#if there is only one exact match then delete it 
				sed -i $linesOfContact,$((linesOfContact+1))'d' $fileName

				#checking if the contact has more than one number and deleting them all
				lineOfNumber=$((linesOfContact))
				label=`sed -n $lineOfNumber'p' $fileName | cut -f1 -d:`
				while [ "$label" == Number ]
				do
					sed -i $lineOfNumber'd' $fileName
					label=`sed -n $lineOfNumber'p' $fileName | cut -f1 -d:`
				done

				echo Deletion Completed...
			fi
		fi;;
	*)
		echo invalid option;;
	esac

fi 

#Disabling Script and others' access to database
chmod -rw $fileName


##Creating phonebook dictionary
#declare -A phonebook
 
##Adding new data to dictionary, The keys are contcant names and values are contcat numbers
#phonebook[$contactName]=$contactNumber;;


#read -p 'Enter Contact Name to search: ' searchContact

#echo $searchContact
#echo ${phonebook[$searchContact]}
#echo ${!phonebook[*]}
#echo ${phonebook[@]}


