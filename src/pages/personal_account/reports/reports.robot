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
  Sleep  1


Прибрати звіт з обраних
  ${count}  Отримати кількість звітів
  Run Keyword If  ${count} > 0  Click Element  ${report}//*[@class="fa fa-star"]
  Sleep  .5
  ${count}  Отримати кількість звітів
  [Return]  ${count}


Отримати кількість звітів
  ${count}  Get Element Count  ${report}
  [Return]  ${count}


Перевірити наявність звіту за назвою
  [Arguments]  ${report name}
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${report}/../a[not(@class)]//*[@title='${report name}']
  [Return]  ${status}


Додати звіт в обрані за номером
  [Arguments]  ${num}
  Click Element  (${report})[${num}]
  Sleep  .5


Отримати назву звіту за номером
  [Arguments]  ${num}
  ${report name}  Get Text  (${report})[${num}]/following-sibling::*//*[@title]
  [Return]  ${report name}