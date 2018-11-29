*** Settings ***
Resource    	keywords.robot


*** Variables ***
${report}               //*[@class="ivu-card-body"]//*[@class="favoriteStar"]


*** Keywords ***
Перевірити сторінку
  Location Should Contain  /Reports
  Element Should Contain  //h1  Звіти


Встановити фільтр Тільки обрані звіти
  [Arguments]  ${action}
  ${status}  Отримати статус перемикача Тільки обрані звіти
  Run Keyword If  "${status}" == "false" and "${action}" == "увімкнути"
  ...  Click Element  ${switcher}
  Run Keyword If  "${status}" == "true" and "${action}" == "вимкнути"
  ...  Click Element  ${switcher}
  Sleep  2


Прибрати усі звіти з обраних
  :FOR  ${i}  IN RANGE  999999
    \  ${status}  Прибрати звіт з обраних
    \  Exit For Loop If    ${status} == ${False}


Отримати кількість звітів
  ${count}  Get Element Count  ${report}
  [Return]  ${count}


Вибрати випадковий звіт
  ${count}  Get Element Count  ${report}
  ${n}  random_number  1  ${count}
  [Return]  ${n}