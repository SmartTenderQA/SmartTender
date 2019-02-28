*** Settings ***
Resource  				../../src/src.robot

Suite Setup  			Open Browser In Grid  ${user}
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Full Screenshot


*** Test Cases ***
Перевірка гарантійного внеску для open_eu
	Натиснути на іконку з баннеру  Комерційні тендери SmartTender
	old_search.Активувати вкладку Державних закупівель
	old_search.Розгорнути Розширений Пошук
	old_search.Вибрати Тип Процедури  Відкриті торги з публікацією англійською мовою
	old_search.Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	Дочекатись закінчення загрузки сторінки
	Перевірити тип процедури
	Перевірка гарантійного внеску



*** Keywords ***
Перевірити тип процедури
	${is}  procurement_tender_detail.Отритами дані зі сторінки  ['procedure-type']
	Should Contain  ${is}  Відкриті торги з публікацією англійською мовою

