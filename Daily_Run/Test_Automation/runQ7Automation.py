'''
Created on Jun 24, 2014

@author: gyorulmaz
'''
import os
import smtplib
import subprocess
import time
import shutil
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders

def copyResults(scriptOutputLogFilePath):
    automationResultsPath = "\\\\cgyfile1\QA\Test_Automation_Results"
    automationResults = automationResultsPath + "\Test_Automation_Run_%4d_%02d_%02d_%02d_%02d_%02d"
    
    directoryName=automationResults % time.localtime()[0:6]
    os.mkdir(directoryName)
    shutil.copy("C:\Test_Automation\Q7_Run_Reports\Q7Report.html", directoryName)
    shutil.copy(scriptOutputLogFilePath, directoryName)
    shutil.copytree("C:\Test_Automation\Q7_Run_Reports\images", os.path.join(directoryName,'images'))
    return

def renameCopiedLocation(location):
    os.rename(location,"C:\Builds\Automation")
    return

def runAutomation(location):
    renameCopiedLocation(location)
    q7RunnerAutomation="C:\\Q7TestAutomation_Runner\\run-q7tests_3esi_License_server.bat"
    subprocess.call(q7RunnerAutomation)
    os.rename("C:\Builds\Automation", location)
    return

def sendResult(files):
    testUserMail = "qauser1@3esi.com"
    testUserTargets = "aissa@3esi.com,rarar@3esi.com"
    
    msg = MIMEMultipart()
    msg['Subject'] = "Test Automation Results"
    msg['From'] = testUserMail
    msg['To'] = testUserMail
    msg["Cc"] = testUserTargets
    body = MIMEText("Please Review Test Automation Results at \\\\cgyfile1\QA\Test_Automation_Results ")
    msg.attach(body)
    
    # Send the message via our own SMTP server.
    for f in files:
        part = MIMEBase('application', "octet-stream")
        part.set_payload(open(os.path.abspath(f), "rb").read())
        encoders.encode_base64(part)
        part.add_header('Content-Disposition', 'attachment; filename="%s"' % os.path.basename(f))
        msg.attach(part)
    
    smtp = smtplib.SMTP('cgymail1',25)
    smtp.ehlo()
    smtp.starttls()
    smtp.ehlo
    smtp.login("qauser1","N2TNLfrDQVfL")
    smtp.sendmail(msg["From"], msg["To"].split(",") + msg["Cc"].split(","), msg.as_string())
    smtp.quit()
    return 