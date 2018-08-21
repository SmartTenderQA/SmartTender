*** Settings ***
Resource  ../../src/src.robot
Test Teardown  Test Postcondition
Suite Setup  Suite Precondition
Suite Teardown  Suite Postcondition


*** Variables ***
${start_page}  http://smarttender.biz
${content}  Приймаю умови Договору приєднання про надання інформаційних послуг під час проведення процедур публічних закупівель PROZORRO та закупівель «Rialto» № SO-2015-003


*** Test Cases ***
Перевірити після авторизації
  Закрити вікно LLC


Перевірити особистій кабінет
  Go To  https://smarttender.biz/invoicepage/purchase/
  Закрити вікно LLC2


Перевірити подачу пропозиції
  Відкрити сторінку тестових торгів
  Розгорнути розширений пошук
  Відфільтрувати по статусу торгів  Прийом пропозицій
  Виконати пошук тендера
  Перейти по результату пошуку  ${first found element}
  Select Frame  css=iFrame
  Перевірити кнопку подачі пропозиції
  Закрити вікно LLC2


*** Keywords ***
Suite Precondition
  Start
  Login  ${login}  ${password}


Закрити вікно LLC
  Wait Until Page Contains Element  //*[@id="ui-id-2" and .="Заміна оператора"]
  Click Element   css=[title=close]
  Wait Until Element Is Not Visible  css=[title=close]


Закрити вікно LLC2
  Wait Until Page Contains Element  //*[.="Заміна оператора"]
  Wait Until Page Contains Element  //*[contains(text(),"${content}")]
  Click Element   (//*[contains(@class, "close-empty")])[last()]
  Wait Until Page Does Not Contain  (//*[contains(@class, "close-empty")])[last()]  15
  Location Should Be  https://smarttender.biz/
