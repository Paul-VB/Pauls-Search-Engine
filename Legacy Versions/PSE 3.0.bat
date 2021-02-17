@ECHO OFF
TITLE PSE 3.0 search engine
COPY "C:\PSE\Blank.txt" "C:\PSE\USERResults.txt"
COPY "C:\PSE\Blank.txt" "C:\PSE\COMPResults.txt"
CLS
ECHO Welcome to PSE 3.0
ECHO Please specify search parameters.
SET N=0
SET PAR=
SET /P PAR=
CLS
ECHO Searching for "%PAR%". Please wait...
DIR /S /B /D /O:G /-C "C:\Users\*%PAR%*.*" > "C:\PSE\USERResults.txt"
ECHO Search complete.
ECHO Formatting Results. Please Wait...
SETLOCAL ENABLEDELAYEDEXPANSION
FOR /F "tokens=* delims=" %%l IN (C:\PSE\USERResults.txt) do (
SET CurLin=%%l && SET CR=!CR!!CurLin!?)
ECHO %CR% > "C:\PSE\COMPRESULTS.txt"
:SELECT
CLS
ECHO ~~~~~~~~~~SEARCH RESULTS~~~~~~~~~~
ECHO #################################################
ECHO #################################################
ECHO #################################################
ECHO ################################################# 
TYPE C:\PSE\USERResults.txt
ECHO #################################################
ECHO #################################################
ECHO #################################################
ECHO #################################################
ECHO #################################################
ECHO #################################################
ECHO #################################################
ECHO #################################################
ECHO #################################################
ECHO #################################################
ECHO #################################################
ECHO #################################################
ECHO =================================================
SET /A N=%N% + 1
ECHO ~~~~~~~~~CURRENT SELECTION: CHOISE #%N%~~~~~~~~~
FOR /F "tokens=%N% delims=?" %%s IN (C:\PSE\COMPResults.txt) do (
ECHO %%s && SET Sel=%%s)
ECHO =================================================
ECHO Do you wish to open the current selection? type 
ECHO "yes" if you do. If not, press enter to continue 
ECHO browsing though the search results. To see a list
ECHO of all search results, scroll up to the top of
ECHO this window.
SET ANS=
SET /P ANS= 
IF [%ANS%]==[yes] GOTO END
IF [%ANS%]==[] GOTO SELECT
GOTO SELECT
:END
Explorer %Sel%
START %Sel%
EXIT