*** Settings ***
Documentation      This file contains the keywords related to database steps definitions.

Library            RequestsLibrary
Resource           ../../resources/env/${env}/UriRequest.robot


*** Keywords ***
Make POST Request To Clear Database
    [Documentation]    This keyword is used for sending a POST request to clear database
    Create Session    session    ${BASE_URL}
    ${headers}=    Create Dictionary    accept=*/*    Content-Type=application/json
    ${response}=    POST On Session    session    ${URI_RAKE_DB}    headers=${headers}
    [Return]    ${response}
