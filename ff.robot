*** Settings ***
Library     Selenium2Library
Test Teardown  Provided postcondition

*** Test Cases ***
Test title
  Open Browser  https://github.com/  firefox

*** Keywords ***
Provided postcondition
    Close All Browsers