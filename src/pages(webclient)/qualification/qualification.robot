*** Settings ***
Resource        qualification_keywords.robot


*** Variables ***
${participant}            //*[@data-placeid="CRITERIA"]//td//img[contains(@src,"textdocument")]
${winners}                //div[@id="MainSted2TabPage_1_cp" or @id="MainSted2TabPage_2_cp"]//td[@class="gridViewRowHeader"]/following-sibling::td[count(//div[@id="MainSted2TabPage_1_cp" or @id="MainSted2TabPage_2_cp"]//div[text()="Постачальник"]/ancestor::td[1]/preceding-sibling::*)][text()]



*** Keywords ***
Провести прекваліфікацію учасників
    ${count}  Дочекатись появи учасників прекваліфікації та отримати їх кількість
    :FOR  ${i}  IN RANGE  1  ${count}+1
    \  qualification_keywords.Надати рішення про допуск до аукціону учасника  ${i}
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Розгляд учасників закінчено?
    Run Keyword If  ${status}  validation.Закрити валідаційне вікно (Так/Ні)  Розгляд учасників закінчено?  Так
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Сформувати протокол розгляду пропозицій
    Run Keyword If  ${status}  validation.Закрити валідаційне вікно (Так/Ні)  Сформувати протокол розгляду пропозицій  Так
    Run Keyword And Ignore Error  Підтвердити організатором формування протоколу розгляду пропозицій


Дочекатись появи учасників прекваліфікації та отримати їх кількість
    actions.Натиснути кнопку Перечитать (Shift+F4)
    ${count}  Get Element Count  ${participant}
    Run Keyword If  '${count}' == '0'  Run Keywords
    ...  Capture Page Screenshot  AND
    ...  Sleep  30                AND
    ...  Дочекатись появи учасників прекваліфікації та отримати їх кількість
    [Return]  ${count}


Визнати всіх учасників переможцями
    actions.Натиснути кнопку Перечитать (Shift+F4)
    ${count}  Отримати кількість можливих переможців
    :FOR  ${i}  IN RANGE  1  ${count}+1
    \  Визначити учасника переможцем  ${i}  ${True}  #  ${True} включає накладання ЕЦП
    validation.Закрити валідаційне вікно (Так/Ні)  Розгляд учасників закінчено?  Так


Заповнити ціни за одиницю номенклатури для всіх переможців
    ${count}  Отримати кількість можливих переможців
    :FOR  ${i}  IN RANGE  1  ${count}+1
    \   qualification_keywords.Вказати ціну за одиницю номенклатури для переможця  ${i}


Отримати кількість можливих переможців
    actions.Натиснути кнопку Перечитать (Shift+F4)
    ${count}  Get Element Count  ${winners}
    Run Keyword If  '${count}' == '0'  Run Keywords
    ...  Capture Page Screenshot  AND
    ...  Sleep  30                AND
    ...  Отримати кількість можливих переможців
    [Return]  ${count}


Підтвердити організатором формування протоколу розгляду пропозицій
    main_page.Вибрати тендер за номером (webclient)  1
    actions.Натиснути кнопку Перечитать (Shift+F4)
    actions.Натиснути надіслати вперед(Alt+Right)
    validation.Закрити валідаційне вікно (Так/Ні)  Сформувати протокол розгляду пропозицій  Так


Визначити учасника переможцем
    [Arguments]  ${i}  ${EDS}=None  ${MethodType}=None
    ${selector}  Set Variable  (${winners})[${i}]
    Wait Until Keyword Succeeds  20  2  Click Element  ${selector}
    actions.Натиснути кнопку "Кваліфікація"
    Run Keyword And Ignore Error  validation.Закрити валідаційне вікно  Увага! Натискання кнопки  ОК
    qualification_keywords.Натиснути "Визначити переможцем"
    qualification_keywords.Заповнити текст рішення кваліфікації
    ${file name}  ${hash}  qualification_keywords.Додати файл до рішення кваліфікації
    Run Keyword If  'below' not in '${MethodType}'  qualification_keywords.Відмітити чек-бокс у рішенні
    actions.Натиснути OkButton
    validation.Закрити валідаційне вікно (Так/Ні)  Ви впевнені у своєму рішенні?  Так
    Run Keyword If  ('${EDS}' == 'True') and ('below' not in '${MethodType}')
    ...  Run Keywords
    ...  validation.Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на рішення по пропозиції?  Так  AND
    ...  EDS_webclient.Накласти ЕЦП (webclient)
    ...  ELSE
    ...  Run Keywords
    ...  validation.Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на рішення по пропозиції?  Ні  AND
    ...  validation.Закрити валідаційне вікно (Так/Ні)  На рішення не накладено актуальний підпис ЕЦП  Так
    [Return]  ${file name}  ${hash}


Відхилити пропозицію учасника
    [Arguments]  ${i}  ${EDS}=None  ${MethodType}=None
    ${selector}  Set Variable  (${winners})[${i}]
    Wait Until Keyword Succeeds  20  2  Click Element  ${selector}
    actions.Натиснути кнопку "Кваліфікація"
    Run Keyword And Ignore Error  validation.Закрити валідаційне вікно  Увага! Натискання кнопки  ОК
    qualification_keywords.Натиснути "Відхилити пропозицію"
    Run Keyword If  'below' not in '${MethodType}'  qualification_keywords.Відмітити підставу відхилення  Не відповідає кваліфікаційним критеріям
    qualification_keywords.Заповнити текст рішення кваліфікації
    ${file name}  ${hash}  qualification_keywords.Додати файл до рішення кваліфікації
    actions.Натиснути OkButton
    validation.Закрити валідаційне вікно (Так/Ні)  Ви впевнені у своєму рішенні?  Так
    Run Keyword If  ('${EDS}' == 'True') and ('below' not in '${MethodType}')
    ...  Run Keywords
    ...  validation.Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на рішення по пропозиції?  Так  AND
    ...  EDS_webclient.Накласти ЕЦП (webclient)
    ...  ELSE
    ...  Run Keywords
    ...  validation.Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на рішення по пропозиції?  Ні  AND
    ...  validation.Закрити валідаційне вікно (Так/Ні)  На рішення не накладено актуальний підпис ЕЦП  Так
    [Return]  ${file name}  ${hash}


Додати договір до переможця
    actions.Натиснути кнопку "Прикріпити договір"
    qualification_keywords.Заповнити номер договору
    ${dogovir name}  ${hash}  qualification_keywords.Вкласти договірній документ
    actions.Натиснути OkButton
    validation.Підтвердити повідомлення про перевірку публікації документу за необхідністю
    [Return]  ${dogovir name}  ${hash}


Підписати договір з переможцем
    [Arguments]  ${i}
    qualification_keywords.Вибрати переможця за номером  ${i}
    actions.Натиснути кнопку "Підписати договір"
    validation.Закрити валідаційне вікно (Так/Ні)  Ви дійсно хочете підписати договір?  Так
    ${answer}  Set Variable If  "${where}" == "test"  Так  Ні
    validation.Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на договір?  ${answer}
    EDS_webclient.Накласти ЕЦП (webclient)
    #validation.Закрити валідаційне вікно (Так/Ні)  На рішення не накладено актуальний підпис ЕЦП  Так
    Wait Until Page Contains  Договір підписаний    60
    Wait Until Keyword Succeeds  10  2  Click Element  //*[@id="IMMessageBoxBtnOK_CD"]//span[text()="ОК"]