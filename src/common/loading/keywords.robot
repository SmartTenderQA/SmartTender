*** Keywords ***
Дочекатись закінчення загрузки сторінки по елементу
  [Arguments]  ${locator}
  ${status}  ${message}  Run Keyword And Ignore Error
  ...  Wait Until Element Is Visible
  ...  ${locator}
  ...  3
  Run Keyword If  "${status}" == "PASS"
  ...  Run Keyword And Ignore Error
  ...  Wait Until Element Is Not Visible
  ...  ${locator}
  ...  120
  Run Keyword If  "${status}" == "PASS"
  ...  Дочекатись закінчення загрузки сторінки по елементу
  ...  ${locator}