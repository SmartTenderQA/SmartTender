*** Settings ***
Resource  				../../src/src.robot

Suite Setup  			Run Keywords
	...  debug  AND
						...  Open Browser In Grid  ${user}  								AND
						...  Go To  ${start_page}/Participation/tenders/  			AND
						...  Дочекатись закінчення загрузки сторінки
Suite Teardown  		Close All Browsers
Test Teardown  			Run Keywords
						...  Log Location  											AND
						...  Run Keyword If Test Failed  Capture Page Screenshot

*** Test Cases ***
Elastic Smoke
	new_search.Очистити фільтр пошуку
	Ввести фразу для пошуку  бумага
	new_search.Натиснути кнопку пошуку
	${status}  Run Keyword And Return Status  Page Should Contain  папір
	Run Keyword If  not ${status}  Page Should Contain  Папір
