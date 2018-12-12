*** Settings ***
Resource    	keywords.robot


*** Variables ***
${opponent btn}             //*[@class='ivu-col ivu-col-span-sm-8']//button[@type='button']
${company name input}       //*[@class='ivu-input-wrapper ivu-input-type']//input


*** Keywords ***
Перевірити сторінку
  Page Should Contain  Аналітика участі


Відкрити вікно аналітика по конкурентам
  Click Element  ${opponent btn}
  Wait Until Element Is Visible  ${company name input}


Ввести назву компанії
  [Arguments]  ${company name}
  Input Text  ${company name input}  ${company name}
  Wait Until Page Contains Element  //tbody[@class='ivu-table-tbody']//tr  10


Вибрати конкурента з списка за номером
  [Arguments]  ${i}
  ${item}  Set Variable  //tbody[@class='ivu-table-tbody']//tr[${i}]//a
  Wait Until Page Contains Element  ${item}
  Wait Until Keyword Succeeds  20  5  Натиснути на елемент зі списка  ${item}


Натиснути на елемент зі списка
  [Arguments]  ${locator}
  Open button  ${locator}
  Дочекатись закінчення загрузки сторінки


Змінити період аукціону
  [Arguments]  ${period}
  Click Element  //*[contains(@class, 'calendar')]
  Click Element  //div[contains(text(), '${period}')]
  Дочекатись закінчення загрузки сторінки


Перевірити відображення діаграм
  ${result}  Set Variable  ${True}
  : FOR  ${i}  IN RANGE  1  7
  \  ${status}  Run Keyword And Return Status  Element Should Be Visible  ${diagram}[${i}]
  \  ${result}  Evaluate  ${result} and ${status}
  [Return]  ${True}


Перевірити відображення таблиці
  ${status}  Run Keyword And Return Status  Element Should Be Visible  //*[@class="ivu-table-header"]//tr
  [Return]  ${status}


Перевірити роботу кругової діаграми
  ${tenders_before}  Отримати кількість торгів
  Натиснути по діаграмі
  ${tenders_after}  Отримати кількість торгів
  Run Keyword if  ${tenders_before} < ${tenders_after}  Fail  Не працює кругова діаграма
