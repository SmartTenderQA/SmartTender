*** Settings ***
Library  		convert_page_values.py
Library         convert_cdb_values.py
Resource  		procurement_page_keywords.robot
Library         procurement_variables.py
Variables       procurement_variables.py



*** Keywords ***
Активувати вкладку "Тендер"
    ${tender tab}  Set Variable  //*[@data-qa="tabs"]//*[text()=" Тендер "]
    Click Element  ${tender tab}
    ${status}  Run Keyword And Return Status
    ...  Element Should Be Visible  ${tender tab}/ancestor::div[contains(@class,"tab-active")]
    Run Keyword If  '${status}' == 'False'  Click Element  ${tender tab}


Перевірити кнопку подачі пропозиції
    [Arguments]  ${selector}=None
    ${button}  Run Keyword If  "${selector}" == "None"
    ...  Set Variable  xpath=//*[@class='show-control button-lot']|//*[@data-qa="bid-button"]
    ...  ELSE  Set Variable  ${selector}
    Page Should Contain Element  ${button}
    Open button  ${button}
    Location Should Contain  /edit/
    Wait Until Keyword Succeeds  5m  3  Run Keywords
    ...  Reload Page  AND
    ...  Element Should Not Be Visible  //*[@class='modal-dialog ']//h4


Перевірити коректність даних на сторінці
    [Arguments]  ${field}
    ${value}  procurement_tender_detail.Отритами дані зі сторінки  ${field}
    Should Be Equal  ${value}  ${data${field}}


Порівняти введені дані з даними в ЦБД
	[Arguments]  ${field}
	${value entered}  Set Variable  ${data${field}}
    ${value cdb}  procurement_tender_detail.Отритами дані з ЦБД  ${field}
    ${status}  Run Keyword And Return Status  Should Be Equal As Strings  ${value entered}  ${value cdb}
 	Should Be True  ${status}  Oops! Помилка з даними для ${field}


Порівняти відображені дані з даними в ЦБД
    [Arguments]  ${field}
    ${value on page}  procurement_tender_detail.Отритами дані зі сторінки  ${field}
    ${value cdb}  procurement_tender_detail.Отритами дані з ЦБД  ${field}
    ${status}  Run Keyword And Return Status  Should Be Equal  ${value on page}  ${value cdb}
 	Should Be True  ${status}  Oops! Помилка з даними для ${field}


Отритами дані з ЦБД
    [Arguments]  ${field}
    ${value}  Set Variable  ${cdb${field}}
    ${cdb value}  convert_cdb_values  ${field}  ${value}
    [Return]  ${cdb value}


Отритами дані зі сторінки
	[Arguments]  ${field}
	${selector}  procurement_variables.get_locator  ${field}
	${selector}  Set Variable If  '${selector}' == 'None'  ${locators${field}}  ${selector}
	Wait Until Element Is Visible  ${selector}  3
	${value}  Get Text  ${selector}
	${field value}  convert_page_values  ${field}  ${value}
	[Return]  ${field value}


Дочекатися статусу тендера
    [Arguments]  ${tender status}  ${time}=20m
    Wait Until Keyword Succeeds  ${time}  30s  Run Keywords
    ...  Reload Page
    ...  AND  Статус тендера повинен бути  ${tender status}


Перевірити гарантійний внесок
	guarantee_amount.Перевірка гарантійного внеску


Додати кваліфікаційний документ
    [Arguments]  ${EDS}=None
    Натиснути "Завантажити кваліфікаційні документи"
    loading.Дочекатись закінчення загрузки сторінки
    ${file name}  ${hash}  Wait Until Keyword Succeeds  20  2  actions.Додати doc файл
    ${message}  Натиснути "Завантадити документи" та отримати відповідь
    Виконати дії відповідно до тексту повідомлення  ${message}
    Run Keyword If  '${EDS}' == 'True'  EDS.Підписати ЕЦП
    Go Back
    [Return]  ${file name}  ${hash}


Розгорнути всі експандери
    ${selector down}  Set Variable  //*[contains(@class,"expander")]/i[contains(@class,"down")]
    ${count}  Get Element Count  ${selector down}
    Run Keyword If  ${count} != 0  Run Keywords
    ...  Repeat Keyword  ${count} times  Click Element  ${selector down}  AND
    ...  Розгорнути всі експандери


Відкрити вікно "Причина відміни" детальніше
    ${selector}  Set Variable  //*[@data-qa="show-reason-button"]
    Element Should Be Visible  ${selector}
    Click Element  ${selector}
    Element Text Should Be  //*[@data-qa="reason"]//*[@class="ivu-modal-header-inner"]
    ...  Причина відміни


Порівняти створений документ з документом в ЦБД procurement
	[Arguments]  ${doc}
	${cdb_doc}  get_cdb_doc  ${doc}  ${cdb}
	Should Be Equal  ${cdb_doc['title']}  ${doc['title']}  Oops! Помилка з title
	Should Be Equal  ${cdb_doc['hash']}  ${doc['hash']}  Oops! Помилка з hash


Порівняти відображений документ з документом в ЦБД procurement
	[Arguments]  ${doc}
	${cdb_doc}  get_cdb_doc  ${doc}  ${cdb}
	${view doc block}  Set Variable  //*[@style and @class='ivu-row' and contains(.,'${doc['title']}')]
	Scroll Page To Element XPATH  ${view doc block}
	${view title}  Get Text  ${view doc block}${docs_view['title']}
	Should Be Equal  ${view title}  ${cdb_doc['title']}  Oops! Помилка з title

