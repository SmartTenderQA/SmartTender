*** Variables ***
${switcher}             css=.ivu-switch
${report}               //*[@class="ivu-card-body"]//*[@class="favoriteStar"]


*** Keywords ***
Встановити перемикач Тільки обрані звіти
  [Arguments]  ${action}
  ${status}  Отримати статус перемикача Тільки обрані звіти
  Run Keyword If  "${status}" == "false" and "${action}" == "увімкнути"
  ...  Click Element  ${switcher}
  Run Keyword If  "${status}" == "true" and "${action}" == "вимкнути"
  ...  Click Element  ${switcher}
  Sleep  3


Отримати статус перемикача Тільки обрані звіти
  ${status}  Get Element Attribute  ${switcher} [value]  value
  [Return]  ${status}


Прибрати звіт з обраних
  ${status}  Перевірити наявність обраних звітів
  Run Keyword If  ${status} == ${True}  Click Element  ${report}//*[@class="fa fa-star"]
  Sleep  .5
  ${status}  Перевірити наявність обраних звітів
  [Return]  ${status}


Перевірити наявність обраних звітів
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${report}//*[@class="fa fa-star"]
  [Return]  ${status}


Вибрати випадковий звіт
  ${count}  Get Element Count  ${report}
  ${n}  random_number  1  ${count}
  [Return]  ${n}


Додати звіт в обрані
  [Arguments]  ${n}
  Click Element  (${report})[${n}]
  Sleep  .5


Отримати назву звіту за номером
  [Arguments]  ${n}
  ${report name}  Get Text  (${report})[${n}]/following-sibling::*//*[@title]
  [Return]  ${report name}