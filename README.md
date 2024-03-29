# I. Overview Project
This project is about automation test for "Oppenheimer" Project.

# II. Foler structure
We will go through some structure in the project, after that, you will know where to find the specific file and where you can edit the file.

## 1. Folders overview
Under the root folder "Oppenheimer", you will see some main folders like below:
+ Pages: contain all the POM (Page Object Model). It will contain some definition web page like web elements and method of that web page.

+ Reports: contains the report folder, after test run complete, we will check report files in this folder.

+ Resource: this folder contains the test data(csv data file for import will be put here) and also where you can store the request base url and request uri.

+ stepdifinition: will contains the steps definition files.

+ testsuites: contains all test cases of this project.

![folder structure](./Oppenheimer/images/img1.png )

## 2. Folder - Pages
This is folder which contains page object model. In our test case, we have 2 pages.
+ first page (http://localhost:8080/) this page is mapped to IndexPage.robot.
+ second page (http://localhost:8080/dispense) will be mapped to DispensePage.robot

![page object model](./Oppenheimer/images/img2.png )

## 3. Folder - Reporst
This folder contains all report files:
+ log.html
+ output.xml
+ report.html
after running test. this folder will be genereated with above files. and you can open the file report.html in the browser to view report.

![Report files](./Oppenheimer/images/img3.png )

## 4. Folder - resources
there are 2 main folders under "resource" folder.

+ "env" folder: current there are 2 sub folders (production and stage). Each folder will store the configuration of request api. This option will allow us to run the test on multiple env: "production" or "stage".

![Environment setting](./Oppenheimer/images/img4.png )

+ "testdata": this place is used for placed test data. for ex: I will put my csv file under the folder "importcsv". 

![data setting](./Oppenheimer/images/img5.png )

## 5. Folder - stepdefinition
Where you can store all step function. we will group steps into different folders: 
+ api: will contains step definition related to api only

+ fe: will contains step definition related to front end test only

+ utils: where you create more class util file python to support your testing

+ common: contains all common methods is used for all cross api and fe test.

![stepdifinition folder](./Oppenheimer/images/img6.png )


## 6. Folder - testsuites
this folder contains all test suites. Each test suites file will test a specific feature. and we seperate test case of api and test case of fe

![testcase folder](./Oppenheimer/images/img7.png )



# III. Setting Environment for running test case.
Cause we use 'Robot Framework' for our automation project. We need to install something so that we can use 'Robot Framework'

1. Install Python
Cause 'Robot Framework' is built on Python. that is why our OS require Python 3.xxx installed.

Please follow this site to install python on your computer

+ for window: https://phoenixnap.com/kb/how-to-install-python-3-windows

+ for macos: https://www.freecodecamp.org/news/python-version-on-mac-update/

+ for ubuntu/linux: https://phoenixnap.com/kb/how-to-install-python-3-ubuntu

2. Check if python is installed or not installed

Run this command to check if python is installed or not 

![check python version](./Oppenheimer/images/img8.png )

# IV. Run Test case

## 0. Create virtual env for testing.  
To avoid with conflict with your existing dependencies. We advise to create your own virtual env for testing.  

+ step 1: after you clone the project to your local. Go to root folder where contain the file requirement.txt.

![root folder](./Oppenheimer/images/img21.png )

+ step 2: open terminal and run this command to create your virtual env: virtualenv venv
note: you have to install virtualenv in your computer. use this link to refer: https://www.deadbear.io/how-to-install-virtualenv-on-mac-os/

![create virtual env ](./Oppenheimer/images/img22.png )

after this you will see a folder name "venv" is created.
![env folder ](./Oppenheimer/images/img23.png )


+ step 3: after you create virtual env with name "vevn" you need to activate it by using below command: source ./venv/bin/activate

![activate virtual env ](./Oppenheimer/images/img24.png )


## 1. Install dependencies before running the test cases.

Under the root folder "Oppenheimer" you will see a file called "requirement.txt". This file will contains all the dependencies required for our running test. 

![dependecies file](./Oppenheimer/images/img9.png )

Then open your terminal and go to root folder "Oppenheimer" and run the command: pip3 install -r requirement.txt 

![install dependecies](./Oppenheimer/images/img10.png )

## 2. Update some data config before testing
Go to file /Oppenheimer/config.py to edit env, browser and other configuration for testing.

![config file](./Oppenheimer/images/img10-a.png )

+ which env you want to run the test. cause current we have 2 env: 'production' and 'stage' (these name will be mapped to 2 folder under 'resources' folder)
Change the value of parameter 'env' to the value of env: stage or production.

![change env testing](./Oppenheimer/images/img11.png )

+ which browser you want to test. We have some browser: chromium, firefox, webkit.

![change browser testing](./Oppenheimer/images/img13.png )

+ if you want to run on headless mode, you should update the value in line 2 "HEADLESS" = True or set to False if you want to see UI mode

![change headless mode testing](./Oppenheimer/images/img12.png )

+ update the base url and uri request. You can update the base url and uri in the file : /Opperheimer/resources/env/stage/UriRequest.robot to change this request configuration on stage env, it is also the same thing for 'production' env

![change value for base url and request](./Oppenheimer/images/img14.png )

That all for setting all data before running test.

## 3. check test cases
Test cases are placed in location: 
+ /Oppenheimer/testsuites/api/CalculatorApiTestsuite.robot contains api test case

+ /Oppenheimer/testsuites/fe/CalculatorFeTestsuite.robot contains front end test case

![test case detail](./Oppenheimer/images/img15.png )

Contain a test case

![test case detail](./Oppenheimer/images/img16.png )

## 4. run test cases
Open terminal and go to root folder /Oppenheimer
+ Step 1: cause we are using 'Playwright' Framework for UI Test then we have to install Playwright Framework first. Open terminal and run the following command: rfbrowser init
and wait until the command run complete. It will take sometime because it need to download some driver for us.
Noted: this step also download the driver for us.  

![init browser framwork](./Oppenheimer/images/img20.png )


+ Step 2: after complete step 1, you can continue run this command to run test case: robot --outputdir Reports --variablefile config.py testsuites/

note: 
+ if you want to api test only you can specify command like this: robot --outputdir Reports --variablefile config.py testsuites/api/

+ if you want to fe test only you can specify command like this: robot --outputdir Reports --variablefile config.py testsuites/fe/

+ if you want to run specific test only use option --inlcude with tag name. 
ex: robot --outputdir Reports --variablefile config.py --include api testsuites/

![how to run test](./Oppenheimer/images/img17.png )

## 5. check report
After run the test, you will see the report in the folder /Oppenheimer/Reports

![check report](./Oppenheimer/images/img18.png )

open the file /Oppenheimer/Reports/report.html on chrome browser to see the detail 

![check report](./Oppenheimer/images/img19.png )