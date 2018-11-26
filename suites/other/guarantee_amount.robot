*** Settings ***
Resource  				../../src/src.robot

Suite Setup  			Start in grid  ${user}
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Page Screenshot


*** Test Cases ***
Перевірка гарантійного внеску для open_eu
	Натиснути На торговельний майданчик
	Перейти на сторінку публічні закупівлі
	Відфільтрувати по формі торгів  Відкриті торги з публікацією англійською мовою
	Виконати пошук тендера
	Перейти по результату пошуку  (${first found element})[last()]
	Дочекатись закінчення загрузки сторінки(skeleton)
	Перевірити тип процедури
	Перевірка гарантійного внеску



*** Keywords ***
Перевірити тип процедури
	${is}  procurement_tender_detail.Отритами дані зі сторінки  ['procedure-type']
	Should Contain  ${is}  Відкриті торги з публікацією англійською мовою

