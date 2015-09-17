'''
Created on Jun 12, 2014
@author: gyorulmaz
'''

import shutil
import os
import updateDatabase
import configparser
import logging
import runQ7Automation

# Specified in TestAutomation.main()
scriptOutputLogFilePath = "C:\\Test_Automation_Logging\\automation.log"
# Specified in test automation Task Scheduler task
taskSchedulerOutputLogFilePath = "C:\\Test_Automation_Logging\\automationDetails.log"

logFiles = [scriptOutputLogFilePath, taskSchedulerOutputLogFilePath]

'''
This is a function to get the latest folder on \\cgybuild1/LatestBuild folder
'''
def get_latest_folder(builds,version):
    subfolders = []
    for files in os.listdir(builds):
        if(files.startswith(version) and not 'BUILD' in files ):
            check_subfolder = os.path.join(builds, files)
            if os.path.isdir(check_subfolder):subfolders.append(check_subfolder)
    latest_build = max(subfolders, key=os.path.getmtime)
    return latest_build

'''
This is a function to copy the folder from source destination to target location
The function checks that the folder does not already exist
'''
def copy_files_to_build(source):
    pathLocal = "C:\\LocalBuilds"
    pathAyman = "\\\\3es0192\LatestBuild"
    pathRami = "\\\\3es0253\esi.manageLatestBuild"
    
    destination= os.path.join("C:\\builds",source[24:])
    LocalMachine= os.path.join(pathLocal,source[24:])
    Ayman=os.path.join(pathAyman, source[24:])
    Rami=os.path.join(pathRami, source[24:])
    
    logging.info("Checking build paths....")
    
    if not os.path.exists(destination):
        logging.info("Copying from source: " + source + " to destination: " + destination)
        shutil.copytree(source, destination)
    
    if not os.path.exists(LocalMachine):
        logging.info("Copying from source: " + source + " to local machine destination: " + LocalMachine)
        shutil.copytree(source, LocalMachine)
    
    if not os.path.exists(Ayman):
        logging.info("Copying from source: " + source + " to Ayman's destination: " + Ayman)
        shutil.copytree(source, Ayman)
        
    if not os.path.exists(Rami):
        logging.info("Copying from source: " + source + " to Rami's destination: " + Rami)
        shutil.copytree(source, Rami)  
    
    logging.info("Checks complete.")
    
    #Here we are copying the environment files for each build in LocalMachine,Ayman,Rami machines
    environmentFile='C:\Q7TestAutomation_Database\esi.manage.dbenv'
    environmentFile_2='C:\Q7TestAutomation_Database\esi.manage_amd64.dbenv'
    
    logging.info("Checking dbenv paths...")
    
    Local_environmentFile= os.path.join(pathLocal,source[24:]+"\product\esi.manage") 
    Ayman_environmentFile= os.path.join(pathAyman,source[24:]+"\product\esi.manage")
    Rami_environmentFile= os.path.join(pathRami,source[24:]+"\product\esi.manage")
    
    if not os.path.exists(os.path.join(Local_environmentFile,"esi.manage.dbenv")):
        shutil.copy(environmentFile, Local_environmentFile)
        shutil.copy(environmentFile_2, Local_environmentFile)
    
    if not os.path.exists(os.path.join(Ayman_environmentFile,"esi.manage.dbenv")):
        shutil.copy(environmentFile, Ayman_environmentFile)
        shutil.copy(environmentFile_2, Ayman_environmentFile)
        
    if not os.path.exists(os.path.join(Rami_environmentFile,"esi.manage.dbenv")):
        shutil.copy(environmentFile, Rami_environmentFile)
        shutil.copy(environmentFile_2, Rami_environmentFile)
        
    logging.info("Checks complete.")

    return destination

if __name__ == "__main__" :
    #Setup Logger
    logging.basicConfig(level=logging.DEBUG,
                    format='%(asctime)s %(levelname)-8s %(message)s',
                    datefmt='%a, %d %b %Y %H:%M:%S',
                    filename=scriptOutputLogFilePath,
                    filemode='w')
    
    logging.info("Retrieving configuration information")

    #Configuration Parser
    config=configparser.RawConfigParser()
    configurationFile= os.path.join(os.getcwd(),"C:\\Test_Automation_Configuration\configuration.cfg")
    config.read(configurationFile)
    
    '''
    Retrieve the location of the builds for esi.manage from configuration file
    Retrieve the esi.manage version for esi.manage from configuration file
    '''
    build_path=config.get("automation", "latestBuild")
    logging.info("Build path is %s", build_path)
    esimanageVersion=config.get("automation", "esimanage")
    logging.info("Esi Manage Version is %s", esimanageVersion)
    
    #Get the latest build
    latest_build=get_latest_folder(build_path,esimanageVersion)
    logging.info("The latest folder is %s", latest_build)
    
    #Copy the latest build to the test automation machine
    copied_location=copy_files_to_build(latest_build)
    logging.info("Copied location is %s", copied_location)
    logging.info("Copied Build To 3es0188 Machine")
    
    #Update the database to the correct version
    logging.info("Updating the databases to copied version")
    updateDatabase.upgrade_Q7TestAutomation(copied_location)
    
    logging.info("Running Q7 Test Automation")
    runQ7Automation.runAutomation(copied_location)
    
    logging.info("Copying Q7 Test Automation Results")
    runQ7Automation.copyResults(scriptOutputLogFilePath)
    
    logging.info("Sending Q7 Test Automation Results")
    logging.info("Done.")
    
    runQ7Automation.sendResult(logFiles)