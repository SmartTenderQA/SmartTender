*** Settings ***
Resource  ../../src/src.robot
Suite Setup				Preconditions
Suite Teardown  		Close All Browsers
Test Teardown    		Run Keywords
						...  Log  ${checks}  AND
						...  Log Location  AND
						...  Run Keyword If Test Failed  Capture Page Screenshot

# Команда запуска проверки коммерческих
# robot --consolecolors on -L TRACE:INFO -v user:test_viewer -v browser:chrome -d test_output -v type:commercial -v hub:none suites/other/check_docs_in_auctions.robot

# Команда запуска проверки прозорро
# robot --consolecolors on -L TRACE:INFO -v user:test_viewer -v browser:chrome -d test_output -v type:procurement -v hub:none suites/other/check_docs_in_auctions.robot

# убрать с прода проверку картинок


*** Variables ***
@{image_format}                png  jpg  jpeg  gif  tif  tiff  bmp


*** Test Cases ***
Відкрити сторінку торгів ${type}
	Run Keyword If  '${type}' == 'commercial'
	...  Натиснути на іконку з баннеру  Комерційні тендери SmartTender
	...  ELSE IF  '${type}' == 'procurement'
	...  Натиснути на іконку з баннеру  Державні закупівлі Prozorro
	...  ELSE IF  '${type}' == 'bank_aucs'
	...  Натиснути на іконку з баннеру  Аукціони на продаж майна банків


Пошук та перевірка необхідних файлів
	:FOR  ${page}  IN RANGE  1  6
	\  Активувати вкладку за номером  ${page}
	\  ${tenders count}  Порахувати кількість процедур на сторінці
	\  Run Keyword If  '${type}' != 'bank_aucs'
	...  Почати пошук файлів у процедурах  		${tenders count}  ELSE
	...  Почати пошук файлів у процедурах new  	${tenders count}


*** Keywords ***
Preconditions
	${user}  Set Variable If  "prod" in "${where}"  prod_viewer  test_viewer
	Open Browser In Grid  ${user}
	&{checks}  Create Dictionary
	...  checked_doc	${false}
	...  checked_docx	${false}
#	...  checked_pdf	${false}
	Set Global Variable  &{checks}
#	Run Keyword If  '${site}' == 'test'				Set To Dictionary  ${checks}  checked_image	${false}
	Run Keyword If  '${type}' == 'procurement'		Set To Dictionary  ${checks}  checked_p7s	${false}


Активувати вкладку за номером
    [Arguments]  ${page}
    ${selector}  Run Keyword If  '${type}' != 'bank_aucs'
    ...  Set Variable  //a[@class="pager-button" and text()=${page}]  ELSE
    ...  Set Variable  //li[@class="ivu-page-item" and @title=${page}]
    ${status}  Run Keyword If  '${page}' != '1'
    ...  Run Keyword And Return Status  Element Should Be Visible  ${selector}
    # Вийти з цикла якщо не існує наступної сторінки
    Run Keyword If  ${status} == ${false}  Exit For Loop
    ...  ELSE IF  ${status} == ${true}  Click Element  ${selector}
    Run Keyword If  '${type}' != 'bank_aucs'  Run Keyword And Ignore Error  Run Keywords
    ...  Видалити кнопку "Замовити звонок"
    ...  Видалити кнопку "Поставити запитання"
    ...  ELSE  Дочекатись закінчення загрузки сторінки(skeleton)


Порахувати кількість процедур на сторінці
	${selector}  Set Variable If
	...  '${type}' != 'bank_aucs'   //tr[@class="head"]
	...                             //div[@class="panel panel-default panel-highlight"]
	Wait Until Element Is Visible  ${selector}
	${tenders_on_page}  Get Element Count  ${selector}
	[Return]  ${tenders_on_page}


Почати пошук файлів у процедурах
	[Arguments]  ${tenders_on_page}
	:FOR  ${tender}  IN RANGE  1  ${tenders_on_page}
	\  Log Many  &{checks}
	\  Wait Until Keyword Succeeds  20  .5  Розкрити тендер за номером  ${tender}
	\  ${list of files}  Отримати список файлів у процедурі  ${tender}
	\  Log Many  @{list of files}
	\  ${files for checks}  Сформувати список файлів до перевірки  ${list of files}
	\  Log Many  @{files for checks}
	\  Continue For Loop If  ${files for checks} == []
	\  Відкрити сторінку детальної інформації процедури за номером  ${tender}
	\  Перевірити всі необхідні документи  ${files for checks}
	\  Завершити тест при виконанні вимог
	\  Закрити сторінку детальної інформації


Розкрити тендер за номером
	[Arguments]  ${number}
	${tender_expand}  Set Variable  (//tr[@class="head"])[${number}]/td/span
	Click Element  ${tender_expand}
	Дочекатись загрузки документів в тендері
	${tender header}  Set Variable  (//h3[@class="tender-header-row"])[${number}]
	Click Element  ${tender header}
	Scroll Page To Element XPATH  (//tr[@class="head"])[${number}+1]/td/span


Отримати список файлів у процедурі
	[Arguments]  ${number}
	${list of files}  Create List
	${file selector}  Set Variable  (//tr[@class="head"])[${number}]/following-sibling::tr//*[@class="item"]/a[@href]
	${doc_quantity}  Get Element Count  ${file selector}
	:FOR  ${file}  IN RANGE  1  ${doc_quantity}+1
	\  ${file name}  Wait Until Keyword Succeeds  10  .5  Get Text  (//tr[@class="head"])[${number}]/following::div[@class="item"][${file}]//span
#	\  ${file name}  Wait Until Keyword Succeeds  10  .5  Get Text  ${file selector}[${file}]
	\  Append To List  ${list of files}  ${file name}
	[Return]  ${list of files}


Сформувати список файлів до перевірки
	[Arguments]  ${list of files}
	${files for checks}  Create List
	:FOR  ${file}  IN  @{list of files}
	\  ${doc_type}  Отримати формат файлу  ${file}
	\  ${status}  Run Keyword And Return Status
	...  Dictionary Should Contain Key  ${checks}  checked_${doc_type}
	\  Run Keyword If  ${status}
	...  Run Keyword If  """${checks["checked_${doc_type}"]}""" == "${False}"  Run Keywords
	...  Append To List  ${files for checks}  ${file}  AND
	...  Set To Dictionary  ${checks}  checked_${doc_type}  ${True}  AND
	...  Log  ${doc_type}  WARN  AND
	...  Log  ${checks}  WARN
	[Return]  ${files for checks}


Отримати формат файлу
	[Arguments]  ${file name}
	${doc_type}  Fetch From Right  ${file name}  .
	${doc_type}  Convert To Lowercase  ${doc_type}
	${image_status}  Run Keyword And Return Status  List Should Contain Value  ${image_format}  ${doc_type}
	${doc_type}  Run Keyword If  ${image_status}  Set Variable  image  ELSE  Set Variable  ${doctype}
	[Return]  ${doc_type}


Відкрити сторінку детальної інформації процедури за номером
	[Arguments]  ${tender_number}
	${button_selector}  Set Variable  xpath=(//a[contains(@class, "analysis-button")])[${tender_number}]
	Scroll Page To Element XPATH  ${button_selector}
	Sleep  .5
	Click Element  ${button_selector}
	Select Window  NEW


Закрити сторінку детальної інформації
	Close Window
	Select Window  MAIN


Перевірити всі необхідні документи
	[Arguments]  ${files for checks}
	${location}  Get Location
	Log  ${location}  WARN
	:FOR  ${file}  IN  @{files for checks}
	\  Wait Until Keyword Succeeds  10  .5  Page Should Contain  ${file}
	\  ${doc_type}  Отримати формат файлу  ${file}
	\  Run Keyword If  "${doc_type}" == "p7s"  Run Keywords
	...  Set To Dictionary  ${checks}  checked_${doc_type}  ${True}  AND
	...  Exit For Loop
	\  Відкрити документ  ${file}
	\  Run Keyword If  '${type}' == 'commercial'  Перевірити наявність найменування файлу в локації  ${doc_type}
	\  ${location}  Get Location
	\  Should Not Contain  ${location}  error
	\  Page Should Not Contain  an error
	\  Page Should Not Contain  омилка
	\  Go Back


Відкрити документ
	[Arguments]  ${file}
	${file selector}  Set Variable  //*[contains(text(), "${file}")]
	Wait Until Keyword Succeeds  10  .5
	...  Scroll Page To Element XPATH  ${file selector}
	Mouse Over  ${file selector}
	Wait Until Keyword Succeeds  30  1  Run Keywords
	...  Open Button  ${file selector}/ancestor::*[@class="ivu-poptip"]//*[@data-qa="file-preview"]  AND
	...  Wait Until Page Does Not Contain Element  ${file selector}/ancestor::*[@class="ivu-poptip"]//*[@data-qa="file-preview"]


Перевірити наявність найменування файлу в локації
	[Arguments]  ${doc_type}
	${lowercase_status}  Run Keyword And Return Status  Location Should Contain  ${doc_type[:3]}
	${upper_doc_type}  Run Keyword If  ${lowercase_status} == ${False}  Convert To Uppercase  ${doc_type}
	Run Keyword If  ${lowercase_status} == ${False}  Location Should Contain  ${upper_doc_type[:3]}


Завершити тест при виконанні вимог
	${status}
	...  Run Keyword If  '${site}' == 'test'  Run Keyword And Return Status
	...  		Dictionary Should Contain Value  ${checks}  ${True}
	...  ELSE IF  '${site}' == 'prod'  Run Keyword And Return Status
	...  		Dictionary Should Not Contain Value  ${checks}  ${False}
	Pass Execution If  ${status}  Вимоги для завершення тесту виконані


Почати пошук файлів у процедурах new
	[Arguments]  ${tenders_on_page}
	:FOR  ${tender}  IN RANGE  1  ${tenders_on_page}+1
	\  Відкрити сторінку детальної інформації процедури за номером new  ${tender}
	\  Log Many  &{checks}
	\  ${list of files}  Отримати список файлів у процедурі new
	\  Log Many  @{list of files}
	\  ${files for checks}  Сформувати список файлів до перевірки  ${list of files}
	\  Log Many  @{files for checks}
	\  Перевірити всі необхідні документи new  ${files for checks}
	\  Завершити тест при виконанні вимог
	\  Go Back
	\  Дочекатись закінчення загрузки сторінки(skeleton)


Отримати список файлів у процедурі new
	${list of files}  Create List
	${selector}  Set Variable  //*[@data-qa="file-name"]
	${n}  Get Element Count  ${selector}
	:FOR  ${file}  IN RANGE  1  ${n}+1
	\  ${file name}  Get Text  (${selector})[${file}]
	\  Append To List  ${list of files}  ${file name}
	[Return]  ${list of files}


Перевірити всі необхідні документи new
	[Arguments]  ${files for checks}
	:FOR  ${file}  IN  @{files for checks}
	\  ${doc_type}  Отримати формат файлу  ${file}
	\  Відкрити документ  ${file}
	\  ${doc_type for check location}  Fetch From Right  ${file}  .
	\  Перевірити наявність найменування файлу в локації  ${doc_type for check location}
	\  ${location}  Get Location
	\  Should Not Contain  ${location}  error
	\  Page Should Not Contain  an error
	\  Go Back


Відкрити сторінку детальної інформації процедури за номером new
	[Arguments]  ${tender_number}
	${button_selector}  Set Variable  (//div[@class="panel panel-default panel-highlight"])[${tender_number}]//a
	Scroll Page To Element XPATH  ${button_selector}
	Sleep  .5
	Click Element  ${button_selector}
	Дочекатись закінчення загрузки сторінки(skeleton)