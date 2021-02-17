@ECHO OFF
TITLE PSE 5.0 search engine
COPY "C:\PSE\Blank.txt" "C:\PSE\USERResults.txt"
COPY "C:\PSE\Blank.txt" "C:\PSE\COMPResults.txt"
COPY "C:\PSE\Blank.txt" "C:\PSE\RAWResults.txt"
COPY "C:\PSE\Blank.txt" "C:\PSE\Results.txt"
COPY "C:\PSE\Blank.txt" "C:\PSE\Pre1Results.txt"
CLS
SET /A ALN=0
SET /A SLN=0
SET /A N=1
SET /A BN=0

ECHO Welcome to PSE 5.0
ECHO Please specify search parameters.
SET PAR=
SET /P PAR=
CLS


ECHO Searching for "%PAR%". Please wait...
DIR /S /B /D /O:-S /-C "C:\Users\*%PAR%*.*" > "C:\PSE\RAWResults.txt"
ECHO Search complete.
ECHO Formatting Results. Please Wait...

SETLOCAL ENABLEDELAYEDEXPANSION
ECHO |FINDSTR /B /C:"C:\Users\All Users\Microsoft\Windows\Start Menu\Programs" "C:\PSE\RAWResults.txt" >> "C:\PSE\Pre1Results.txt"
ECHO |FINDSTR /V /B /C:"C:\Users\All Users" "C:\PSE\RAWResults.txt" >> "C:\PSE\Pre1Results.txt"
ECHO |FINDSTR /V /C:"AppData" "C:\PSE\Pre1Results.txt" >> "C:\PSE\Results.txt"

FOR /F "tokens=* delims=" %%c IN (C:\PSE\Results.txt) do (
SET /A LLN=!LLN! + 1 && SET CurLinC=%%c && SET CR=!CR!!CurLinC!?)
ECHO %CR% > "C:\PSE\COMPResults.txt"

FOR /F "tokens=* delims=" %%u IN (C:\PSE\Results.txt) do (
SET /A SLN=!SLN! + 1 && SET CurLinU=%%~nxu && SET UR=!UR!? !SLN! !CurLinU!)
ECHO %UR%?/// > "C:\PSE\USERResults.txt"

FOR /F "tokens=* delims=" %%a IN (C:\PSE\Results.txt) do (
SET /A ALN=!ALN! + 1 && SET CurLinA=%%~nxa && SET AL=!AL!? !ALN! !CurLinA! ^&^& ECHO. ^&^& ECHO )


:SELECT
SETLOCAL ENABLEDELAYEDEXPANSION
SET Blist=~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^&^& ECHO 
SET /A BN=-6 + %N%
SET /A AN=5 + %N%
SET /A AN2=%N%
SET Alist=
:BEFORE
SET /A BN=%BN% + 1
IF [%BN%]==[%N%] GOTO HIGHLIGHT
FOR /F "tokens=%BN% delims=?" %%b IN (C:\PSE\USERResults.txt) Do (
SET Blist=!Blist! ^&^& ECHO. %%b ^&^& ECHO.)
GOTO BEFORE
:HIGHLIGHT
FOR /F "tokens=%N% delims=?" %%h IN (C:\PSE\USERResults.txt) Do (
SET Hlist=################################################# ^&^& ECHO %%h ^&^& ECHO ################################################# ^&^& ECHO.) 
:AFTER
IF %AN2%==%AN% GOTO DISPLAY
SET /A AN2=%AN2% + 1
FOR /F "tokens=%AN2% delims=?" %%i IN ("!AL!") Do (
SET Alist=!Alist! %%i)
GOTO AFTER


:DISPLAY
CLS
ECHO ~~~~~~~~~~~~~~~~~SEARCH RESULTS~~~~~~~~~~~~~~~~~
ECHO %BList%
ECHO %Hlist%
ECHO %Alist:?=%
ECHO =================================================
ECHO ~~~~~~~~~CURRENT SELECTION: CHOISE #%N%~~~~~~~~~
ENDLOCAL
FOR /F "tokens=%N% delims=?" %%s IN (C:\PSE\COMPResults.txt) do (
SET SEL=%%s && ECHO %%s)
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO =================================================
ECHO Do you wish to open the current selection? Press
ECHO M if you do. If not, use the "A" and "Z" keys to 
ECHO scroll up and down though the search results. 
ECHO To see a list of all search results, scroll up 
ECHO to the top of this window.
CHOICE /C:azm /N
ENDLOCAL
SET ANS=%ERRORLEVEL%
IF %ANS%==1 SET /A N=-1 + %N%
IF %ANS%==2 SET /A N=%N% + 1
IF %ANS%==3 GOTO END
GOTO SELECT
:END
Explorer %SEL%
START %SEL%
GOTO DISPLAY