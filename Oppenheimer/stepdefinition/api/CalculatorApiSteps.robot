*** Settings ***
Documentation      This file contains the keywords related to calculator steps definitions.

Library            RequestsLibrary
Library            JSONLibrary
Library            Collections
Resource           ../../resources/env/${env}/UriRequest.robot
Library            ../utils/custom_request.py


*** Keywords ***
Make POST Request To Insert A Person
    [Documentation]    This keyword is used for sending a POST request to create new person
    [Arguments]    ${p_birthday}    ${p_gender}    ${p_name}    ${p_natid}    ${p_salary}    ${p_tax}
    Create Session    session    ${BASE_URL}
    ${headers}=    Create Dictionary    accept=*/*    Content-Type=application/json
    ${json}=    Create Dictionary    birthday=${p_birthday}    gender=${p_gender}    name=${p_name}    natid=${p_natid}    salary=${p_salary}    tax=${p_tax}
    ${response}=    POST On Session    session    ${URI_CALCULATOR_INSERT}    headers=${headers}    json=${json}
    [Return]    ${response}

Make POST Request To Insert Multple Person
    [Documentation]    This keyword is used for sending a POST request to create multiple person
    [Arguments]    ${p_list_person}
    ${response}    Send Post Request To Insert Multiple Working Hero    ${BASE_URL}    ${URI_CALCULATOR_INSERT_MULTIPLE}    ${p_list_person}
    [Return]    ${response}

Make Post Request To Get Tax Relief
    [Documentation]    This keyword is used for sending a GET request to get all current tax relief
    Create Session    session    ${BASE_URL}
    ${headers}=    Create Dictionary    accept=*/*    Content-Type=application/json
    ${response}=    GET On Session    session    ${URI_TAX_RELIEF}    headers=${headers}
    [Return]    ${response}

Assert Insert Person To Database Successfully
    [Documentation]    This keyword is used for validating if sending post request to insert 1 or multiple person successfully via checking api chekcing
    [Arguments]    ${p_api_response_content_tax_relief}    ${p_list_expected_person}
    ${json}    Convert string to json    ${p_api_response_content_tax_relief}
    FOR    ${person}    IN    @{p_list_expected_person}
        ${expected_name}=    Set Variable    ${person.name}
        ${expected_natid}=    Set Variable    ${person.natid}
        FOR    ${item}    IN    @{json}
            ${actual_natid}=    Get Value From Json    ${item}    $.natid
            ${actual_name}=    Get Value From Json    ${item}    $.name
            ${exist}=    Set Variable if    '${actual_name}[0]'=='${expected_name}' and '${expected_natid}[0:4]'=='${actual_natid[0]}[0:4]'
            ...    True
            ...    False
            Exit For Loop IF    ${exist}==True
        END
        Should Be True    ${exist}==True    msg= Can not found this person in database name: ${person.name} and natid: ${person.natid}
    END

Assert Tax Relief Amount Computation Is Correct
    [Arguments]    ${p_response_content_relief}    ${p_list_person}
    ${json}    Convert string to json    ${p_response_content_relief}
    FOR    ${person}    IN    @{p_list_person}
        ${birthday}=    Set Variable    ${person.birthday}
        ${salary}=    Set Variable    ${person.salary}
        ${tax_pay}=     Set Variable    ${person.tax}
        ${gender}=    Set Variable    ${person.gender}
        ${natid}=    Set Variable    ${person.natid}
        ${expected_natid}=    Reformat Natid Field With Dolar    ${natid}
        ${expected_name}=    Set Variable    ${person.name}
        ${expected_tax_relief}=    Calculate Tax Relief    ${birthday}    ${salary}    ${tax_pay}    ${gender}
        FOR    ${item}   IN    @{json}
            ${actual_natid}=    Get Value From Json    ${item}    $.natid
            ${actual_name}=    Get Value From Json    ${item}    $.name
            ${actual_relief}=    Get Value From Json    ${item}    $.relief
            ${exist}=    Set Variable if    '${actual_name}[0]'=='${expected_name}' and '${expected_natid}'=='${actual_natid[0]}' and '${expected_tax_relief[:-3]}'=='${actual_relief}[0][:-3]'
            ...    True
            ...    False
            Exit For Loop IF    ${exist}==True
        END
        Should Be True    ${exist}==True
    END


Calculate Gender Bonus
    [Arguments]    ${p_gender}
    ${gender_bonus}=    Set Variable If    '${p_gender}'=='F'    500    0
    [Return]    ${gender_bonus}

Calculate Variable
    [Arguments]    ${p_age}
    IF    ${p_age} <= 18
        ${variable}=    Set Variable    1
    ELSE IF    ${p_age} > 18 and ${p_age} <= 35
        ${variable}=    Set Variable    0.8
    ELSE IF    ${p_age} > 35 and ${p_age} <= 50
        ${variable}=    Set Variable    0.5
    ELSE IF    ${p_age} > 50 and ${p_age} <= 75
        ${variable}=    Set Variable    0.367
    ELSE
        ${variable}=    Set Variable    0.05
    END
    [Return]    ${variable}

Calculate Age Of Person Base On BirthDay
    [Arguments]    ${p_birthday}
    ${year}=    Set Variable    ${p_birthday}[4:8]
    ${month}=    Set Variable    ${p_birthday}[2:4]
    ${day}=    Set Variable    ${p_birthday}[0:2]
    ${age}=    Get Age Base On Bithday    ${day}    ${month}    ${year}
    [Return]    ${age}

Calculate Tax Relief
    [Arguments]    ${p_bithday}    ${p_salary}    ${p_tax_paid}    ${p_gender}
    ${age}=    Calculate Age Of Person Base On BirthDay    ${p_bithday}
    ${variable}=     Calculate Variable    ${age}
    ${gender_bonus}=    Calculate Gender Bonus    ${p_gender}
    ${tax_relief}=    Calculate Tax Relief Base On Salary Tax Variable Gender Bonus    ${p_salary}    ${p_tax_paid}    ${variable}    ${gender_bonus}
    [Return]    ${tax_relief}

Assert Tax Relief Is Empty
    [Arguments]    ${p_response_content_relief}
    ${json}    Convert string to json    ${p_response_content_relief}
    ${len}    Get Length    ${json}
    Should Be True    ${len}==0
