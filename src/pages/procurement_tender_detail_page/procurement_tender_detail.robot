*** Settings ***
Library  		convert_page_values.py
Library         convert_cdb_values.py
Resource  		procurement_page_keywords.robot
Library         procurement_variables.py
Variables       procurement_variables.py



*** Keywords ***
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
	${value entered}  convert_cdb_values.convert_result  ${value entered}
    ${value cdb}  procurement_tender_detail.Отритами дані з ЦБД  ${field}
    ${status}  Run Keyword And Return Status  Should Be Equal  ${value entered}  ${value cdb}
 	Should Be True  ${status}  Oops! Помилка з даними для ${field}


Порівняти відображені дані з даними в ЦБД
    [Arguments]  ${field}
    ${value on page}  procurement_tender_detail.Отритами дані зі сторінки  ${field}
    ${value on page}  convert_cdb_values.convert_result  ${value on page}
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
	${selector}  Run Keyword If  ('documents' in """${field}""")
	...  procurement_variables.get_document_locator  ${field}  ELSE
	...  Set Variable  ${locators${field}}
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
    Натиснути "Завантажити кваліфікаційні документи"
    Дочекатись закінчення загрузки сторінки по елементу  ${circle loading}
    ${file name}  Wait Until Keyword Succeeds  20  2  Додати файл  1
    ${message}  Натиснути "Завантадити документи" та отримати відповідь
    keywords.Виконати дії відповідно до тексту повідомлення  ${message}
    Go Back
    [Return]  ${file name}


Розгорнути всі експандери
    ${selector down}  Set Variable  //*[contains(@class,"expander")]/i[contains(@class,"down")]
    ${count}  Get Element Count  ${selector down}
    Run Keyword If  ${count} != 0  Run Keywords
    ...  Repeat Keyword  ${count} times  Click Element  ${selector down}  AND
    ...  Розгорнути всі експандери