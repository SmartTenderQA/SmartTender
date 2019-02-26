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
    Run Keyword If  """LoadingPanel""" in """${locator}"""
    ...  Wait Until Element Is Not Visible
    ...  //*[@id="adorner"]
    ...  30


Дочекатись закінчення загрузки сторінки по елементу_new
	[Arguments]  ${locator}
    ${status}  ${message}  Run Keyword And Ignore Error
    ...  Wait Until Element Is Visible
    ...  ${locator}
    ...  3
    Run Keyword If  "${status}" == "PASS"
    ...  Wait Until Page Does Not Contain Element
    ...  ${locator}
    ...  120
