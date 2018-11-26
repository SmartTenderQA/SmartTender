*** Variables ***
${button kontakty}                   css=.menu a[href='/pro-kompaniyu/kontakty/']
${personal account}                  xpath=//*[@id='MenuList']//*[contains(@class, 'loginButton')]//a[@id='LoginAnchor' and not(@class)]


*** Keywords ***
Зайти на сторінку з контактами
	Click Element  ${button kontakty}
	Location Should Contain  /pro-kompaniyu/kontakty/


Відкрити особистий кабінет
	Page Should Contain Element  ${personal account}
	Click Element  ${personal account}
	Location Should Contain  /webparts/
	Page Should Contain Element  css=.sidebar-menu
	Page Should Contain Element  css=.main-content


Відкрити особистий кабінет webcliend
  Page Should Contain Element  ${personal account}
  Click Element  ${personal account}
  Location Should Contain  /webclient/


Відкрити особистий кабінет для ssp_tender_owner
  Page Should Contain Element  ${personal account}
  Click Element  ${personal account}
  Location Should Contain  /cabinet/registry/privatization-objects
  Page Should Contain Element  css=.action-block [type="button"]
  Page Should Contain Element  css=.content-block .asset-card

