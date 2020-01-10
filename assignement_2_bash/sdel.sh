#!/bin/bash

scriptName=`echo $0 | cut -f2 -d/`
addedToCron=`crontab -l | grep $scriptName` 
if test -z "$addedToCron"
then
	executedScript=`pwd`/$scriptName
	crontab -l 2>/dev/null
	echo "* * * * * $executedScript" | crontab -
fi

trashDirectory=~/TRASH

#Creating Trash Directory if it doesn't exist, else do nothing
if test -d $trashDirectory
then 
	:
else
	mkdir $trashDirectory
fi

#getting files existed in Trash dir
trashFiles=`ls $trashDirectory`

limitedTime=1

#saving current working dir
workingDir=`pwd`
#changing dir to trash dir
cd $trashDirectory

#getting state about each file in trash dir
for file in $trashFiles
do
	#getting deletion time
	deletionDate=`stat --format=%z $file | cut -f1 -d.`
	#calculating seconds from deletion time since 1970
	startSecs=`date +%s --date "$deletionDate"`
	#calculating seconds from current time since 1970
	endSecs=`date +%s` 

	#calculating hours between current time and deletion time
	elapsedSecs=$((endSecs-startSecs))
	elapsedHours=$((elapsedSecs/3600))

	#checking if elapsed hours is greater that or equal to limited time		
	if [ $elapsedHours -ge $limitedTime ]
	then
		rm $file
	else
		:
	fi

done
#changing dir back to current dir
cd "$workingDir"


numberOfPassedFile=$#

#Checking if the file name/path is passed to script or not
if [ $numberOfPassedFile -eq 0 ] 
then	
	#if there is no file passed to script
	echo "missing file operand" 
	echo "Trash directory is checked for files that are older than $limitedTime hours"
else

deletedFiles=$*

for file in $deletedFiles
do
	#Extracting file name from path if it's a path 
	fileName=$(basename "$file")
	#checking if file exists or not
	if test -e $file 
	then
		#file exists
		#grepping the state of compressing file
		compressed=`file -e compress $file | grep compressed`
		if test -z "$compressed"
		then
			#file is not compressed
			#compressing file
			#redirecting 'Removing leading `/' from member names' to dev/null
			tar czf $file.tar.gz $file 2>>/dev/null
			#deleting files and directories after zipping it
			rm -r $file
			if [ $? -eq 0 ]
			then
				echo $fileName deleted safely
				fileName=$fileName.tar.gz
				file=$file.tar.gz
				mv $file $trashDirectory				
			else
				echo "Problem in deleting File"
			fi
		else
			#file is already compressed, move it to TRASH directory
			mv $file $trashDirectory
			echo $fileName deleted safely
		fi
		
	else
		#file not exists
		echo "$fileName: No such file or directory"
	fi
	
done

fi


