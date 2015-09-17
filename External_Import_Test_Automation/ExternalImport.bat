@echo off
 
Echo Starting External Imports>>ExternalImport.log
 
pushd %~dp0
set Current_Dir=%CD%
popd
 
powershell.exe -command %Current_Dir%\Set_Properties_Path.ps1 
 
Echo %date% %time% >> ExternalImport.log
 
Echo Running Currency Imports >> ExternalImport.log
%Current_Dir%\import.exe -p %USERPROFILE%\TestData\Currency\ImportProperties.txt
 
Echo Running Currency Escalation Imports >> ExternalImport.log
%Current_Dir%\import.exe -p %USERPROFILE%\TestData\CurrencyEscalation\ImportProperties.txt
 
Echo Running Opex Imports >> ExternalImport.log
%Current_Dir%\import.exe -p %USERPROFILE%\TestData\Opex\ImportProperties.txt
 
Echo Running Opex 2 Imports >> ExternalImport.log
%Current_Dir%\import.exe -p %USERPROFILE%\TestData\Opex\ImportProperties_2.txt
 
Echo Running Price Profile Imports >> ExternalImport.log
%Current_Dir%\import.exe -p %USERPROFILE%\TestData\PriceProfile\ImportProperties.txt
  
Echo Running Price Profile Imports >> ExternalImport.log
%Current_Dir%\import.exe -p %USERPROFILE%\TestData\PriceProfile\ImportProperties_2.txt 
  
  
ECHO Batch file return code: %ERRORLEVEL% >> ExternalImport.log