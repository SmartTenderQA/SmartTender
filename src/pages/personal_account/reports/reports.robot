*** Settings ***
Resource    	keywords.robot


*** Variables ***


*** Keywords ***
Перевірити сторінку
  Location Should Contain  /Reports
  Element Should Contain  //h1  Звіти


Встановити фільтр Тільки обрані звіти
  [Arguments]  ${action}
  Встановити перемикач Тільки обрані звіти  ${action}


Перевірити наявність звітів
  Page Should Contain Element  css=.ivu-card-body .favoriteStar


Прибрати усі звіти з обраних
  :FOR  ${i}  IN RANGE  999999
    \  ${status}  Прибрати звіт з обраних
    \  Exit For Loop If    ${status} == ${False}


Додати в обрані випадковій звіт та повернути назву
  ${report}  Вибрати випадковий звіт
  Додати звіт в обрані  ${report}
  ${report name}  Отримати назву звіту за номером  ${report}
  [Return]  ${report name}


Перевірити наявність звіту
  [Arguments]  ${name}
  ${report name}  Отримати назву звіту за номером  1
  Should Be Equal  ${report name}  ${name}