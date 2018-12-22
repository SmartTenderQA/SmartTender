*** Settings ***
Library  		convert_page_values.py
Resource  		keywords.robot


*** Variables ***
${['procedure-type']}                   //*[@data-qa="procedure-type"]//div[2]
${['prozorro-number']}                  //*[@data-qa='prozorro-number']//a/span



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


Отритами дані зі сторінки
	[Arguments]  ${field}
	${selector}  Set Variable  	${locators${field}}
	Wait Until Element Is Visible  ${selector}  10
	${value}  Get Text  ${selector}
	${field value}  Парсінг за необхідністью  ${field}  ${value}
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
    Додати файл  1
    ${message}  Натиснути "Завантадити документи" та отримати відповідь
    keywords.Виконати дії відповідно до тексту повідомлення  ${message}
    Go Back