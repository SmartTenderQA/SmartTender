*** Keywords ***
Ввести суму до оплати
	[Arguments]  ${amount}
	${input field}  Set Variable  //*[@class="ivu-card-body"]//input
	Wait Until Page Contains Element  ${input field}  60
	Input Text  ${input field}  ${amount}
	${get}  Get Element Attribute  ${input field}  value
	Run Keyword If  "${get}" == ""  Ввести суму до оплати


Натиснути сформувати рахунок
	${selector}  Set Variable  //*[@class="ivu-card-body"]//button
	Click Element  (${selector})[last()]
	Дочекатись закінчення загрузки сторінки
	Wait Until Page Does Not Contain  ${selector}


Перевірити валідаційне повідомлення для сформованого рахунку
	Element Should Contain  css=.ivu-alert-desc  Рахунок сформований
	Element Should Contain  css=.ivu-alert-desc  відправлений на електронну адресу Вашої компанії