# Embedded Linux Z2HV2
## Assignment 1 - Bash ##
## Simple Phone Book Script ##

### Summary: ###
The goal of this Assignment is to practice the basics of Shell Scripting Usage and Capabilities.

### Requirements: ###
Create a shell script that creates a phonebook on your system that contains a list of your contact names and
numbers, with these features:
- Script can take options, e.g. "phonebook -v"
- When running the script without options, it will print the phonebook available options.
- Normally there is a “.phonebookDB.txt” which ur script creates to store the names and numbers.

**Bonus1:** ​ make the database inside the script itself (meaning the script would edit itself while running), that
would make your script highly portable.

**Bonus2:** ​ a single name can have multiple phone numbers within the same database entry.

The available options are:
- Insert new contact name and number, with the option "-i"
- View all saved contacts details, with the option "-v"
- Search by contact name, with the option "-s"
- Delete all records, with "-e"
- Delete only one contact name, with "-d"
