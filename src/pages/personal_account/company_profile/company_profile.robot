*** Variables ***


*** Keywords ***
Перевірити сторінку
  Select frame  css=div.main-content iFrame
  Wait Until Page Contains Element  css=#FormLayout_1_0  30
  Element Should Contain  css=#FormLayout_1_0  Основна інформація
  Element Should Contain  css=#FormLayout_1_1  Додаткова інформація
  Page Should Contain Element  css=#BTSUBMIT_CD
  Unselect Frame