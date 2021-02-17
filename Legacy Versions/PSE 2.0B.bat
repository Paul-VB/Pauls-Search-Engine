@ECHO OFF
COLOR 0A
TITLE PSE 2.0B search engine
COPY "C:\PSE\Blank.txt" "C:\PSE\Results.txt"
ECHO Welcome to PSE 2.0B
ECHO Please type part of a file name you wish to search for.
SET PAR=
SET /P PAR=
ECHO =================================================
ECHO INFO: The search results will be displayed in a list format. 
ECHO To select a file from the list, right click the top bar of 
ECHO this window, click "Properties", then click "Options", and 
ECHO check the box that says "QuickEdit Mode", then click "OK"
ECHO Now higlight the file. To copy the selection, press Enter. 
ECHO When you are asked to specify the desired file, simply 
ECHO right click to paste your selection.
PAUSE
ECHO =================================================
ECHO Searching for "%PAR%". Please wait...
DIR /S /B /O:G "C:\Users\*%PAR%*.*" > "C:\PSE\Results.txt"
ECHO =================================================
TYPE /L1 "C:\PSE\Results.txt"
Pause