*** Settings ***
Resource    keywords.robot


*** Variable ***
${advanced search}                 		//div[contains(text(),'Розширений пошук')]/..
${dropdown menu for bid forms}			//label[contains(text(),'Форми ')]/../../ul
${first found element}      	        //*[@id='tenders']//tbody/*[@class='head']//a[@class='linkSubjTrading']
${find tender field}                xpath=//input[@placeholder="Введіть запит для пошуку або номер тендеру"]


*** Keywords ***
Розгорнути розширений пошук
	Wait Until Keyword Succeeds  30s  5  Run Keywords
	...  Click Element  ${advanced search}  AND
	...  Run Keyword And Expect Error  *  Click Element  ${advanced search}


Вибрати тип процедури
	[Arguments]  ${type}
	Wait Until Keyword Succeeds  30s  5  Run Keywords
	...  Click Element  ${dropdown menu for bid forms}  AND
	...  Wait Until Page Contains Element  css=.token-input-dropdown-facebook li  AND
	...  Wait Until Page Contains Element  xpath=//li[contains(@class,'dropdown-item') and text()='${type}']  AND
	...  Click Element  xpath=//li[contains(@class,'dropdown-item') and text()='${type}']


Перейти по результату пошуку за номером
	[Arguments]  ${n}
	${selector}  Set Variable  xpath=(${first found element})[${n}]
	${href}  Get Element Attribute  ${selector}  href
	${href}  Поправити лінку для IP  ${href}
	Go To  ${href}
	Дочекатись закінчення загрузки сторінки(skeleton)


Виконати пошук тендера
	[Arguments]  ${id}=None
	Run Keyword If  '${id}' != 'None'  Input Text  ${find tender field}  ${id}
	Press Key  ${find tender field}  \\13
	Run Keyword If  '${id}' != 'None'  Location Should Contain  f=${id}
	${status}  Run Keyword And Return Status  Wait Until Page Contains Element  ${tender found}
	Run Keyword If  '${status}' == 'False'  Fail  Не знайдено жодного тендера
	Run Keyword If  '${id}' != 'None'  Перевірити унікальність результату пошуку