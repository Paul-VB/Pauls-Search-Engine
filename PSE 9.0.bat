rem: date: Wednesday, Febuary 17, 2021
rem: author: Paul Vanden Broeck
@ECHO off
SET ver=9.0
TITLE PSE %ver% search engine

rem: get the working directory ready
SET "ResultsDirectory=.\PSE-Results"
MKDIR %ResultsDirectory%
SET ResultsFile="%ResultsDirectory%\Results.txt"
SET "RawResultsFile=%ResultsDirectory%\RawResults.txt"
SET "CompResultsDirectory=%ResultsDirectory%\CompResults"
MKDIR %CompResultsDirectory%
SET "UserResultsDirectory=%ResultsDirectory%\UserResults"
MKDIR %UserResultsDirectory%

rem: declare some constants
set "vRAM1=%ResultsDirectory%\vRAM1.txt"
set "vRAM2=%ResultsDirectory%\vRAM2.txt"

type nul > "%UserResultsDirectory%\USERResults.txt"
DEL "%RawResultsDirectory%\*.txt"
DEL "%CompResultsDirectory%\*.txt"
DEL "%UserResultsDirectory%\*.txt"
type nul > %ResultsFile%
type nul > %vRAM1%
type nul > %vRAM2%
echo %vRAM2%
CLS
SET ROOT=%CD%
SET /A CL=0
SET /A N=1
SET /A RealN=1
SET /A BN=0
SET /A CP=0
SET /A CL=0
SET /A CLN=0
ECHO Welcome to PSE %ver%
ECHO Please specify search parameters. (what do you wanna look for?)
SET PAR=
SET /P PAR=

ECHO:
ECHO Do you want to perform a Full search or a Quick search?
ECHO Note that a Quick search may be faster, but will also  
ECHO contain less search results.
ECHO Press the "Q" key for a Quick Search, or
ECHO Press the "F" key for a Full Search.
CHOICE /C:qf /N
SET ANS=%ERRORLEVEL%
IF %ANS%==1 GOTO QuickSearch
IF %ANS%==2 GOTO FullSearch


:QuickSearch
TITLE PSE %ver% -Quck search mode
CLS
ECHO Searching for "%PAR%". Please wait...
DIR /S /B /D /O:-S /-C "C:\Users\*%PAR%*.*" > %RawResultsFile%
ECHO Search complete.
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO |FINDSTR /B /C:"C:\Users\All Users\Microsoft\Windows\Start Menu\Programs" %RawResultsFile% >> %vRAM1%
ECHO |FINDSTR /V /B /C:"C:\Users\All Users" %RawResultsFile% >> %vRAM1%
ECHO |FINDSTR /V /C:"AppData" %vRAM1% > %vRAM2%
GOTO PreFormatResults

:FullSearch
CLS
TITLE PSE %ver% -Full search mode
ECHO Searching for "%PAR%". This may take a long time. Please wait...
for %%d in (c d e f g h i j k l m n o p q r s t u v w x y z) do (
  if exist %%d: DIR /S /B /D /O:-S /-C "%%d:\*%PAR%*.*" >> %RawResultsFile%
  )
COPY %RawResultsFile% %vRAM2%
GOTO PreFormatResults


:PreFormatResults
ECHO End-Of-List>> %vRAM2%
ECHO HA HA THIS IS A PLACE HOLDER FOR A STRING XD LOLZ FTW > %vRAM1%
FOR /F "tokens=* delims=" %%a IN (%vRAM2%) do (
ECHO ?%%a>> %vRAM1%)
ENDLOCAL
ECHO |FINDSTR /B /C:"?" %vRAM1% > %vRAM2%
ECHO |FINDSTR /B /N /C:"?" %vRAM2% > %ResultsFile%
ECHO |FINDSTR /X /N /C:"?End-Of-List" %vRAM2% > %vRAM1%
FOR /F "tokens=1 delims=:" %%t IN (%vRAM1%) do (
SET TotalRSLTS=%%t)

:NewPage
SET /A CP=%CP% + 1
SET UR=
SET CR=

:FormatPages
CLS
ECHO Gathering Results. Please Wait...
SET /A PROGS=(%CLN% * 100) / %TotalRSLTS%
ECHO Gathering %PROGS%%% complete.
ECHO Current file: %CurCompLin%

SET /A PgIsFullN=30 * %CP%
IF %CLN%==%PgIsFullN% GOTO NewPage
SET /A CLN=%CLN% + 1
ECHO |FINDSTR /B /C:"%CLN%:?" %ResultsFile% > %vRAM1%
FOR /F "tokens=2 delims=?" %%a IN (%vRAM1%) do (
SET CurUserLin=%%~nxa && SET CurCompLin=%%a)
SET UR=%UR% %CLN% %CurUserLin%?
SET CR=%CR% %CurComplin%?
ECHO %CR% > %CompResultsDirectory%\%CP%.txt
ECHO %UR% > %UserResultsDirectory%\%CP%.txt
SET TotalPGS=%CP%
IF "%CurCompLin%"=="End-Of-List" GOTO FormatingComplete
GOTO FormatPages

:FormatingComplete
SET /A CP=1
ECHO FORMATTING COMPLETE
TITLE PSE %ver% search engine

:SELECT
SETLOCAL ENABLEDELAYEDEXPANSION
SET Blist=~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
SET /A BN=-6 + %N%
SET /A AN=5 + %N%
SET /A AN2=%N%
SET Alist=

:BEFORE
SET /A BN=%BN% + 1
IF [%BN%]==[%N%] GOTO HIGHLIGHT
FOR /F "tokens=%BN% delims=?" %%b IN (%UserResultsDirectory%\%CP%.txt) Do (
SET Blist=!Blist! ^&^& ECHO. ^&^& ECHO. %%b)
GOTO BEFORE

:HIGHLIGHT
FOR /F "tokens=%N% delims=?" %%h IN (%UserResultsDirectory%\%CP%.txt) Do (
SET Hlist=################################################# ^&^& ECHO %%h)
SET Alist=#################################################

:AFTER
IF %AN2%==%AN% GOTO DISPLAY
SET /A AN2=%AN2% + 1
FOR /F "tokens=%AN2% delims=?" %%i IN (%UserResultsDirectory%\%CP%.txt) Do (
SET Alist=!Alist! ^&^& ECHO. %%i ^&^& ECHO.)
GOTO AFTER

:DISPLAY
CLS
CHDIR %ROOT%
ECHO ~~~~~~~~~~~~~~~~~SEARCH RESULTS~~~~~~~~~~~~~~~~~
ECHO %BList%
ECHO %Hlist%
ECHO %Alist%
ECHO =================================================
ECHO =================================================
ECHO CURRENT SELECTION: #%RealN% of %TotalRSLTS%, Page #%CP% of %TotalPGS%
ENDLOCAL
FOR /F "tokens=%N% delims=?" %%s IN (%CompResultsDirectory%\%CP%.txt) do (
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
REM CHOICE /C:IQm /N
SET ANS=%ERRORLEVEL%
IF %ANS%==1 GOTO LastSel
IF %ANS%==2 GOTO NextSel
IF %ANS%==3 GOTO OPEN

:LastSel
ENDLOCAL
IF /I %RealN% EQU 1 GOTO SELECT
SET /A NxtPG= 30 * %CP% + 1
SET /A LstPG= 30 * %CP% + -30
SET /A N=%N% + -1
SET /A RealN=%RealN% + -1
IF /I %RealN% EQU %LstPG% GOTO LastPage
GOTO SELECT
:LastPage
SET /A CP=%CP% + -1
SET /A N=30
GOTO SELECT

:NextSel
ENDLOCAL
IF %RealN%==%TotalRSLTS% GOTO SELECT
SET /A NxtPG= 30 * %CP% + 1
SET /A LstPG= 30 * %CP% + -30
SET /A RealN=%RealN% + 1
SET /A N=%N% + 1
IF /I %RealN% EQU %NxtPG% GOTO Nextpage
GOTO SELECT
:NextPage
SET /A CP=%CP% + 1
SET /A N=1
GOTO SELECT


:OPEN
CLS
REM Here the Program decides wheather the selection you made is a Folder or a File. 
ENDLOCAL
SET SEL=%SEL:~1,-1%
SET SEL=%SEL:(=^^^^(%
SET SEL=%SEL: =^^ %

CHDIR %ROOT%
CHDIR %SEL%

IF NOT "%CD%"=="%ROOT%" GOTO OpenFolder
IF "%CD%"=="%ROOT%" GOTO OpenFile

:OpenFile
SET TYPE=File
%SEL%
GOTO END
 
:OpenFolder
SET TYPE=Folder
START .
GOTO END

:END
CLS
ECHO ~~~~~~~~~~~~~~~~~~~DEBUG INFO~~~~~~~~~~~~~~~~~~~
ECHO Search Parameters = %PAR%
ECHO Current Directory = %CD%
ECHO Program Root = %ROOT%
ECHO Current Selection = %SEL%
ECHO Selection Type = %TYPE%
ECHO Selection Number = %RealN%
ECHO Selection Delimiter = %N%
ECHO Current Page = %CP%
ECHO Total Results = %TotalRSLTS%
ECHO ~~~~~~~~~~~~~~~~~~~DEBUG INFO~~~~~~~~~~~~~~~~~~~
PAUSE
GOTO SELECT