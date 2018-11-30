*** Keywords ***
Надати рішення про допуск до аукціону учасника
    [Arguments]  ${i}
    ${selector}  Set Variable  (${participant})[${i}]
    Click Element  ${selector}
    Wait Until Keyword Succeeds  10  2  Натиснути кнопку Просмотр (F4)
    Page Should Contain  Відіслати рішення
    Натиснути елемент у якого title  Допустити учасника до аукціону
    Відмітити чек-бокс у рішенні
    Натиснути елемент у якого title  Відіслати рішення
    Закрити валідаційне вікно (Так/Ні)  Ви впевнені у своєму рішенні?  Так
    Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на тендер?  Ні


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


Підтвердити організатором формування протоколу розгляду пропозицій
    Вибрати перший тендер
    Натиснути кнопку Перечитать (Shift+F4)
    Натиснути надіслати вперед(Alt+Right)
    Закрити валідаційне вікно (Так/Ні)  Сформувати протокол розгляду пропозицій?  Так

