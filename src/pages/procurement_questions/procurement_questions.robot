*** Variables ***
${question tab}               //*[@data-qa="tabs"]//*[text()="Запитання"]
${question button}            //*[@data-qa="questions"]//button[contains(@class,"question-button")]
${question send btn}          //*[@data-qa="questions"]//button[contains(@class,"btn-success")]
${question theme}             //*[@data-qa="questions"]//label[text()="Тема"]/following-sibling::div//input
${question text}              //*[@data-qa="questions"]//label[text()="Запитання"]/following-sibling::div//textarea


*** Keywords ***
Активувати вкладку "Запитання"
    Click Element  ${question tab}
    ${status}  Run Keyword And Return Status
    ...  Element Should Be Visible  ${question tab}/ancestor::div[contains(@class,"tab-active")]
    Run Keyword If  '${status}' == 'False'  Click Element  ${question tab}


Натиснути кнопку "Поставити запитання"
    Click Element  ${question button}
    Wait Until Element Is Visible  ${question send btn}


Заповнити тему запитання
    [Arguments]  ${text}
    Input Text  ${question theme}  ${text}
    Sleep  .5
    ${get}  Get Element Attribute  ${question theme}  value
    Should Be Equal  ${get}  ${text}



Заповнити текст запитання
    [Arguments]  ${text}
    Input Text  ${question text}  ${text}
    Sleep  .5
    ${get}  Get Element Attribute  ${question text}  value
    Should Be Equal  ${get}  ${text}


Натиснути кнопку "Подати" запитання
    Click Element  ${question send btn}
    Wait Until Element Is Not Visible  ${question send btn}  30