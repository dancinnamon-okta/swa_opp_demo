# swa_opp_demo
Demonstration of integrating an old legacy application with Okta.  It is setup to run all necessary components within docker containers- allowing the entire codebase to be portable.

## Components
**1. Container - opp**

   This is the container that the OPP agent runs in.  During the build of the container, authorization to the chosen Okta org is performed.
   
**2. Container - app**

   This container is where the web app + SCIM connector runs.  At runtime, the python logic for the application and SCIM connector are pulled live. By default this logic is loaded from https://github.com/dancinnamon-okta/simple_swa_demo
   
**3. docker-compose.yaml**

   This is the configuration for the entire project.  It dictates what containers will run, and shares the global SSL certificate/key with both containers.
   
**4. .env**

   This file is what will be filled out with your information to point the entire project at a given git repository for the application logic, and at which Okta org for the OPP agent.

## Pre-Requisites
This application, while running in docker, has currently only been tested while running on a MacOS host.  That being said it should be pretty basic to modify the build process to run under any OS.

**1. OpenSSL**

   For generating the self-signed SSL cert that the web app uses, and is trusted by the OPP agent.  OpenSSL is typically included in every OS by default except Windows.
   
**2. Docker w/ docker-compose**

   For actually running the solution.

## How To Build

**1. Download this repository**
    Either download as a zip file (https://github.com/dancinnamon-okta/simple_swa_demo/archive/master.zip) or by using git.
    
**2. Specify your settings in the .env file
   Only 3 things needed:
   1. OKTA_ORG (set to your Okta subdomain name)
   2. OKTA_ORG_TYPE (set to 'okta' or 'oktapreview' as appropriate)
   3. APP_CODEBASE (set to a git repository of your choice, or https://github.com/dancinnamon-okta/simple_swa_demo.git)
   
**3. Run build.sh

*Note- During the build process, the device-code authorization flow will kick off to our Okta org.  You'll be asked to authenticate against this org.  I've found that you need to perform that authorization step **TWICE** for the OPP agent setup to pick it up.*

**You're done!**

## How To Run
In your same working directory (that was created when you unzipped the repository in step 1 of the build process) run:
`docker-compose up`

That command will start both containers, and the web app container will get the latest code from the repository specified in step 2 of the build process.

Visit https://localhost:9000/login to see your creation!
