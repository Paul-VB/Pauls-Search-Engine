@ECHO OFF
TITLE PSE 6.0 search engine
COPY "C:\PSE\Blank.txt" "C:\PSE\USERResults.txt"
DEL "C:\PSE\COMPResults*.txt"
DEL "C:\PSE\USERResults*.txt"
COPY "C:\PSE\Blank.txt" "C:\PSE\Results.txt"
COPY "C:\PSE\Blank.txt" "C:\PSE\vRAM1.txt"
COPY "C:\PSE\Blank.txt" "C:\PSE\vRAM2.txt"
CLS
SET /A CL=0
SET /A N=1
SET /A RealN=1
SET /A BN=0
SET /A CP=0
SET /A CL=0
SET /A CLN=0
ECHO Welcome to PSE 6.0
ECHO Please specify search parameters.
SET PAR=
SET /P PAR=
CLS


ECHO Searching for "%PAR%". Please wait...
DIR /S /B /D /O:-S /-C "C:\Users\*%PAR%*.*" > "C:\PSE\RAWResults.txt"
ECHO Search complete.

SETLOCAL ENABLEDELAYEDEXPANSION
ECHO |FINDSTR /B /C:"C:\Users\All Users\Microsoft\Windows\Start Menu\Programs" "C:\PSE\RAWResults.txt" >> "C:\PSE\vRAM1.txt"
ECHO |FINDSTR /V /B /C:"C:\Users\All Users" "C:\PSE\RAWResults.txt" >> "C:\PSE\vRAM1.txt"
ECHO |FINDSTR /V /C:"AppData" "C:\PSE\vRAM1.txt" > "C:\PSE\vRAM2.txt"
ECHO End-Of-List>> "C:\PSE\vRAM2.txt"
ECHO HA HA THIS IS A PLACE HOLDER FOR A STRING XD LOLZ FTW > "C:\PSE\vRAM1.txt"
FOR /F "tokens=* delims=" %%a IN (C:\PSE\vRAM2.txt) do (
ECHO ?%%a>> C:\PSE\vRAM1.txt)
ENDLOCAL
ECHO |FINDSTR /B /C:"?" "C:\PSE\vRAM1.txt" > "C:\PSE\vRAM2.txt"
ECHO |FINDSTR /B /N /C:"?" "C:\PSE\vRAM2.txt" > "C:\PSE\Results.txt"
ECHO |FINDSTR /X /N /C:"?End-Of-List" "C:\PSE\vRAM2.txt" > "C:\PSE\vRAM1.txt"
FOR /F "tokens=1 delims=:" %%t IN (C:\PSE\vRAM1.txt) do (
SET TotalRSLTS=%%t)

:NewPage
SET /A CP=%CP% + 1
SET UR=
SET CR=

:FormatPages
CLS
ECHO Formatting Results. Please Wait...
SET /A PROGS=(%CLN% * 100) / %TotalRSLTS%
ECHO Formatting %PROGS%%% complete.
ECHO Current file: %CurCompLin%

SET /A PgIsFullN=30 * %CP%
IF %CLN%==%PgIsFullN% GOTO NewPage
SET /A CLN=%CLN% + 1
ECHO |FINDSTR /B /C:"%CLN%:?" "C:\PSE\Results.txt" > "C:\PSE\vRAM1.txt"
FOR /F "tokens=2 delims=?" %%a IN (C:\PSE\vRAM1.txt) do (
SET CurUserLin=%%~nxa && SET CurCompLin=%%a)
SET UR=%UR% %CLN% %CurUserLin%?
SET CR=%CR% %CurComplin%?
ECHO %CR% > "C:\PSE\COMPResults%CP%.txt
ECHO %UR% > "C:\PSE\USERResults%CP%.txt
SET TotalPGS=%CP%
IF "%CurCompLin%"=="End-Of-List" GOTO FormatingComplete
GOTO FormatPages

:FormatingComplete
SET /A CP=1

:Select
SETLOCAL ENABLEDELAYEDEXPANSION
SET Blist=~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SET /A BN=-6 + %N%
SET /A AN=5 + %N%
SET /A AN2=%N%
SET Alist=

:BEFORE
SET /A BN=%BN% + 1
IF [%BN%]==[%N%] GOTO HIGHLIGHT
FOR /F "tokens=%BN% delims=?" %%b IN (C:\PSE\USERResults%CP%.txt) Do (
SET Blist=!Blist! ^&^& ECHO. ^&^& ECHO. %%b)
GOTO BEFORE

:HIGHLIGHT
FOR /F "tokens=%N% delims=?" %%h IN (C:\PSE\USERResults%CP%.txt) Do (
SET Hlist=################################################# ^&^& ECHO %%h)
SET Alist=#################################################

:AFTER
IF %AN2%==%AN% GOTO DISPLAY
SET /A AN2=%AN2% + 1
FOR /F "tokens=%AN2% delims=?" %%i IN (C:\PSE\USERResults%CP%.txt) Do (
SET Alist=!Alist! ^&^& ECHO. %%i ^&^& ECHO.)
GOTO AFTER


:DISPLAY
CLS
ECHO ~~~~~~~~~~~~~~~~~SEARCH RESULTS~~~~~~~~~~~~~~~~~
ECHO %BList%
ECHO %Hlist%
ECHO %Alist%
ECHO =================================================
ECHO =================================================
ECHO CURRENT SELECTION: #%RealN% of %TotalRSLTS%, Page #%CP% of %TotalPGS%
ENDLOCAL
FOR /F "tokens=%N% delims=?" %%s IN (C:\PSE\COMPResults%CP%.txt) do (
SET SEL=%%s && ECHO %%s)
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO =================================================
ECHO =================================================
ECHO Do you wish to open the current selection? Press
ECHO M if you do. If not, use the "A" and "Z" keys to 
ECHO scroll up and down though the search results. 
ECHO To see a list of all search results, scroll up 
ECHO to the top of this window.
CHOICE /C:azm /N
SET ANS=%ERRORLEVEL%
IF %ANS%==1 GOTO LastSel
IF %ANS%==2 GOTO NextSel
IF %ANS%==3 GOTO END

:LastSel
ENDLOCAL
IF /I %RealN% EQU 1 GOTO Select
SET /A NxtPG= 30 * %CP% + 1
SET /A LstPG= 30 * %CP% + -30
SET /A N=%N% + -1
SET /A RealN=%RealN% + -1
IF /I %RealN% EQU %LstPG% GOTO LastPage
GOTO Select
:LastPage
SET /A CP=%CP% + -1
SET /A N=30
GOTO Select

:NextSel
ENDLOCAL
IF %RealN%==%TotalRSLTS% GOTO Select
SET /A NxtPG= 30 * %CP% + 1
SET /A LstPG= 30 * %CP% + -30
SET /A RealN=%RealN% + 1
SET /A N=%N% + 1
IF /I %RealN% EQU %NxtPG% GOTO Nextpage
GOTO Select
:NextPage
SET /A CP=%CP% + 1
SET /A N=1
GOTO Select


:END
SET SEL=%SEL:~1,-1%
SET SEL=%SEL: =^^ %
%SEL%
CD %SEL%
START .
PAUSE
GOTO DISPLAY
