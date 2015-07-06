@echo off

if "%~1"=="" ( 
 call :Usage
 goto :EOF
)

pushd "%~dp0"
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

set ProgramFilesDir=%ProgramFiles%
if NOT "%ProgramFiles(x86)%"=="" set ProgramFilesDir=%ProgramFiles(x86)%

set VisualStudioCmd=%VS90COMNTOOLS%\vsvars32.bat
if EXIST "%VisualStudioCmd%" call "%VisualStudioCmd%"

if NOT EXIST "%SvnDir%" set SvnDir=%ProgramFiles%\svn
if NOT EXIST "%SvnDir%" set SvnDir=%ProgramFiles%\CollabNet\Subversion Client
if NOT EXIST "%SvnDir%" set SvnDir=%ProgramFiles%\Subversion
if NOT EXIST "%SvnDir%" set SvnDir=%ProgramFiles%\SlikSvn
if NOT EXIST "%SvnDir%" (
 echo Missing SubVersion, expected in %ProgramFiles%\svn or %ProgramFiles%\Subversion or %ProgramFiles%\SlikSvn
 exit /b -1
)

set FrameworkVersion=v3.5
set FrameworkDir=%SystemRoot%\Microsoft.NET\Framework

PATH=%SvnDir%;%PATH%

msbuild.exe ProcessDomain.proj /l:FileLogger,Microsoft.Build.Engine;logfile=MSBuild.log /t:%*
if NOT %ERRORLEVEL%==0 exit /b %ERRORLEVEL%
popd
endlocal
exit /b 0
goto :EOF

:Usage
echo  Syntax:
echo.
echo   build [target] /p:Configuration=[Debug (default),Release]
echo.
echo  Target:
echo.
echo   all : build everything
echo.
echo  Examples:
echo.
echo   build all
echo   build all /p:Configuration=Release
goto :EOF
