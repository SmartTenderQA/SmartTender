*** Settings ***
Resource    keywords.robot


*** Variable ***
${advanced search}                 		//div[contains(text(),'Розширений пошук')]/..
${dropdown menu for bid forms}			//label[contains(text(),'Форми ')]/../../ul
${first found element}      	        //*[@id='tenders']//tbody/*[@class='head']//a[@class='linkSubjTrading']
${find tender field}                	xpath=//input[@placeholder="Введіть запит для пошуку або номер тендеру"]
${first element find tender}        	//*[@id="tenders"]//tr[1]/td[2]/a


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
	${selector}  Set Variable  (${first found element})[${n}]
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


Порахувати кількість торгів
	${count}  Get Element Count  ${first element find tender}
	[Return]  ${count}


Активувати вкладку Комерційні торги
	Click Element  ${torgy top/bottom tab}(1) ${torgy count tab}(1)
	Дочекатись закінчення загрузки сторінки


Активувати вкладку Державних закупівель
	Click Element  ${torgy top/bottom tab}(1) ${torgy count tab}(2)
	Дочекатись закінчення загрузки сторінки


Активувати вкладку ФГВ
	Click Element  ${torgy top/bottom tab}(1) ${torgy count tab}(3)
	Дочекатись закінчення загрузки сторінки


Активувати вкладку ФГИ
	Click Element  ${torgy top/bottom tab}(1) ${torgy count tab}(4)
	Дочекатись закінчення загрузки сторінки


Активувати вкладку RIALTO
	Click Element  ${torgy top/bottom tab}(1) ${torgy count tab}(5)
	Дочекатись закінчення загрузки сторінки


Активувати вкладку Комерційні торги за типом
	[Arguments]  ${text}
	${i}  Run Keyword If
	...  'Закупівлі' == '${text}'  Set Variable  1  ELSE IF
	...  'Продажі' == '${text}'  Set Variable  2
	Click Element  ${torgy top/bottom tab}(2) ${torgy count tab}(${i})
	Дочекатись закінчення загрузки сторінки


Активувати вкладку Державних закупівель за типом
	[Arguments]  ${text}
	${i}  Run Keyword If
	...  'Конкурентні процедури' == '${text}'  Set Variable  1  ELSE IF
	...  'Неконкурентні процедури' == '${text}'  Set Variable  2  ELSE IF
	...  'Плани' == '${text}'  Set Variable  3  ELSE IF
	...  'Договори' == '${text}'  Set Variable  4
	Click Element  ${torgy top/bottom tab}(2) ${torgy count tab}(${i})
	Дочекатись закінчення загрузки сторінки


Активувати вкладку ФГВ за типом
	[Arguments]  ${text}
	${i}  Run Keyword If
	...  'Аукціони' == '${text}'  Set Variable  1  ELSE IF
	...  'Реєстр активів' == '${text}'  Set Variable  2
	${is}  Get Text  ${commercial tabs}(${i})
	Click Element  ${torgy top/bottom tab}(2) ${torgy count tab}(${i})
	Дочекатись закінчення загрузки сторінки(skeleton)