*** Keywords ***
Отримати баланс
	${value}  Get Text  //*[@data-qa="balance-balance"]//div[2]
	${list}  Evaluate  re.search(ur'(?P<price>[\\d\\s\\-\\.\\,]*)\\s(?P<currency>.*)', u'${value}')  re
	${price}  Evaluate  float('${list.group('price')}'.replace(' ', ''))
	${currency}  Set Variable  ${list.group('currency')}
	[Return]  ${price}  ${currency}


Отримати кредит
	${value}  Get Text  //*[@data-qa="balance-overdraft"]//div[2]
	${list}  Evaluate  re.search(ur'(?P<price>[\\d\\s\\-\\.\\,]*)\\s(?P<currency>.*)', u'${value}')  re
	${price}  Evaluate  float('${list.group('price')}'.replace(' ', ''))
	${currency}  Set Variable  ${list.group('currency')}
	[Return]  ${price}  ${currency}



Натиснути сформувати Invoice
	elements.Дочекатися відображення елемента на сторінці  //*[@data-qa="btn-create-invoice"]
	Click Element  //*[@data-qa="btn-create-invoice"]
	Дочекатись закінчення загрузки сторінки
	Location Should Contain  /invoicepage/purchase/