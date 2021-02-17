rem: date: sunday november 1st, 2015
rem: author: Paul Vanden Broeck
@ECHO OFF
SET ver=8.0
TITLE PSE %ver% search engine
COPY "C:\PSE\Blank.txt" "C:\PSE\USERResults.txt"
DEL "C:\PSE\RAWResults*.txt"
DEL "C:\PSE\COMPResults*.txt"
DEL "C:\PSE\USERResults*.txt"
COPY "C:\PSE\Blank.txt" "C:\PSE\Results.txt"
COPY "C:\PSE\Blank.txt" "C:\PSE\vRAM1.txt"
COPY "C:\PSE\Blank.txt" "C:\PSE\vRAM2.txt"
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
DIR /S /B /D /O:-S /-C "C:\Users\*%PAR%*.*" > "C:\PSE\RAWResults.txt"
ECHO Search complete.
SETLOCAL ENABLEDELAYEDEXPANSION
ECHO |FINDSTR /B /C:"C:\Users\All Users\Microsoft\Windows\Start Menu\Programs" "C:\PSE\RAWResults.txt" >> "C:\PSE\vRAM1.txt"
ECHO |FINDSTR /V /B /C:"C:\Users\All Users" "C:\PSE\RAWResults.txt" >> "C:\PSE\vRAM1.txt"
ECHO |FINDSTR /V /C:"AppData" "C:\PSE\vRAM1.txt" > "C:\PSE\vRAM2.txt"
GOTO PreFormatResults

:FullSearch
CLS
TITLE PSE %ver% -Full search mode
ECHO Searching for "%PAR%". This may take a long time. Please wait...
for %%d in (c d e f g h i j k l m n o p q r s t u v w x y z) do (
  if exist %%d: DIR /S /B /D /O:-S /-C "%%d:\*%PAR%*.*" >> "C:\PSE\RAWResults.txt"
  )
COPY "C:\PSE\RAWResults.txt" "C:\PSE\vRAM2.txt"
GOTO PreFormatResults


:PreFormatResults
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
ECHO Gathering Results. Please Wait...
SET /A PROGS=(%CLN% * 100) / %TotalRSLTS%
ECHO Gathering %PROGS%%% complete.
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
CHDIR %ROOT%
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