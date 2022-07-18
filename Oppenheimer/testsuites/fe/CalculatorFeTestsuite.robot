*** Settings ***
Documentation       This test suite contains all front end test cases related to Calculator features.
Resource            ../../stepdefinition/common/CommonSteps.robot
Resource            ../../stepdefinition/fe/CalculatorFeSteps.robot
Resource            ../../stepdefinition/api/CalculatorApiSteps.robot
Resource            ../../stepdefinition/api/DatabaseApiSteps.robot
Resource            ../../resources/env/${env}/UriRequest.robot
Library             OperatingSystem
Library             Browser    timeout=30s

Test Setup      Make POST Request To Clear Database    # before running any test, we clear the database.
Test Teardown    Close Browser

*** Test Cases ***
As the Clerk, I should be able to upload a csv file to a portal to populate into database
    [Documentation]    This test case is used for testing import csv file with multiple person
    ...    Pre-condition:    we will clear our database first to avoid duplicate data inserted.
    ...    Step 1: we need to know the location of csv file. Current we input the csv file at location: /resource/testdata/importcsv/
    ...    Please note that we should name the file is data.csv
    ...    Step 2: we will generate a list of person
    ...    Step 3: we will clear existing csv file first, then we create new csv file with data is on step 1
    ...    Step 4: Open browser and go to our appliation url
    ...    Step 5: we will upload file, and wait for 30s to complete process
    ...    Step 6: we will send reques to get list of tax relief
    ...    Step 7: we will validation our person in step 1 will exist in list tax relief on response of step 6
    ...    Step 8: close the browser
    [Tags]    fe    calculator
    ${test_data_location}    Get Location Of Test Data CSV
    Delete Existing CSV File    ${test_data_location}
    ${file_name}    Set Variable    data.csv
    ${number}    Evaluate    random.randint(2,5)    random
    ${list_person_data}    Generate List Random Person    ${number}
    Generate Data To CSV File    ${test_data_location}    ${file_name}    ${list_person_data}
    ${csv_file}=    Set Variable    ${test_data_location}/${file_name}
    Open Browser And Go To Application    ${BASE_URL}
    Upload CSV File    ${csv_file}
    Sleep    30s
    ${response_tax_relief}=    Make Post Request To Get Tax Relief
    ${actual_code_tax_relief}    ${actual_content_tax_relief}=    Get Response Status And Body    ${response_tax_relief}
    Assert Insert Person To Database Successfully    ${actual_content_tax_relief}    ${list_person_data}


As the Governor, I should be able to see a button on the screen so that I can dispense tax relief for my working class heroes
    [Documentation]    This test case is used for testing dispense now function.
    ...    Pre-condition:    we will clear our database first to avoid duplicate data inserted.
    ...    Step 1: we will generate list of insert person
    ...    Step 2 : we will send request to insert multiple persons for data testing.
    ...    Step 3: we open the browser and validate the color of dispense button is red and the text is "Dispense Now"
    ...    Step 4: we will click dispense button and it will navigate to other page.
    ...    Step 5: we will wait until page load complete and get source of the page and validate the source page contains the text "Cash dispensed"
    [Tags]    fe    calculator    temp
    ${number}    Evaluate    random.randint(2,10)    random
    ${list_person}    Generate List Random Person    ${number}
    ${response}=    Make POST Request To Insert Multple Person    ${list_person}
    ${actual_code}    ${actual_content}=    Get Response Status And Body    ${response}
    Assert Response Status Is Correct    202    ${actual_code}
    Assert Response Content Is Correct    Alright    ${actual_content}
    Open Browser And Go To Application    ${BASE_URL}
    ${expected_color}=    Set Variable    rgb(220, 53, 69)    #this is red color
    ${expected_text}=    Set Variable    Dispense Now
    Assert BackGround Color Of Button Dispense Is Correct    ${expected_color}
    Assert The Text Of Button Dispense Is Correct    ${expected_text}
    Dispense Tax Relieve
    Assert Dispense Successfully