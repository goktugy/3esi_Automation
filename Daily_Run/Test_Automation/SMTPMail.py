'''
Created on Jul 23, 2014

@author: gyorulmaz
'''

import smtplib
from email.mime.text import MIMEText
from email.mime.multipart import MIMEMultipart
from email.mime.base import MIMEBase
from email import encoders

def sendResult_Basic():
    sender="gyorulmaz@3esi.com"
    receivers= ['gyorulmaz@3esi.com']
    message="Test Automation Result"
    try:
        server = smtplib.SMTP('cgymail1',25)
        server.sendmail(sender,receivers,message)
        print("Successfully sent email")
    except:
        print("Unable to send email")
    return

def sendResult():
    msg = MIMEMultipart()
    msg['Subject'] = "Test Automation Results"
    msg['From'] = "test-automation-do-not-reply@3esi.com"
    msg['To'] = "gyorulmaz@3esi.com"
    msg["Cc"] = "gyorulmaza@3esi.com"
    body = MIMEText("Please Review Test Automation Results")
    msg.attach(body)
    # Send the message via our own SMTP server.
    part = MIMEBase('application', "octet-stream")
    part.set_payload(open("esiManageTestAutomation.log","rb").read() )
    encoders.encode_base64(part)
    part.add_header('Content-Disposition', 'attachment; filename=esiManageTestAutomation.log')
    msg.attach(part)
    
    smtp = smtplib.SMTP('cgymail1',25)
    smtp.ehlo()
    smtp.starttls()
    smtp.ehlo
    smtp.login("gyorulmaz","Calgary06062014!")
    smtp.sendmail(msg["From"], msg["To"].split(",") + msg["Cc"].split(","), msg.as_string())
    smtp.quit()
    return 

if __name__ == "__main__" :
    sendResult()