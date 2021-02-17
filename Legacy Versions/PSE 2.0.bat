@ECHO OFF
TITLE PSE 2.0 search engine
ECHO Welcome to PSE 2.0.
ECHO Please slelect either basic or advanced mode.
:START
SET MODE=
ECHO Type "B" for basic mode, type "A" for advanced 
SET /P MODE=
IF "%MODE%"=="A" GOTO ADVANCED
IF "%MODE%"=="B" GOTO BASIC
IF "%MODE%"=="a" GOTO ADVANCED
IF "%MODE%"=="b" GOTO BASIC
GOTO START
:BASIC
TITLE PSE 2.0 search engine (Basic mode)
ECHO Please specify search parameters.
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
DIR /S /B /O:G "C:\Users\*%PAR%*.*"
ECHO =================================================
ECHO Please specify the desired file to be opened.
SET FILE=
SET /P FILE=
Explorer %FILE%
PAUSE
GOTO END
:ADVANCED
TITLE PSE 2.0 search engine (Advanced mode)
ECHO Please specify search parameters.
SET PAR=
SET /P PAR=
ECHO =================================================
ECHO Searching for "%PAR%". Please wait...
DIR /S /O:G "C:\*%PAR%*.*"
ECHO =================================================
ECHO Please specify the desired file to be opened.
SET FILE=
SET /P FILE=
Explorer %FILE%
GOTO END
:END
