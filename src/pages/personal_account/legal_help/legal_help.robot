*** Variables ***


*** Keywords ***
Перевірити сторінку
  Select frame  css=div.main-content iFrame
  Wait Until Page Contains Element  //*[@class="ivu-card-head"]//h4  30
  Element Should Contain  //*[@class="ivu-card-head"]//h4  Отримати юридичну допомогу
  Page Should Contain Element  css=.ivu-card-body>button[type="button"]
  Unselect Frame