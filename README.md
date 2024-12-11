# QA Automation Challenge

## Ruby Setup

1) Download ruby from https://rubyinstaller.org/
2) Follow the instructions
3) Open the start menu and search for "Environment variables"
4) Do a control + r, enter sysdm.cpl, and hit enter.
5) Go to "Advanced options" tab
6) Click "Environment variables" button
7) Click "New" and add the path to Ruby's bin directory (e.g., C:\Ruby32-x64\bin).
8) Click OK to save changes.
9) Go to the command prompt and verify ruby has been installed by entering ***ruby --version***

## SQLite Setup

1) Go to your terminal and write ***gem install sqlite3***

## Running the scripts

For running the monitoring script:
1) Go to the terminal and enter ***ruby monitoringScript.rb***

For running the uptime script:
1) Go to the terminal and enter ***ruby uptime.rb***
   
## Monitoring

This Ruby script monitors an API for 10 minutes by making PUT requests with a name parameter read from a text file.
The script logs the results of each request (including the status and body of the API response) into an SQLite database for later analysis.

## Uptime

This script reads the previously persisted information about the previous requests and calculates the time that the API has been up.

Uptime (%)=( Total Requests/Successful Requests (200))×100

## Uptime output

The uptime output is: 

Total Requests: 421
Successful Requests (200): 370
Service Uptime: 87.89%

## Bug: Names with more than one lowercase 'p'
Description: When entering words that contains more than one lowercase **p**, the API returns ***500 internal server error.***

    Steps to reproduce it:
    1) Enter a name with more than one lowercase 'p'. Example given: hiphop, pepper, Happy.
    2) Submit the name and check that the API returns 500 internal server error

***Expected outcome:*** The API should respond with ***200***
    



