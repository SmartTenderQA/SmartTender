*** Keywords ***
Надати рішення про допуск до аукціону учасника
    [Arguments]  ${i}
    ${selector}  Set Variable  (${participant})[${i}]
    Wait Until Keyword Succeeds  20  2  Click Element  ${selector}
    Wait Until Keyword Succeeds  10  2  Натиснути кнопку Просмотр (F4)
    Page Should Contain  Відіслати рішення
    Натиснути елемент у якого title  Допустити учасника до аукціону
    Відмітити чек-бокс у рішенні
    actions.Натиснути OkButton
    validation.Закрити валідаційне вікно (Так/Ні)  Ви впевнені у своєму рішенні?  Так
    validation.Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на кваліфікацію?  Ні


Вказати ціну за одиницю номенклатури для переможця
    [Arguments]  ${i}
    ${selector}  Set Variable  (${winners})[${i}]
    Wait Until Keyword Succeeds  20  2  Click Element  ${selector}
    Натиснути кнопку "Заповнити ціни за одиницю товару"
    Запонити поле з ціною відповідно до пропозиції


Запонити поле з ціною відповідно до пропозиції
    ${price field}  Set Variable  xpath=//div[@id="pcModalMode_PW-1"]//tr[contains(@class,"Row")]//td[count(//*[@title="Ціна"]/ancestor::td[1]/preceding-sibling::td)+1]
    ${price}  Визначити ціну за одиницю номенклатури
    Click Element  ${price field}
    Sleep  .5
    Click Element  ${price field}
    Sleep  .5
    Input Text  ${price field}//input  ${price}
    Sleep  .5
    actions.Натиснути OkButton


Визначити ціну за одиницю номенклатури
    ${quantity selector}  Set Variable  xpath=//div[@id="pcModalMode_PW-1"]//tr[contains(@class,"Row")]//td[count(//*[@title="Кількість"]/ancestor::td[1]/preceding-sibling::td)+1]
    ${quantity}  Get Text  ${quantity selector}
    ${proposal price selector}  Set Variable  //div[@id="pcModalMode_PW-1"]//span[contains(text(),"Сума пропозиції")]
    ${price}  Get Text  ${proposal price selector}
    ${price}  Evaluate  re.search(r'\\D+:\\s(?P<price>\\d.+)', '${price}').group('price')  re
    ${price}  Evaluate  '${price}'.replace(" ", "")
    ${price}  Evaluate  str(int(${price} / ${quantity}) * 0.9)
    [Return]  ${price}


Натиснути "Визначити переможцем"
    ${selector}  Set Variable  xpath=//span[text()="Визначити переможцем"]
    Wait Until Keyword Succeeds  10  1  Click Element  ${selector}
    Wait Until Page Contains Element  ${selector}/ancestor::div[contains(@style, "user-select")]


Натиснути "Відхилити пропозицію"
    ${selector}  Set Variable  xpath=//span[text()="Відхилити пропозицію"]
    Wait Until Keyword Succeeds  10  1  Click Element  ${selector}
    Wait Until Page Contains Element  ${selector}/ancestor::div[contains(@style, "user-select")]


Натиснути елемент у якого title
    [Arguments]  ${title}
    Click Element  //div[@title="${title}"]
    Дочекатись закінчення загрузки сторінки(webclient)


Відмітити чек-бокс у рішенні
    ${checkbox}  Set Variable  //*[@data-type="CheckBox"]//td/span
    ${status}  Run Keyword And Return Status  Wait Until Element Is Visible  (${checkbox})[1]  10
    Run Keyword If  ${status}  Run Keywords
    ...  Sleep  .5                        AND
    ...  Click Element  (${checkbox})[1]  AND
    ...  Sleep  .5                        AND
    ...  Click Element  (${checkbox})[2]  AND
    ...  Sleep  .5


Заповнити текст рішення кваліфікації
    ${textarea}  Set Variable  //*[@class="dxpnlControl_DevEx"]//textarea
    ${text}  create sentence  5
    Input Text  ${textarea}  ${text}


Додати файл до рішення кваліфікації
    ${add button}  Set Variable  //span[contains(text(), "Перегляд")]
    Click Element  ${add button}
    Дочекатись закінчення загрузки сторінки(webclient)
    ${name}  ${hash}  Додати doc файл
    Click Element  xpath=(//span[.='ОК'])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    Page Should Contain  ${name}
    [Return]  ${name}  ${hash}


Відмітити підставу відхилення
    [Arguments]  ${text}
    ${check}  Set Variable  //td[text()="${text}"]/preceding-sibling::td/img
    Wait Until Element Is Visible  ${check}
    Click Element  ${check}
    Wait Until Page Contains Element  ${check}[contains(@src,"BoxChecked")]


Вибрати переможця за номером
    [Arguments]  ${i}
    ${selector}  Set Variable  (${winners})[${i}]
    Wait Until Element Is Visible  ${selector}  3
    Wait Until Keyword Succeeds  20  2  Click Element  ${selector}


Заповнити номер договору
    ${selector}  Set Variable  //*[text()="Номер договору"]/following-sibling::table[1]//input
    ${n}  random_number  1000  10000
    Input Text  ${selector}  ${n}


Заповнити "Дата підписання" договору
    ${selector}  Set Variable  //*[text()="Дата підписання"]/following-sibling::table[1]//input
    ${date}  get_time_now_with_deviation  40  minutes
    Input Text  ${selector}  ${date}


Вкласти договірній документ
    ${add button}  Set Variable  //span[contains(text(), "Обзор")]|//span[contains(text(), "Перегляд")]
    Click Element  ${add button}
    Дочекатись закінчення загрузки сторінки(webclient)
    ${name}  ${hash}  actions.Додати doc файл
    Click Element  xpath=(//span[.='ОК'])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    Page Should Contain  ${name}
    [Return]  ${name}  ${hash}