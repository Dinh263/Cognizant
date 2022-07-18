*** Settings ***
Documentation    Suite description
Library          String
Library          ../utils/hero_utils.py
Library          OperatingSystem
Library          Browser    timeout=30s
Resource         ../../pages/IndexPage.robot
Resource         ../../pages/DispensePage.robot


*** Keywords ***
Get Location Of Test Data CSV
    ${current_dir}    Set Variable    ${CURDIR}
    ${index}    Get Index Of String    ${current_dir}    stepdefinition
    ${sub_str}    Get substring    ${current_dir}    0    ${index}
    ${test_data_location}    Join Path    ${sub_str}    resources    testdata    importcsv
    [Return]    ${test_data_location}

Delete Existing CSV File
    [Arguments]    ${p_location}
    Remove File    ${p_location}/*.csv

Generate Data To CSV File
    [Arguments]    ${p_location}    ${p_file_name}    ${p_list_person}
    Write Data To CSV File    ${p_location}    ${p_file_name}    ${p_list_person}

Upload CSV File
    [Arguments]    ${p_csv_file}
    #Click Btn Browser
    Select CSV File To Upload    ${p_csv_file}

Assert BackGround Color Of Button Dispense Is Correct
    [Arguments]    ${p_expected_color}
    ${actual_color}=    Get BackGround Color Of Disepense Now Button
    Should Be True    '${actual_color}'=='${p_expected_color}'    msg=back ground color is not correct. Expected '${p_expected_color}' But actual '${actual_color}'

Assert The Text Of Button Dispense Is Correct
    [Arguments]    ${p_expected_text}
    ${actual_text}=    Get Text Of Dispense Now Button
    Should Be True    '${actual_text}'=='${p_expected_text}'    msg=Text of button dispense is not correct. Expected: '${actual_text}' but actual '${p_expected_text}'

Dispense Tax Relieve
    Click Button Dispense Now

Assert Dispense Successfully
    ${title}=    Get Title Of Dispense Page
    ${source}=    Get Page Source Of Dispense Page
    Should Be True    '${title}'=='Dispense!!'    msg=Page title is not correct. Expected 'Dispense!!' but actual '${title}'
    ${exist}    Evaluate    """Cash dispensed""" in """${source}"""
    Should Be True    ${exist}==True    msg=Page did not contain Cash dispensed!


