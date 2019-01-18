*** Keywords ***
Активувати вкладку "Вимоги/скарги на умови закупівлі"
    ${complaints tab}  Set Variable  //*[@data-qa="tabs"]//*[text()="Вимоги/скарги на умови закупівлі"]
    Click Element  ${complaints tab}
    loading.Дочекатись закінчення загрузки сторінки
    ${status}  Run Keyword And Return Status
    ...  Element Should Be Visible  ${complaints tab}/ancestor::div[contains(@class,"tab-active")]
    Run Keyword If  '${status}' == 'False'  Click Element  ${complaints tab}


Обрати у фільтрі предмет вимоги
    [Arguments]  ${text}
    ${filter}  Set Variable  //*[@data-qa="complaints"]//*[@data-qa="filter"]
    ${status}  Run Keyword And Return Status  Element Should Be Visible  ${filter}//input[@disabled="disabled"]
    Run Keyword If  ${status}  No Operation
    ...  ELSE
    ...  Click Element  ${filter}  AND
    ...  Wait Until Element Is Visible  ${filter}//li[@class][contains(text(),"${text}")]  AND
    ...  Click Element                  ${filter}//li[@class][contains(text(),"${text}")]


Порахувати кількісь вимог на сторінці
    ${complaint title}  Set Variable  //*[@data-qa="complaint"]//*[@data-qa="title"]//*[@class="break-word"]
    ${count}  Get Element Count  ${complaint title}
    [Return]  ${count}


Натиснути кнопку Подати вимогу "Замовнику"
    ${submit claim}  Set Variable  //*[@data-qa="submit-claim"]
    Scroll Page To Element XPATH       ${submit claim}
    Click Element                      ${submit claim}
    Wait Until Element Contains  //*[@data-qa="new-complaint"]//*[@class="ivu-card-head"]  Подання вимоги


Заповнити тему вимоги
    [Arguments]  ${text}
    ${complaint theme}  Set Variable  //*[@data-qa="new-complaint"]//label[text()="Тема"]/following-sibling::div//input
    Input Text  ${complaint theme}  ${text}
    Sleep  .5
    ${get}  Get Element Attribute  ${complaint theme}  value
    Should Be Equal  ${get}  ${text}


Заповнити текст вимоги
    [Arguments]  ${text}
    ${complaint text}  Set Variable  //*[@data-qa="new-complaint"]//label[text()="Опис"]/following-sibling::div//textarea
    Input Text  ${complaint text}  ${text}
    Sleep  .5
    ${get}  Get Element Attribute  ${complaint text}  value
    Should Be Equal  ${get}  ${text}


Натиснути кнопку "Подати" вимогу
    ${complaint send btn}  Set Variable  //*[@data-qa="add-complaint"]
    Click Element  ${complaint send btn}
    Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${complaint send btn}  30


Розгорнути всі експандери вимог
    ${selector down}  Set Variable  //*[@data-qa="complaint"]//*[@data-qa="expander"]/i[contains(@class,"down")]
    ${count}  Get Element Count  ${selector down}
    Run Keyword If  ${count} != 0  Run Keywords
    ...  Repeat Keyword  ${count} times  Click Element  ${selector down}  AND
    ...  Розгорнути всі експандери