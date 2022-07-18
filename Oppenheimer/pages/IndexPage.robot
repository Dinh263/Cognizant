*** Settings ***
Documentation     this is page object model for page "Index"
Library           Browser    timeout=30s
Library           Collections
Library           JSONLibrary


*** Keywords ***
Get File Upload Textbox
    [Documentation]    This keyword is used for getting the element upload file
    ${txt_input_file}=    Set Variable    css=input[type=file]
    Wait For Elements State    ${txt_input_file}    visible
    [Return]    ${txt_input_file}

Get Btn Dispense Now
    [Documentation]    This keyword is used for getting the element button dispense
    ${btn_dispense}=    Set Variable    css=a[href=dispense]
    Wait For Elements State    ${btn_dispense}    visible
    [Return]    ${btn_dispense}

Select CSV File To Upload
    [Documentation]    This keyword is used for upload file csv. Argument is the file csv (file name with path)
    [Arguments]    ${p_csv_file}
    ${element}=    Get File Upload Textbox
    Upload File By Selector    ${element}    ${p_csv_file}

Get BackGround Color Of Disepense Now Button
    [Documentation]    This keyword is used getting background color of "Dispense Now" button.
    ${btn_dispense_now}=    Get Btn Dispense Now
    ${style}=    Get Style    ${btn_dispense_now}
    ${dict}=    Convert to Dictionary    ${style}
    ${bgColor}=    Get From Dictionary    ${dict}    background-color
    [Return]    ${bgColor}

Get Text Of Dispense Now Button
    [Documentation]    This keyword is used getting text of the button "Dispense Now" and return its text.
    ${btn_dispense_now}=    Get Btn Dispense Now
    ${text}=    Get Text    ${btn_dispense_now}
    [Return]    ${text}

Click Button Dispense Now
    [Documentation]    This keyword is used clicking the button "Dispense Now"
    ${btn_dispense_now}=    Get Btn Dispense Now
    Click    ${btn_dispense_now}
