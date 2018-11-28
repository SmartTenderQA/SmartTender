*** Variables ***
${not collapsed menu button your account}         //*[contains(@class, "page-container") and not(contains(@class, "collapsed"))]//*[@class="sidebar-collapse"]
${collapsed menu button your account}             //*[contains(@class, "page-container") and contains(@class, "collapsed")]//*[@class="sidebar-collapse"]

*** Keywords ***
Розкрити меню в особистому кабінеті
	${status}  Run Keyword And Return Status  Page Should Contain Element  ${not collapsed menu button your account}
	Run Keyword If  "${status}" != "True"  Click Element  ${collapsed menu button your account}


Відкрити сторінку рахунка фактури
	Click Element  //*[contains(text(), "Сформувати рахунок-фактуру")]/ancestor::a
	Location Should Contain  /invoicepage/

