*** Variables ***
${vidhuky}			//*[@class='ivu-row']//*[@class='ivu-card-body']


*** Keywords ***
Перевірити заголовок сторінки відгуків
	Element Should Contain  //h1  Відгуки


Порахувати кількість відгуків
	${count}  Get Element Count  ${vidhuky}
	[Return]  ${count}


Відкрити відгук
	Click Element  ${vidhuky}
	Wait Until Page Contains Element  //div[@id="pdf-main-container"]//*[@id="div-pdf-canvas"]|//*[@class="ivu-modal-content"]//img  10