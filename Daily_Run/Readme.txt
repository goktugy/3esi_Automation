Overview
--------
This is a guide for setting up daily test automation run environment for Q7 scripts.
As an overview the daily test automation is made of python scripts, batch files 
and Q7 automation scripts. 

Structure Layout
-----------------
All of the folders are located under the C:\ drive on our test automation machine 3es0188.

Important folders:

q7_1_3_12
-----------
This is where you can find Q7 working environment.

q7runner_1_3_12
-----------------
This is where you can find an instance of Q7 Runner.

QTestAutomation_Runner
------------------------
This is where the batch file to launch Q7Runner is located. The file is named run-q7tests_3esi_License_Server.bat
In this batch file you set up the necessary parameters to launch q7runner.

These settings:

-autVMArgs -D3esi.server=3es0209;-D3esi.instance=SQL2008R2;-D3esi.database=Q7TestAutomation;-Dosgi.nl=en_CA ^  <---Sets the database where to run the automation and tells Q7 to use the English Canadian locale
-suites Regression_Tests ^  <--- Indicates what Q7 test suite to run.
-reuseExistingWorkspace ^   <--- This is set so that we can

are quite important as 	 

Q7TestAutomation_Database
---------------------------
This is where you are going to find the batch file that is executed by the daily run automation to upgrade the databases.

Regression Testing
--------------------
This is the folder location where you can find the import and configuration files that are needed to run the regression tests.

Test_Automation_Configuration
-------------------------------
This is where the configuration file for running the Q7TestAutomation is located.

Test_Automation
----------------
This is where the result of Q7TestAutomation run are created.
 
Starting The Automation
-------------------------
The automation is configured to run as a daily task in Windows Task Scheduler. 
The name of the task is called Test_Automation. When the automation is run
through Winds Task Scheduler it will create log files at 
C:\Windows\SysWOW64

Configuration
--------------
You can get the latest source code at
svn://cgybuild3/qa/esi.manage/Q7TestAutomation/Daily_Run/Test_Automation

Mapped Drives:
A: This mapped drive points to Ayman's shared folder where we can copy the latest build.
B: This mapped drive points to the location where the automation run results are created. 
G: This mapped drive points to Gea's shared folder where we can copy the latest folder.
R: This mapped drive points to Rami's shared folder where we can copy the latest folder.

Understanding The Source Code
------------------------------
TestAutomation.py
This is the main module where the automation runs.
The main execution of the script is  

*Find the latest build in the network. 
To retrieve the location of the latest build the script looks at the configuration file
located at C:\Test_Automation_Configuration\configuration.cfg

*Copy the latest build in the network to local C:\Builds and mapped drives A:, R:, G:

*Perform a database upgrade. This is performed in the updateDatabase.py module.
To run the database upgrade, the script also relies on the batch file that is located at
C:\Q7TestAutomation_Database\UpdateDatabases.bat 

*Run The Q7 Test Automation Scripts. This is performed in the runQ7Automation.py module
To run the automation, the script first changes the name of the latest copied esi.manage 
folder to "Automation" and invokes the batch file at C:\Q7TestAutomation_Runner\run-q7tests_3esi_License_Server.bat
After the automation is run the original name of the folder is restored. In addition 
the result of the automation is copied to the mapped B:\ drive.

*A notification email is sent. ->This is performed in the SMTPMail.py module.





