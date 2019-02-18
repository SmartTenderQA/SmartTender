*** Keywords ***
Активувати вкладку "Запитання"
    ${question tab}  Set Variable  //*[@data-qa="tabs"]//*[text()="Запитання"]
    Wait Until Keyword Succeeds  10  2  Click Element  ${question tab}
    loading.Дочекатись закінчення загрузки сторінки
    ${status}  Run Keyword And Return Status
    ...  Element Should Be Visible  ${question tab}/ancestor::div[contains(@class,"tab-active")]
    Run Keyword If  '${status}' == 'False'  Click Element  ${question tab}


Натиснути кнопку "Поставити запитання"
    ${question button}    Set Variable  //*[@data-qa="questions"]//button[contains(@class,"question-button")]
    ${question send btn}  Set Variable  //*[@data-qa="questions"]//button[contains(@class,"btn-success")]
    Scroll Page To Element XPATH   ${question button}
    Click Element                  ${question button}
    Wait Until Element Is Visible  ${question send btn}


Заповнити тему запитання
    [Arguments]  ${text}
    ${question theme}  Set Variable  //*[@data-qa="questions"]//label[text()="Тема"]/following-sibling::div//input
    elements.Дочекатися відображення елемента на сторінці  ${question theme}
    Input Text  ${question theme}  ${text}
    Sleep  .5
    ${get}  Get Element Attribute  ${question theme}  value
    Should Be Equal  ${get}  ${text}


Заповнити текст запитання
    [Arguments]  ${text}
    ${question text}  Set Variable  //*[@data-qa="questions"]//label[text()="Запитання"]/following-sibling::div//textarea
    Input Text  ${question text}  ${text}
    Sleep  .5
    ${get}  Get Element Attribute  ${question text}  value
    Should Be Equal  ${get}  ${text}


Натиснути кнопку "Подати" запитання
    ${question send btn}  Set Variable  //*[@data-qa="questions"]//button[contains(@class,"btn-success")]
    Click Element  ${question send btn}
    Run Keyword And Ignore Error  Wait Until Element Is Not Visible  ${question send btn}  30


Порахувати кількісь запитань на сторінці
    ${question title}  Set Variable  //*[@data-qa="questions"]//*[@class="bold break-word"]
    ${count}  Get Element Count  ${question title}
    [Return]  ${count}


Залишити відгук на відповідь замовника
    [Arguments]  ${title}  ${comment}
    Натиснути кнопку "Залишити відгук" на запитанні  ${title}
    Оцінити відповідь замовника
    Внести текст коментаря  ${comment}
    Відправити відгук




########################################################
###################    KEYWORDS    #####################
########################################################
Натиснути кнопку "Залишити відгук" на запитанні
    [Arguments]  ${title}
    ${comment btn}  Set Variable
    ...  //*[@class="bold break-word"][text()="${title}"]/ancestor::div[2]//span[contains(.,"Залишити відгук")]
    Wait Until Element Is Visible  ${comment btn}
    Click Element  ${comment btn}
    Wait Until Element Is Visible  //*[text()="Ваш коментар"]


Оцінити відповідь замовника
    ${radio}  Set Variable  //*[@class="radio-inline"]/input[@type="radio"]
    ${count}  Get Element Count  ${radio}
    ${count}  Evaluate  int(${count}+1)
    ${n}  random number  1  ${count}
    Click Element  (${radio})[${n}]


Внести текст коментаря
    [Arguments]  ${text}
    ${input}  Set Variable  //textarea[contains(@name,"Comment")]
    Input Text  ${input}  ${text}


Відправити відгук
    ${submit btn}  Set Variable  //*[@type="submit"]
    Click Element  ${submit btn}
    loading.Дочекатись закінчення загрузки сторінки
    Element Should Not Be Visible  ${submit btn}
