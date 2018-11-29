*** Variables ***
${switcher}             css=.ivu-switch


*** Keywords ***
Отримати статус перемикача Тільки обрані звіти
  ${status}  Get Element Attribute  ${switcher} [value]  value
  [Return]  ${status}


Прибрати звіт з обраних
  ${status}  Перевірити наявність звітів
  Run Keyword If  ${status} == ${True}  Click Element  ${report}//*[@class="fa fa-star"]
  Sleep  .5
  ${status}  Перевірити наявність звітів
  [Return]  ${status}


Отримати назву звіту за номером
  [Arguments]  ${n}
  ${report name}  Get Text  (${report})[${n}]/following-sibling::*//*[@title]
  [Return]  ${report name}


Перевірити наявність звітів
  ${status}  Run Keyword And Return Status  Page Should Contain Element  css=.ivu-card-body .favoriteStar
  [Return]  ${status}