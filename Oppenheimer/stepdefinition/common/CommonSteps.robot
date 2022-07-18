*** Settings ***
Documentation    this file contains common steps definition
Library          FakerLibrary
Library          BuiltIn
Library          String
Library          ../utils/hero_utils.py
Library          Browser    timeout=30s


*** Keywords ***
Generate A Random Name
    [Documentation]    This keyword is used for genarating a random name
    ${name}    Name
    [Return]    ${name}

Generate A Random Birthday
    [Documentation]    This keyword is used for genarating a random birthday which age >=18 and age<=80
    ${date}    Date Of Birth    minimum_age=18    maximum_age=80
    ${date}    convert to string    ${date}
    ${arr}    Split String    ${date}    separator=-
    ${birthday}    Set Variable    ${arr[2]}${arr[1]}${arr[0]}
    [Return]    ${birthday}

Generate A Random Gender
    [Documentation]    This keyword is used for genarating a random gender, only return 'M' or 'F'
    ${gender}    Evaluate    random.choice(['M', 'F'])    random
    [Return]    ${gender}

Generate A Random Natural ID Code
    [Documentation]    This keyword is used for genarating a random natural ID , actually it will return an unique email.
    [Arguments]    ${p_name}
    ${email_domain}    Free Email Domain
    ${p_name}    Replace String    ${p_name}    ${SPACE}    .
    ${epoch_time}    Evaluate    int(time.time())    time
    ${email}    Set Variable    ${p_name}_${epoch_time}@${email_domain}
    [Return]    ${email}

Generate A Random Salary
    [Documentation]    This keyword is used for genarating a random salary, salary will in range 3,000 (USD) to 30,000 (USD)
    ${salary}    Evaluate    random.randint(3000,30000)    random
    [Return]    ${salary}

Generate List Random Person
    [Arguments]    ${p_number_of_person}
    ${list_person}=    Generate Random List Working Class Hero    ${p_number_of_person}
    [Return]    ${list_person}

Generate A Tax Base On Salary
    [Documentation]    This keyword is used for genarating a tax based on the salary provide as paramter
    ...    if salary <4,000 then tax percent is 0% of salary, mean they dont have to pay tax
    ...    if 4,000 <= salary <10,000 then tax percent is 10% of salary
    ...    if 10,000 <= salary <20,000 then tax percent is 20% of salary
    ...    rest, if salary ablove 20,000 then tax percent is 30% of salary
    ...    first we will count tax percent base on the salary then , we will count the tax amount and round to integer and return.
    [Arguments]    ${p_salary}
    ${tax_percent}=    Set Variable    0
    IF    ${p_salary} < 4000
        ${tax_percent}=    Set Variable    0
    ELSE IF    ${p_salary} >= 4000 and ${p_salary} < 10000
        ${tax_percent}=    Set Variable    10
    ELSE IF    ${p_salary} >= 10000 and ${p_salary} < 20000
        ${tax_percent}=    Set Variable    20
    ELSE
        ${tax_percent}=    Set Variable    30
    END
    ${tax_amount}    Evaluate    ${tax_percent} * ${p_salary} / 100
    ${tax_amount}    Convert To Integer    ${tax_amount}
    [Return]    ${tax_amount}

Get Response Status And Body
    [Arguments]    ${p_response_api}
    ${code}=    Set Variable    ${p_response_api.status_code}
    ${content}=    Set Variable    ${p_response_api.content}
    [Return]    ${code}    ${content}

Assert Response Status Is Correct
    [Arguments]    ${p_expected_status}    ${p_actual_status}
    Should Be True    '${p_expected_status}'=='${p_actual_status}'    msg=Status code return is not correct! Expected '${p_expected_status}' but Actual: '${p_actual_status}'

Assert Response Content Is Correct
    [Arguments]    ${p_expected_content}    ${p_actual_content}
    Should Be True    '${p_expected_content}'=='${p_actual_content}'    msg=Response return is not correct! Expected '${p_expected_content}' but Actual: '${p_actual_content}'

Open Browser And Go To Application
    [Arguments]    ${p_url}
    #New Page    ${p_url}
    open browser    ${p_url}    browser=${BROWSER}    headless=${HEADLESS}

Get Text Of Element
    [Arguments]    ${p_element}
    ${text}    Get Text    ${p_element}
    [Return]    ${text}

Assert Response Error
    [Arguments]    ${p_response}
    ${list}=    Convert To List    ${p_response}
    Should Be True    '${list}[0]'=='FAIL'
    should start with    ${list}[1]    HTTPError: 500 Server Error: