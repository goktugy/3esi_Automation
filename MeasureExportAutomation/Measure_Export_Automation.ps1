<#
This function is used to do comparisons using Beyond Compare
$CMD='C:\Program Files (x86)\Beyond Compare 3\bcompare.exe'  
$Arg1='@\HTML_Output_Compare_Two_Files_Script.txt' 
$Arg2='\316production.csv' 
$Arg3='\317Production.csv'
$arg4='\Results.html

& $CMD $Arg1 $Arg2 $Arg3 $Arg4 

#>
Function BeyondCompare{
param(
  [string]$Beyond_Compare_Parameters,  
  [string]$File_1,
  [string]$File_2,  
  [string]$ResultFile 
   )

#We read from the ini file the location of the Beyond Compare Executable  
$invocation = (Get-Variable MyInvocation).Value
$directorypath = Split-Path $invocation.ScriptName
$automationInifile=$directorypath+"\Automation.ini" 

$inifile=Get-Content $automationInifile

$parsed_lines=$inifile[2].split("=")
$Beyond_Compare_Executable=$parsed_lines[1]

& $Beyond_Compare_Executable $Beyond_Compare_Parameters $File_1 $File_2 $ResultFile

}

<#
This function is used to run measure exports.
exportMeasure.exe  -p Production_MonthlyReference.txt
#>

Function Run_MeasureExport{
  param(
  [string]$Measure_Export_Path,
  [string]$MEASURE_EXPORT_PARAMETERS_FILE)


$Measure_Export_Command= $Measure_Export_Path+" -p "+$MEASURE_EXPORT_PARAMETERS_FILE

Invoke-Expression $Measure_Export_Command

}

Function LogWrite {
   param ([string]$logstring)
   
   $invocation = (Get-Variable MyInvocation).Value
   $directorypath = Split-Path $invocation.ScriptName

   $Logfile=$directorypath+"\Test_Automation.log" 
   
   Add-content $Logfile -value $logstring
}


#Starting Main

#Run 3.15 Measure Export.
#3.15 Measure Export is used as the baseline to compare against.

$Starting_Automation= "Starting Automation "+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+"`n"

LogWrite $Starting_Automation

#We are using the code below to find the current location where the script is running
$invocation = (Get-Variable MyInvocation).Value
$directorypath = Split-Path $invocation.InvocationName
$AutomationInifile=$directorypath+"\Automation.ini"


#We are using the code below to read from the Automation.ini file
$inifile=Get-Content $AutomationInifile

$parsed_lines=$inifile[0].split("=")
$Measure_Export=$parsed_lines[1]

$Measure_Export_Files=@()

$Measure_Export_Files+=$directorypath+"\References\Production_MonthlyReference_1.txt"
$Measure_Export_Files+=$directorypath+"\References\Reserve_MonthlyReference_1.txt"
$Measure_Export_Files+=$directorypath+"\References\Opex_MonthlyReference_1.txt"
$Measure_Export_Files+=$directorypath+"\References\Resource_MonthlyReference_1.txt"
$Measure_Export_Files+=$directorypath+"\References\Revenue_MonthlyReference_1.txt"
$Measure_Export_Files+=$directorypath+"\References\Capex_MonthlyReference_1.txt"
$Measure_Export_Files+=$directorypath+"\References\Activity_MonthlyReference_1.txt"
$Measure_Export_Files+=$directorypath+"\References\RigRelease_MonthlyReference_1.txt"


#The loop below runs measure export for 3.15 which will be used a baseline

foreach($Measure_Export_File in $Measure_Export_Files){
        LogWrite "Running Measure Export For  $Measure_Export_File with $Measure_Export `n"
        Run_MeasureExport $Measure_Export $Measure_Export_File
}

#Run Measure Export for the newly specified build.

#We use the code below to parse the Automation.ini file
$parsed_lines=$inifile[1].split("=")
$Measure_Export_Comparison=$parsed_lines[1]

$Measure_Export_Compare_Files=@()

$Measure_Export_Compare_Files+=$directorypath+"\References\Production_MonthlyReference_2.txt"
$Measure_Export_Compare_Files+=$directorypath+"\References\Reserve_MonthlyReference_2.txt"
$Measure_Export_COmpare_Files+=$directorypath+"\References\Opex_MonthlyReference_2.txt"
$Measure_Export_COmpare_Files+=$directorypath+"\References\Resource_MonthlyReference_2.txt"
$Measure_Export_COmpare_Files+=$directorypath+"\References\Revenue_MonthlyReference_2.txt"
$Measure_Export_COmpare_Files+=$directorypath+"\References\Capex_MonthlyReference_2.txt"
$Measure_Export_COmpare_Files+=$directorypath+"\References\Activity_MonthlyReference_2.txt"
$Measure_Export_COmpare_Files+=$directorypath+"\References\RigRelease_MonthlyReference_2.txt"


#New Measure Export forecast files are created with the newly speicified build.
foreach($Measure_Export_Compare_File in $Measure_Export_Compare_Files){
    LogWrite "Running Measure Export For  $Measure_Export_Compare_File with $Measure_Export_Comparison `n"
    Run_MeasureExport $Measure_Export_Comparison $Measure_Export_Compare_File
}

#Compare Results

$Beyond_Compare_Parameters_File='@'+$directorypath+'\HTML_Output_Compare_Two_Files_Script.txt'

$base_version=$inifile[3].split("=")

$Beyond_Compare_LeftFiles=@()
$Beyond_Compare_LeftFiles+=$directorypath+'\MeasureExport\'+$base_version[1]+'production.csv' 
$Beyond_Compare_LeftFiles+=$directorypath+'\MeasureExport\'+$base_version[1]+'reserves.csv' 
$Beyond_Compare_LeftFiles+=$directorypath+'\MeasureExport\'+$base_version[1]+'opex.csv'
$Beyond_Compare_LeftFiles+=$directorypath+'\MeasureExport\'+$base_version[1]+'resource.csv'
$Beyond_Compare_LeftFiles+=$directorypath+'\MeasureExport\'+$base_version[1]+'revenue.csv'
$Beyond_Compare_LeftFiles+=$directorypath+'\MeasureExport\'+$base_version[1]+'capex.csv'
$Beyond_Compare_LeftFiles+=$directorypath+'\MeasureExport\'+$base_version[1]+'Activity.csv' 
$Beyond_Compare_LeftFiles+=$directorypath+'\MeasureExport\'+$base_version[1]+'RigRelease.csv' 

<# This is functionality that may be implemented at a later date. 
Read directly from the measure export file the location of the output file i.e ..\MeasureExport\318Production.csv

$Production_RightFile_Location= $directorypath+'\References\Production_MonthlyReference_2.txt'
$Search_Pattern=[regex]::Escape('C:\CompareTwoFiles\MeasureExport')
$Production_RightFile_Value=Select-String -path $Production_RightFile_Location -pattern $Search_Pattern
#>

#Lets get the comparison version.
$comparison_version=$inifile[4].split("=")

$Beyond_Compare_RightFiles=@()
$Beyond_Compare_RightFiles+=$directorypath+'\MeasureExport\'+$comparison_Version[1]+'production.csv' 
$Beyond_Compare_RightFiles+=$directorypath+'\MeasureExport\'+$comparison_Version[1]+'reserves.csv' 
$Beyond_Compare_RightFiles+=$directorypath+'\MeasureExport\'+$comparison_Version[1]+'opex.csv' 
$Beyond_Compare_RightFiles+=$directorypath+'\MeasureExport\'+$comparison_Version[1]+'resource.csv'
$Beyond_Compare_RightFiles+=$directorypath+'\MeasureExport\'+$comparison_Version[1]+'revenue.csv'
$Beyond_Compare_RightFiles+=$directorypath+'\MeasureExport\'+$comparison_Version[1]+'capex.csv'  
$Beyond_Compare_RightFiles+=$directorypath+'\MeasureExport\'+$comparison_Version[1]+'activity.csv' 
$Beyond_Compare_RightFiles+=$directorypath+'\MeasureExport\'+$comparison_Version[1]+'RigRelease.csv' 

$Beyond_Compare_ResultFiles=@()
$Beyond_Compare_ResultFiles+=$directorypath+'\Reports\Production_Compare_Report_'
$Beyond_Compare_ResultFiles+=$directorypath+'\Reports\Reserves_Compare_Report_'
$Beyond_Compare_ResultFiles+=$directorypath+'\Reports\OPEX_Compare_Report_'
$Beyond_Compare_ResultFiles+=$directorypath+'\Reports\Resource_Compare_Report_'
$Beyond_Compare_ResultFiles+=$directorypath+'\Reports\Revenue_Compare_Report_'
$Beyond_Compare_ResultFiles+=$directorypath+'\Reports\Capex_Compare_Report_'
$Beyond_Compare_ResultFiles+=$directorypath+'\Reports\Activity_Compare_Report_'
$Beyond_Compare_ResultFiles+=$directorypath+'\Reports\RigRelease_Compare_Report_'

$iterator=0
foreach($Beyond_Compare_LeftFile in $Beyond_Compare_LeftFiles){
        LogWrite "Comparing Results For $Beyond_Compare_LeftFile `n"
        $Beyond_Compare_ResultFile=$Beyond_Compare_ResultFiles[$iterator]+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")+'.html'
        BeyondCompare $Beyond_Compare_Parameters_File $Beyond_Compare_LeftFile $Beyond_Compare_RightFiles[$iterator] $Beyond_Compare_ResultFile
        $iterator++
}

$End_Message="Ending Automation "+[DateTime]::Now.ToString("yyyyMMdd-HHmmss")
LogWrite $End_Message