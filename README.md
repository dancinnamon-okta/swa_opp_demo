# swa_opp_demo
Demonstration of integrating an old legacy application with Okta.  It is setup to run all necessary components within docker containers- allowing the entire codebase to be portable.

!**Please see the Lab guide file for the best setup instructions**!

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

**2. Create a new SWA app within your Okta instance.  At this time you only need to follow step 1 of the "How to Configure Okta" section below- you need the application to be created in order to fill out the .env file correctly in step 3.

**3. Specify your settings in the .env file (an example is included- modify this file)
   Only 3 things needed:
   1. OKTA_ORG (set to your Okta subdomain name)
   2. OKTA_ORG_TYPE (set to 'okta' or 'oktapreview' as appropriate)
   3. APP_CODEBASE (set to a git repository of your choice, or https://github.com/dancinnamon-okta/simple_swa_demo.git)
   4. API_KEY (set to a long value that you choose. This is what Okta will use to authenticate with when provisioning.
   5. OKTA_APP_NAME (set to the name of the application in Okta that we'll connect to).
   
**4. Run build.sh

*Note- During the build process, the device-code authorization flow will kick off to our Okta org.  You'll be asked to authenticate against this org.  I've found that you need to perform that authorization step **TWICE** for the OPP agent setup to pick it up.*

**You're done!**

## How To Run
In your same working directory (that was created when you unzipped the repository in step 1 of the build process) run:
`docker-compose up`

That command will start both containers, and the web app container will get the latest code from the repository specified in step 2 of the build process.

Visit https://localhost:9000/login to see your creation!

## How to Configure Okta
While this guide assumes a working understanding of how to configure Okta, there are a few requirements when setting up the new Okta application that you should be aware of.

**1. Create a new SWA application in the Okta org.**

This is pretty straightforward, create a basic SWA app that will be used to provision/authenticate users into the application we just stood up.  Grab the name of the application within Okta (as shown) as it will be needed for the .env file!
![App Name Example](https://github.com/dancinnamon-okta/swa_opp_demo/blob/master/readme_images/swa_app_name.jpg "Example of obtaining the app name")


**2. Enable on-premise provisioning for the app.**

See the following screenshot- note the enabling of on-premise provisioning, and the https://localhost:9000/login page.
![General Example](https://github.com/dancinnamon-okta/swa_opp_demo/blob/master/readme_images/swa_app_general.jpg "Example general tab")

**3. Configure on-premise provisioning for the app.**

See the following screenshot.  A couple of notes:
* The SCIM connector URL ***MUST BE***: https://demowebapp:9000/scim/v2/. "demowebapp" is the internal docker name of the web-app container (remember the network communication is just between the 2 docker containers here).  "demowebapp" is also the CN on the SSL certificate.

* The unique user name field must be "userName"

* Ensure that you select the OPP agent that you wish to use.  It's likely you'll only have 1 option here.
![provisioning example 1](https://github.com/dancinnamon-okta/swa_opp_demo/blob/master/readme_images/swa_app_provisioning.jpg "Example provisioning tab")

**4. Setup password synchronization.**

See the following screenshot.  Setup as you wish.  It's recommended to synchronize a random password so that users may not know what the password is.  This will force them to authenticate through Okta, and MFA may be applied if desired.
![provisioning example 2](https://github.com/dancinnamon-okta/swa_opp_demo/blob/master/readme_images/swa_app_provisioning2.jpg "Example provisioning tab 2")

**5. Assign a user.**

At this point you're all set- you should be able to assign a user at will, and they will automatically be provisioned into the application.  Group push is also implemented.  Experiment!
![assign](https://github.com/dancinnamon-okta/swa_opp_demo/blob/master/readme_images/swa_app_assignments.jpg "Example assignments tab")

**6. Setup additional profile attributes.**

The following attributes can be specified on the Okta appuser profile for this app:
- department
- opt_in
- company_name
- country
- phone_number

![profile page](https://github.com/dancinnamon-okta/swa_opp_demo/blob/master/readme_images/swa_app_profile.jpg "Example profile")

Additionally, this application is looking for a group called "Catalog Admin".  If the user has this group, then they are an admin and can view the admin pages.
