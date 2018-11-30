*** Settings ***
Resource  				../../src/src.robot

Suite Setup  			Start in grid  ${user}
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Page Screenshot


*** Test Cases ***
Сформувати рахунок-фактуру
    start_page.Відкрити особистий кабінет
    personal_account.Відкрити сторінку за назвою  invoice
    invoice.Перевірити сторінку
	${amount}  Сгенерувати суму до оплати
	Ввести суму до оплати  ${amount}
	Натиснути сформувати рахунок
	Перевірити валідаційне повідомлення для сформованого рахунку
	Перевірити email рахунок-фактуру  ${amount}


*** Keywords ***
Сгенерувати суму до оплати
	${n}  random_number  1  1000
	${amount}  Evaluate  ${n}*17
	[Return]  ${amount}


Перевірити email рахунок-фактуру
	[Arguments]  ${amount}
	Розпочати роботу з Gmail  ${user}
	Відкрити лист в Email за темою  SmartTender - Рахунок за Надання послуг
	Перевірити вкладений файл за назвою  ${amount}  Рахунок
	Close Browser
	Switch Browser  1