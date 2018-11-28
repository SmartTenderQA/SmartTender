*** Variables ***
${personal account}					xpath=//*[@id='MenuList']//*[contains(@class, 'loginButton')]//a[@id='LoginAnchor' and not(@class)]


*** Keywords ***
Відкрити особистий кабінет для provider
  Page Should Contain Element  ${personal account}
  Click Element  ${personal account}
  Дочекатись закінчення загрузки сторінки
  Location Should Contain  /webparts/
  Page Should Contain Element  css=.sidebar-menu
  Page Should Contain Element  css=.main-content


Відкрити особистий кабінет для tender_owner
  Page Should Contain Element  ${personal account}
  Click Element  ${personal account}
  Дочекатись закінчення загрузки сторінки
  Location Should Contain  /webclient/


Відкрити особистий кабінет для ssp_tender_owner
  Page Should Contain Element  ${personal account}
  Click Element  ${personal account}
  Дочекатись закінчення загрузки сторінки
  Location Should Contain  /cabinet/registry/privatization-objects
  Page Should Contain Element  css=.action-block [type="button"]
  Page Should Contain Element  css=.content-block .asset-card

