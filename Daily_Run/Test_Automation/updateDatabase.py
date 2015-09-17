'''
Created on Jun 15, 2014
@author: gyorulmaz
'''

import shutil
import os
import subprocess

'''
This is a function to upgrade the databases to the latest version of esimanage.
'''
def upgrade_Q7TestAutomation(path_to_upgrade):
    destination= os.path.join(path_to_upgrade, 'product/esi.manage-dbscripts/UpdateDatabases.bat')
    if not os.path.exists(destination):
        shutil.copy("C:\\Q7TestAutomation_Database//UpdateDatabases.bat",os.path.join(path_to_upgrade ,'product\esi.manage-dbscripts'))
    subprocess.call(destination)
    return