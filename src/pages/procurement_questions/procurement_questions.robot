*** Keywords ***
Активувати вкладку "Запитання"
    ${tab selector}  Set Variable  //*[@data-qa="tabs"]//*[text()="Запитання"]
    Click Element  ${tab selector}
    ${status}  Run Keyword And Return Status
    ...  Element Should Be Visible  ${tab selector}/ancestor::div[contains(@class,"tab-active")]
    Run Keyword If  '${status}' == 'False'  Click Element  ${tab selector}


Натиснути кнопку "Поставити запитання"
    ${selector}  Set Variable  //*[@data-qa="questions"]//button[contains(@class,"question-button")]
    Click Element  ${selector}
    Wait Until Element Is Not Visible  ${selector}


Заповнити тему запитання


Заповнити текст запитання


Натиснути кнопку "Подати" запитання
    ${selector}  Set Variable  //*[@data-qa="questions"]//button[contains(@class,"btn-success")]
    Click Element  ${selector}
    Wait Until Element Is Not Visible  ${selector}  30