*** Keywords ***
Відповісти організатором на запитання
    [Arguments]  ${title}
    Вибрати запитання за назвою  ${title}
    actions.Натиснути кнопку Змінити (F4)
    ${answer}  Create sentence  8
    Внести текст відповіді  ${answer}
    Поставити чекбокс "Зафіксувати відповідь"
    #${name}  ${hash}  Додати файл до відповіді на запитання
    actions.Натиснути кнопку "Зберегти"
    validation.Закрити валідаційне вікно (Так/Ні)  Надіслати відповідь на сервер ProZorro?  Так
    validation.Ignore updateConflict Error
    [Return]  ${answer}  #${name}  ${hash}












########################################################
###################    KEYWORDS    #####################
########################################################
Вибрати запитання за назвою
    [Arguments]  ${title}
    ${question row}  Set Variable  //td[.="${title}"]
    Click Element  ${question row}
    Wait Until Page Contains Element  ${question row}\[@class="cellselected"]  2


Внести текст відповіді
    [Arguments]  ${text}
    ${answer input}  Set Variable  //*[@data-name="ANSWER"]//textarea
    Input Text  ${answer input}  ${text}


Поставити чекбокс "Зафіксувати відповідь"
    ${check}  Set Variable  (//*[.="Зафіксувати відповідь"]/preceding-sibling::td//span)[1]
    Click Element  ${check}
    Wait Until Page Contains Element  ${check}\[contains(@class, "Checked")]


Додати файл до відповіді на запитання
    Click Element  //*[@data-name="ATTACHMENTBTN"]
    Дочекатись закінчення загрузки сторінки(webclient)
    ${name}  ${hash}  actions.Додати doc файл
    Click Element  xpath=(//span[.='ОК'])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    ${get}  Get Element Attribute  //*[@data-name="ATTACHMENT"]//input  value
    Should Be Equal  ${get}  ${name}
    [Return]  ${name}  ${hash}