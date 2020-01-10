#!/bin/bash


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

limitedTime=48

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
	if test -f $fileName 
	then
		#file exists
		#grepping the state of compressing file
		compressed=`file -e compress $fileName | grep compressed`
		if test -z "$compressed"
		then
			#file is not compressed
			#compressing file
			tar czf $fileName.tar.gz $fileName
			rm $fileName 2>>/dev/null
			if [ $? -eq 0 ]
			then
				echo $fileName deleted safely
				fileName=$fileName.tar.gz
				mv $fileName $trashDirectory				
			else
				echo "Problem in deleting File"
			fi
		else
			#file is already compressed, move it to TRASH directory
			mv $fileName $trashDirectory
			echo $fileName deleted safely
		fi
		
	else
		if test -d $fileName
		then
			echo "Error in deleting file, $fileName is directory"
		else

			#file not exists
			echo "$fileName:No such file"
		fi
	fi
	
done

fi


