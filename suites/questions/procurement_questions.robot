*** Settings ***
Resource  ../../src/src.robot

Suite Teardown  Close All Browsers
Test Setup      Stop The Whole Test Execution If Previous Test Failed
Test Teardown   Run Keyword If Test Failed  Run Keywords
...                                         Log Location  AND
...                                         Capture Page Screenshot


*** Test Cases ***




*** Keywords ***
