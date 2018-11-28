*** Variables ***
${page title}							//*[@type='flex']//h1
${messages block}                    	//*[contains(@class,'long-text')]/span
${close button}							//*[@class="ivu-modal-close"]


*** Keywords ***
Перевірити заголовок сторінки повідомлень
	${should header}  Set Variable  Повідомлення
	${is header}  Get Text  ${page title}
	Should Be Equal  ${is header}  ${should header}


Порахувати кількість повідомлень
	${count}  Get Element Count  ${messages block}
	Run Keyword if  '${count}' == '0'  Fail  Де повідомлення?


Переглянути повідемлення
	${title}  Get Text  (${messages block})[1]
	Click Element  (${messages block})[1]
	Sleep  5
	${message title}  Get Text  //table//div[contains(text(),'ТЕСТУВАННЯ')]
	Should Be Equal  ${title}  ${message title}


Закрити вікно з повідомленням
	Wait Until Page Contains Element  ${close button}
	Click Element  ${close button}
	Wait Until Element Is Not Visible  ${close button}