@echo off

REM Delete Previous Result And Log Files
del C:\JMeter\All-Web-Services.jtl
del C:\JMeter\All-Web-Services.log
del C:\JMeter\Assertion_Results.log
del C:\JMeter\JMeter_WS.log
del C:\JMeter\Results_Table.csv

REM Run JMETER 
C:\JMeter\apache-jmeter-2.9\bin\jmeter-n  C:\JMeter\All-Web-Services.jmx