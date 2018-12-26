*** Keywords ***
Статус тендера повинен бути
    [Arguments]  ${status should}
    ${status is}  procurement_tender_detail.Отритами дані зі сторінки  ['status']
    Should Be Equal  '${status should}'  '${status is}'


Парсінг за необхідністью
    [Arguments]  ${field}  ${value}
    ${result}  convert_page_values  ${field}  ${value}
    [Return]  ${result}





Отримати локатор по назві поля
	[Arguments]  ${field}
	${selector}  Set Variable  ${${field}}
	[Return]  ${selector}


Дочекатись закінчення прийому пропозицій
    Reload Page
    ${tender end date}  procurement_tender_detail.Отритами дані зі сторінки  ['tenderPeriod']['endDate']
    Дочекатись дати  ${tender end date}


Дочекатись закінчення періоду прекваліфікації
    ${selector}  Set Variable  //*[@data-qa="prequalification"]//*[@data-qa="date-end"]
    Reload Page
    Wait Until Element Is Visible  ${selector}  30
    Sleep  1
    ${tender end date}  Get text  ${selector}
    Дочекатись дати  ${tender end date}


Дочекатись початку періоду перкваліфікації
    ${tender end date}  procurement_tender_detail.Отритами дані зі сторінки  ['tenderPeriod']['endDate']
    Дочекатись дати  ${tender end date}
    Дочекатися статусу тендера  Прекваліфікація


Натиснути "Завантажити кваліфікаційні документи"
    ${selector}  Set Variable  //*[@data-qa="qualif-documents-button"]
    Open Button  ${selector}


Натиснути "Завантадити документи" та отримати відповідь
    ${validation message}  Set Variable  //*[@class="ivu-modal-confirm"]//div[text()]
    ${selector}  Set Variable  //span[text()="Завантажити документи"]
    Click Element  ${selector}
    Wait Until Element Is Visible   ${validation message}  10
    ${status}  ${message}  Run Keyword And Ignore Error  Get Text  ${validation message}
	Capture Page Screenshot  ${OUTPUTDIR}/my_screen{index}.png
	[Return]  ${message}


Виконати дії відповідно до тексту повідомлення
	[Arguments]  ${message}
	${ok button}  Set Variable  //*[@class="ivu-modal-confirm"]//span[text()="OK"]
	Run Keyword If  "Кваліфікаційні документи відправлені" in """${message}"""  Click Element  ${ok button}
	...  ELSE  Fail  Look to message above
