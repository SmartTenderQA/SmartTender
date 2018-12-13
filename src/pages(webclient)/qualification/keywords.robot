*** Keywords ***
Надати рішення про допуск до аукціону учасника
    [Arguments]  ${i}
    ${selector}  Set Variable  (${participant})[${i}]
    Click Element  ${selector}
    Wait Until Keyword Succeeds  10  2  Натиснути кнопку Просмотр (F4)
    Page Should Contain  Відіслати рішення
    Натиснути елемент у якого title  Допустити учасника до аукціону
    Відмітити чек-бокс у рішенні
    Натиснути OkButton
    Закрити валідаційне вікно (Так/Ні)  Ви впевнені у своєму рішенні?  Так
    Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на кваліфікацію?  Ні


Визначити учасника переможцем
    [Arguments]  ${i}
    ${selector}  Set Variable  (${winners})[${i}]
    Click Element  ${selector}
    Натиснути кнопку "Кваліфікація"
    Закрити валідаційне вікно  Увага! Натискання кнопки  ОК
    Натиснути "Визначити переможцем"
    Відмітити чек-бокс у рішенні
    Заповнити текст рішення кваліфікації
    Додати файл до рішення кваліфікації
    Натиснути OkButton
    Закрити валідаційне вікно (Так/Ні)  Ви впевнені у своєму рішенні?  Так
    Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на рішення по пропозиції?  Ні
    Закрити валідаційне вікно (Так/Ні)  На рішення не накладено актуальний підпис ЕЦП  Так



Натиснути "Визначити переможцем"
    ${selector}  Set Variable  xpath=//span[text()="Визначити переможцем"]
    Wait Until Keyword Succeeds  10  1  Click Element  ${selector}
    Wait Until Page Contains Element  ${selector}/ancestor::div[contains(@style, "user-select")]


Натиснути елемент у якого title
    [Arguments]  ${title}
    Click Element  //div[@title="${title}"]
    Дочекатись закінчення загрузки сторінки(webclient)


Відмітити чек-бокс у рішенні
    ${checkbox}  Set Variable  //*[@data-type="CheckBox"]//td/span
    Wait Until Element Is Visible  (${checkbox})[1]  10
    Sleep  .5
    Click Element  (${checkbox})[1]
    Sleep  .5
    Click Element  (${checkbox})[2]
    Sleep  .5


Заповнити текст рішення кваліфікації
    ${textarea}  Set Variable  //*[@class="dxpnlControl_DevEx"]//textarea
    ${text}  create sentence  5
    Input Text  ${textarea}  ${text}


Додати файл до рішення кваліфікації
    ${doc}=  create_fake_doc
    ${path}  Set Variable  ${doc[0]}
    ${name}  Set Variable  ${doc[1]}
    ${add button}  Set Variable  //span[contains(text(), "Перегляд")]
    Click Element  ${add button}
    Дочекатись закінчення загрузки сторінки(webclient)
    Wait Until Page Contains Element  xpath=//*[@type='file'][1]
    Choose File  xpath=//*[@type='file'][1]  ${path}
    Click Element  xpath=(//span[.='ОК'])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    Page Should Contain  ${name}


Підтвердити організатором формування протоколу розгляду пропозицій
    Вибрати перший тендер
    Натиснути кнопку Перечитать (Shift+F4)
    Натиснути надіслати вперед(Alt+Right)
    Закрити валідаційне вікно (Так/Ні)  протокол  Так

