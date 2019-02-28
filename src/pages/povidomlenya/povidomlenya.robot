*** Variables ***
${page title}							//h1
${messages block}                    	//*[@class="a-card"]//*[contains(@class,"ivu-col-span-sm-19")]
${close button}							//*[@class="ivu-modal-wrap vertical-center-modal"]//*[@class="ivu-modal-close"]


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
	elements.Дочекатися відображення елемента на сторінці  ${close button}
	${message title}  Get Text  //td[contains(@style,'background-color: rgb(48,63,159)')]//div[contains(@style,'color:#fff')]
	Should Be Equal  ${title}  ${message title}


Закрити вікно з повідомленням
	Wait Until Page Contains Element  ${close button}
	Click Element  ${close button}
	Wait Until Element Is Not Visible  ${close button}