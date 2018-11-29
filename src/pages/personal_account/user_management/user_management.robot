*** Variables ***


*** Keywords ***
Перевірити сторінку
  Wait Until Page Contains Element  //h1  30
  Element Should Contain  //h1  Структура підприємства
  Element Should Contain  //h5  Управління користувачами
  ${tr for user}  Set Variable  css=.ivu-table-body .ivu-table-row
  Page Should Contain Element  ${tr for user}