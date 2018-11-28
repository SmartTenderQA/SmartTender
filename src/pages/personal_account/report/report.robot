*** Variables ***


*** Keywords ***
Натиснути на фільтр Тільки обрані звіти
  [Arguments]  ${action}
  ${switcher}  Set Variable  css=.ivu-switch
  ${status}  Get Element Attribute  ${switcher} [value]  value
  Run Keyword If  "${status}" == "false" and "${action}" == "увімкнути"
  ...  Click Element  ${switcher}
  Run Keyword If  "${status}" == "true" and "${action}" == "вимкнути"
  ...  Click Element  ${switcher}
  Sleep  3


Перевірити наявність звітів
  Page Should Contain Element  css=.ivu-card-body .favoriteStar


Прибрати з обраних усі звіти
  ${status}  Run Keyword And Return Status  Page Should Contain Element  ${report}//*[@class="fa fa-star"]
  Run Keyword If  ${status} == ${True}  Click Element  ${report}//*[@class="fa fa-star"]
  Sleep  5
  Run Keyword If  ${status} == ${True}  Прибрати з обраних усі звіти


Додати в обрані випадковій звіт та вернути назву
  ${count}  Get Element Count  ${report}
  ${n}  random_number  1  ${count}
  Click Element  (${report})[${n}]
  ${name}  Get Text  (${report})[${n}]/following-sibling::*//*[@title]
  Sleep  3
  [Return]  ${name}


Перевірити фильтр Тільки обрані звіти
  [Arguments]  ${name}
  Натиснути на фільтр Тільки обрані звіти  увімкнути
  ${count}  Get Element Count  ${report}
  Should Be Equal  "${count}"  "1"
  ${report name}  Get Text  ${report}/following-sibling::*//*[@title]
  Should Be Equal  ${report name}  ${name}
  Натиснути на фільтр Тільки обрані звіти  вимкнути
  ${count}  Get Element Count  ${report}
  Run Keyword if  ${count} < 2  Fail  Маловато будет(Отчетов)
