*** Settings ***
Documentation     this is page object model for page "Dispense"
Library           Browser    timeout=30s


*** Keywords ***
Wait Until Page Dispense Load Complete
    [Documentation]    This keyword is used for waiting page load completed.
    wait for elements state    css=.container    visible

Get Page Source Of Dispense Page
    [Documentation]    This keyword is used for getting page source and return page source
    ${source}=    get page source
    [Return]    ${source}

Get Title Of Dispense Page
    [Documentation]    This keyword is used for getting page title and return page title.
    ${title}=    get title
    [Return]    ${title}