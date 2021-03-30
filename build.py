# Hack to be able to import local modules
import sys, os
sys.path.append(os.path.dirname(os.path.realpath(__file__)))
# Import leverage libraries
from leverage import task
from leverage import path

@task()
def apply():
    '''Deploy this application.'''
    if path.get_working_path() == path.get_account_path():
        os.system("kubectl apply -f argocd/application.yaml")
    else:
        print("This task can only be run from an account path")
