Overview
--------------
The measure export automation is a powershell script that automates the creating of measure exports. 

Different measure exports are created with two different esi.manage builds.(Measure_Export_Baseline, Measure_Export_Comparison)

Currently the benchamrk that is used to compare results against is esi.manage 3.15.

The newly created measure export files are later compared with a diff operation utility by the name of Beyond Compare.

Discrepancies between the measure exports from differrent esi.manage versions are stored in an .html report using the Beyond Compare utility as well.

Structure Layout
-----------------
1)MeasureExport
In this folder the measure exports from different esi.manage versions are created.

2)References
In this folder all the reference files for measure exports are stored. These references contain the configurations that are 
needed to run measure export executable. 

The reference files that have the suffix _1 are passed to esi.manage 3.15 which serves as a baseline answer key set.

3)Reports
Diff reports are created in this folder. The reports that are created have the date and time appended to them.

4)Automation.ini
This is the configuration file where you need to set the following

//The path to Measure Export
Measure_Export=C:\Builds\3.15PackageWithPeep\esi.manage.export.measure\exportMeasure.exe

//The path to Measure Export where you wil perfrom the comparison
Measure_Export_Comparison=C:\Builds\manage-trunk-2013-07-26_09-42\product\esi.manage.export.measure\exportMeasure.exe

//The path to Beyond Compare executable
Beyond_Compare=C:\Program Files (x86)\Beyond Compare 3\bcompare.exe

//The baseline version of esi.manage
Base_Version=315

//The comparison version of esi.manage
Compare_Version=318

5)Clean.bat
This batch file can be used to clean the MeasureExport,Reports directories and the log file "Test_Atuoamtion.log" that is created in this folder.

6)HTML_Output_Compare_Two Files
This is the configuration file that is fed to BeyondCompare. The configuration file provides the settings to BeyondCompare 
to create a diff file in an .html format.

7)Measure_Export_Automation.ps1
This is the main powershell script that performs the automation.

8)README.txt
The file you are reading now.

9)Test_Automation.log
This is the log file that is created as the automation runs. 
You may review this file to see the progress of the automation during a run.

Starting The Automation
-------------------------
You may run the automation from the command line typing
powershell.exe -command .\Measure_Export_Automation.ps1.
Alternatively you can start powershell ISE and run the script from the ISE itself.

In case you get an error with respect to not having permissions, simply
type at the command line Set-ExecutionPolicy unrestricted and answer Y to the warning that is presented.
By default PowerShell scripts need to be enabled and permitted to run before execution.


Configuration
--------------
Step 1:
You may copy the automation to any directory you wish provided that there are no spaces in the path.

Step 2:
In the Automation.ini file you need to provide correct paths to executables.

Step 3:
You can change the database against which you test by changing the references file under references folder.

In a reference file this is specified by the entry:

-d "3es0208:1435/SMOG"

The default databases used for testing are 315SMOG and SMOG located at 3ES0208 at port 1435.

Also change the name and location of the output file from the mesaure export.

In a referene file this is specified by the entry:

-o C:\MeasureExportAutomation\MeasureExport\318production.csv

Set the ouput path to the location where you installed the automation and name the output file with the extension .csv and prefix the numbers of the build you are testing.

For example:

-o Location_To_Installation\MeasureExport\XXXproduction.csv  where XXX is 318

Step 4:
Run the automation as described in Starting The Automation section.




