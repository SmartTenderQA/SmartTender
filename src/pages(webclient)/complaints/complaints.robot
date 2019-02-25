*** Keywords ***
Відповісти організатором на вимогу
    [Arguments]  ${title}  ${type}
    Вибрати вимогу за назвою  ${title}
    actions.Натиснути кнопку Змінити (F4)
    Вказати тип рішення вимоги  ${type}
    ${resolution}  Create sentence  8
    Внести текст рішення на вимогу  ${resolution}
    ${name}  ${hash}  Додати файл до відповіді на вимогу
    actions.Натиснути кнопку "Зберегти"
    validation.Закрити валідаційне вікно (Так/Ні)  Надіслати відповідь  Так
    validation.Ignore updateConflict Error
    [Return]  ${resolution}  ${type}  ${name}  ${hash}




########################################################
###################    KEYWORDS    #####################
########################################################
Вибрати вимогу за назвою
    [Arguments]  ${title}
    ${question row}  Set Variable  //td[.="${title}"]
    Click Element  ${question row}
    Wait Until Page Contains Element  ${question row}\[@class="cellselected"]  2


Внести текст рішення на вимогу
    [Arguments]  ${text}
    ${resolution input}  Set Variable  //*[@data-name="RESOLUTION"]//textarea
    Input Text  ${resolution input}  ${text}


Додати файл до відповіді на вимогу
    Click Element  //*[@data-name="BTADD_ATTACHMENT_ORGANIZER"]
    Дочекатись закінчення загрузки сторінки(webclient)
    ${name}  ${hash}  actions.Додати doc файл
    Click Element  xpath=(//span[.='ОК'])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    elements.Дочекатися відображення елемента на сторінці  //div[@data-key]//*[contains(text(),"${name}")]
    [Return]  ${name}  ${hash}


Вказати тип рішення вимоги
    [Arguments]  ${solution}
    ${input}  Set Variable  //*[@data-name="RESOLUTYPE"]//input[@class]
    elements.Дочекатися відображення елемента на сторінці  ${input}
    Click Element  ${input}
    Wait Until Keyword Succeeds  5  .5
    ...  Click Element  //td[contains(@class,"ListBoxItem")][.="${solution}"]
    ${get}  Get Element Attribute  ${input}  value
    Should Be Equal  ${get}  ${solution}  Не вибрано тип рішення
