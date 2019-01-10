*** Variables ***
${question tab}               //*[@data-qa="tabs"]//*[text()="Запитання"]
${question button}            //*[@data-qa="questions"]//button[contains(@class,"question-button")]
${question send btn}          //*[@data-qa="questions"]//button[contains(@class,"btn-success")]

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




Заповнити текст запитання




Натиснути кнопку "Подати" запитання
    Click Element  ${question send btn}
    Wait Until Element Is Not Visible  ${question send btn}  30