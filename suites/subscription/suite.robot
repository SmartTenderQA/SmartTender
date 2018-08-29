=*** Settings ***
Resource        ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot

*** Variables ***
${}     css=li.loginButton a


*** Test Cases ***
Залогінитися
  Login  user1
  debug

*** Keywords ***
Precondition
  Open Browser  ${start_page}  ${browser}

Postcondition
    Close All Browsers
