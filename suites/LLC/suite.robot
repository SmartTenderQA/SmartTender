*** Settings ***
Resource  ../../src/src.robot
Test Teardown  Run Keyword If Test Failed  Capture Page Screenshot
Suite Setup  Додати першого користувача  LLC
Suite Teardown  Close All Browsers


*** Variables ***
${content}  Приймаю умови Договору приєднання про надання інформаційних послуг під час проведення процедур публічних закупівель PROZORRO та закупівель «Rialto» № SO-2015-003


*** Test Cases ***
Перевірити після авторизації
  Закрити вікно LLC


Перевірити особистій кабінет
  Go To  https://smarttender.biz/invoicepage/purchase/
  Закрити вікно LLC2


Перевірити подачу пропозиції
  Відкрити сторінку тестових торгів
  old_search.Розгорнути розширений пошук
  Відфільтрувати по статусу торгів  Прийом пропозицій
  ${date}  smart_get_time  1  d
  Відфільтрувати по даті кінця прийому пропозиції від  ${date}
  Виконати пошук тендера
  Перейти по результату пошуку  ${first found element}
  Перевірити кнопку подачі пропозиції
  Закрити вікно LLC2


*** Keywords ***
Закрити вікно LLC
  Wait Until Page Contains Element  //*[@id="ui-id-2" and .="Заміна оператора"]  20
  Click Element   css=[title=close]
  Wait Until Element Is Not Visible  css=[title=close]


Закрити вікно LLC2
  ${status}  Run Keyword And Return Status  Click Element  //*[contains(@class, "modal-dialog")]//h4[contains(text(), "Прийом пропозицій") and contains(text(), " завершений!")]
  Run Keyword If  "${status}" == "False"  Run Keywords
  ...  Wait Until Page Contains Element  //*[.="Заміна оператора"]
  ...  AND  Wait Until Page Contains Element  //*[contains(text(),"${content}")]
  ...  AND  Click Element   (//*[contains(@class, "ivu-modal-close")])[last()]
  ...  AND  Wait Until Page Does Not Contain  (//*[contains(@class, "ivu-modal-close")])[last()]  15
  ...  AND  Location Should Be  https://smarttender.biz/
