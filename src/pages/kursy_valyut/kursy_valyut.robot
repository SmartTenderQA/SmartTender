*** Keywords ***
Перевірити заголовок сторінки
	Element Should Contain  css=#content h1  Курсы валют


Перевірити посилання
	Select Frame  css=#main #content iframe
	${should link1}  Set Variable  http://www.bank.gov.ua/control/uk/curmetal/currency/
	${should link2}  Set Variable  http://minfin.com.ua/currency/mb/archive/usd/
	${is link1}  Get Element Attribute  ${exchange link1}  href
	${is link1}  Поправити лінку для IP  ${is link1}
	${is link2}  Get Element Attribute  ${exchange link2}  href
	${is link2}  Поправити лінку для IP  ${is link2}
	Should Contain  ${is link1}  ${should link1}
	Should Contain  ${is link2}  ${should link2}
	Unselect Frame