*** Settings ***
Documentation    This test suite contains all api test cases related to Calculator features.
Resource         ../../stepdefinition/common/CommonSteps.robot
Resource         ../../stepdefinition/api/CalculatorApiSteps.robot
Resource         ../../stepdefinition/api/DatabaseApiSteps.robot

Test Setup      Make POST Request To Clear Database     # before running any test, we clear the database.

*** Test Cases ***
As the Clerk, I can insert a single record of working class hero into database via an API successfully
    [Documentation]    This test case is used for test api insert a working class hero into DB via API
    ...    Pre-condition: we will send request to clear our database first.
    ...    Step 1: we need to generate some random data like: birthday, name, gender, natid, salary and tax.
    ...    Step 2: we send request api insert 1 working hero class
    ...    Step 3: we will got response status code and response content from response of step 2
    ...    Step 4: assert the status code is 202 and content is 'Alright'
    ...    Step 5: we will send request to get tax relief, we will have a list a tax relief
    ...    Step 6: we will velidate if our data insert (on step 1: name, natid) exist on the list relief of step 5.
    [Tags]    api    calculator
    ${birthday}=    Generate A Random Birthday
    ${name}=    Generate A Random Name
    ${gender}=    Generate A Random Gender
    ${natid}=    Generate A Random Natural ID Code    ${name}
    ${salary}=    Generate A Random Salary
    ${tax}=    Generate A Tax Base On Salary    ${salary}
    ${response}=    Make POST Request To Insert A Person    ${birthday}    ${gender}    ${name}    ${natid}    ${salary}    ${tax}
    ${actual_code}    ${actual_content}=    Get Response Status And Body    ${response}
    ${expected_status}=    Set Variable    202
    ${expected_content}=    Set Variable    Alright
    Assert Response Status Is Correct    ${expected_status}    ${actual_code}
    Assert Response Content Is Correct    ${expected_content}    ${actual_content}
    ${response}=    Make Post Request To Get Tax Relief
    ${actual_code}    ${actual_content}=    Get Response Status And Body    ${response}
    ${person}    Create Dictionary    name=${name}    natid=${natid}    birthday=${birthday}    gender=${gender}    salary=${salary}   tax=${tax}
    @{list_person}    Create List    ${person}
    Assert Insert Person To Database Successfully    ${actual_content}    ${list_person}


As the Clerk, I can insert more than one working class hero into database via an API successfully
    [Documentation]    This test case is used for test api insert multiple working class hero into DB via API
    ...    Pre-condition: we will send request to clear our database first.
    ...    Step 1: we need to generate list of number person we will insert.
    ...    Step 2: we send request api insert list working hero class on step 1
    ...    Step 3: we will got response status code and response content from response of step 2
    ...    Step 4: assert the status code is 202 and content is 'Alright'
    ...    Step 5: we will send request to get tax relief, we will have a list a tax relief
    ...    Step 6: we will velidate if our data insert (on step 1: name, natid) exist on the list relief of step 5.
    [Tags]    api    calculator
    ${number}=    Evaluate    random.randint(2,5)    random    #we will generate random number of person which we will create
    ${list_person}=    Generate List Random Person    ${number}    #we will generate list of person
    ${response}=    Make POST Request To Insert Multple Person    ${list_person}
    ${actual_code}    ${actual_content}=    Get Response Status And Body    ${response}
    ${expected_status}=    Set Variable    202
    ${expected_content}=    Set Variable    Alright
    Assert Response Status Is Correct    ${expected_status}    ${actual_code}
    Assert Response Content Is Correct    ${expected_content}    ${actual_content}
    ${response_tax_relief}=    Make Post Request To Get Tax Relief
    ${actual_code_tax_relief}    ${actual_content_tax_relief}=    Get Response Status And Body    ${response_tax_relief}
    Assert Insert Person To Database Successfully    ${actual_content_tax_relief}    ${list_person}


As the Bookkeeper I can query the amount of tax relief for each person in the database via API successfully
    [Documentation]    This test case is used for test api query the tax relief of each person via API
    ...    Pre-condition: we will send request to clear our database first.
    ...    Step 1: we need to generate list of number person we will insert (just for data testing)
    ...    Step 2: we send request api insert list working hero class on step 1
    ...    Step 3: we will got response status code and response content from response of step 2
    ...    Step 4: assert the status code is 202 and content is 'Alright'
    ...    Step 5: we will send request to get tax relief, we will have a list a tax relief
    ...    Step 6: we will velidate if our data insert (on step 1: name, natid, relief amount) exist on the list relief of step 5
    ...    Note: in this case i only compare the integer part, I dont validate the decimal part, cause i am not aware how rounding in code dev.
    [Tags]    api    calculator
    ${number}    Evaluate    random.randint(2,10)    random
    ${list_person}    Generate List Random Person    ${number}
    ${response}=    Make POST Request To Insert Multple Person    ${list_person}
    ${actual_code}    ${actual_content}=    Get Response Status And Body    ${response}
    Assert Response Status Is Correct    202    ${actual_code}
    Assert Response Content Is Correct    Alright    ${actual_content}
    ${response}=    Make Post Request To Get Tax Relief
    ${code}    ${actual_content}=    Get Response Status And Body    ${response}
    Assert Response Status Is Correct    202    ${actual_code}
    Assert Tax Relief Amount Computation Is Correct    ${actual_content}    ${list_person}

As the Clerk, I can not insert a working class hero into database with invalid birthday via an API
    [Documentation]    This test case is used for test api insert 1 working hero class but invalid birthday
    ...    Pre-condition: we will delete all data in DB.
    ...    Step 1: generate data but for birthday is empty
    ...    Step 2: send request to insert working class hero
    ...    Step 3: assert response error
    ...    Step 4: send query to get tax relief list
    ...    Step 5: assert response of step 4 is empty due to there is no record is inserted.
    [Tags]    api    calculator
    ${birthday}=    Set Variable    ${EMPTY}    #we will send birthday is empty field
    ${name}=    Generate A Random Name
    ${gender}=    Generate A Random Gender
    ${natid}=    Generate A Random Natural ID Code    ${name}
    ${salary}=    Generate A Random Salary
    ${tax}=    Generate A Tax Base On Salary    ${salary}
    ${response}=    Run Keyword and Ignore Error    Make POST Request To Insert A Person    ${birthday}    ${gender}    ${name}    ${natid}    ${salary}    ${tax}
    Assert Response Error    ${response}
    ${response_tax_relief}=    Make Post Request To Get Tax Relief
    ${actual_code}    ${actual_content}=    Get Response Status And Body    ${response_tax_relief}
    Assert Response Status Is Correct    200    ${actual_code}
    Assert Tax Relief Is Empty    ${actual_content}


As the Clerk, I can not insert a working class hero into database with invalid salary via an API
    [Documentation]    This test case is used for test api insert 1 working hero class but invalid salary
    ...    Pre-condition: we will delete all data in DB.
    ...    Step 1: generate data but for salary is 'aaabbbb' not a number.
    ...    Step 2: send request to insert working class hero
    ...    Step 3: assert response error
    ...    Step 4: send query to get tax relief list
    ...    Step 5: assert response of step 4 is empty due to there is no record is inserted.
    [Tags]    api    calculator
    ${birthday}=    Generate A Random Birthday
    ${name}=    Generate A Random Name
    ${gender}=    Generate A Random Gender
    ${natid}=    Generate A Random Natural ID Code    ${name}
    ${salary}=    Set Variable    aaabbb    #invalid salary
    ${tax}=    Set Variable    500
    ${response}=    Run Keyword and Ignore Error    Make POST Request To Insert A Person    ${birthday}    ${gender}    ${name}    ${natid}    ${salary}    ${tax}
    Assert Response Error    ${response}
    ${response_tax_relief}=    Make Post Request To Get Tax Relief
    ${actual_code}    ${actual_content}=    Get Response Status And Body    ${response_tax_relief}
    Assert Response Status Is Correct    200    ${actual_code}
    Assert Tax Relief Is Empty    ${actual_content}

As the Clerk, I can not insert a working class hero into database with empty salary via an API
    [Documentation]    This test case is used for test api insert 1 working hero class but invalid salary
    ...    Pre-condition: we will delete all data in DB.
    ...    Step 1: generate data but for salary is 'aaabbbb' not a number.
    ...    Step 2: send request to insert working class hero
    ...    Step 3: assert response error
    ...    Step 4: send query to get tax relief list
    ...    Step 5: assert response of step 4 is empty due to there is no record is inserted.
    [Tags]    api    calculator    temp
    ${birthday}=    Generate A Random Birthday
    ${name}=    Generate A Random Name
    ${gender}=    Generate A Random Gender
    ${natid}=    Generate A Random Natural ID Code    ${name}
    ${salary}=    Set Variable    ${EMPTY}    #invalid salary
    ${tax}=    Set Variable    500
    ${response}=    Run Keyword and Ignore Error    Make POST Request To Insert A Person    ${birthday}    ${gender}    ${name}    ${natid}    ${salary}    ${tax}
    Assert Response Error    ${response}
    ${response_tax_relief}=    Make Post Request To Get Tax Relief
    ${actual_code}    ${actual_content}=    Get Response Status And Body    ${response_tax_relief}
    Assert Response Status Is Correct    200    ${actual_code}
    Assert Tax Relief Is Empty    ${actual_content}
