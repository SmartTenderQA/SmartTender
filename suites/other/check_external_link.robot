*** Settings ***
Resource  				../../src/src.robot

Suite Setup  			Preconditions
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Page Screenshot



*** Test Cases ***
Перевірка посилання на тендер (з порталу)
	[Tags]  procurement
	Натиснути на іконку з баннеру  Комерційні тендери SmartTender
	old_search.Активувати вкладку Державних закупівель
	Виконати пошук тендера
	old_search.Перейти по результату пошуку за номером  last()
	${id}  procurement_tender_detail.Отритами дані зі сторінки  ['tenderID']
	${title}  procurement_tender_detail.Отритами дані зі сторінки  ['title']
	${link}  Сформувати пряме посилання на тендер  ${id}
	Дочекатись закінчення загрузки сторінки(skeleton)
	${new_title}  procurement_tender_detail.Отритами дані зі сторінки  ['title']
	Should Be Equal  ${title}  ${new_title}



*** Keywords ***
Сформувати пряме посилання на тендер
	[Arguments]  ${id}
	${link to tender}  Set Variable  ${start page}/publichni-zakupivli-prozorro/${id}
	[Return]  ${link to tender}


Preconditions
    Run Keyword If  '${where}' == 'test'  Set Global Variable  ${user}  user1
	Run Keyword If  'prod' in '${where}'  Set Global Variable  ${user}  prod_provider
    Open Browser In Grid  ${user}