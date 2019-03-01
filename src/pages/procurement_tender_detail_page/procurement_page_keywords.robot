*** Keywords ***
Статус тендера повинен бути
    [Arguments]  ${status should}
    ${status is}  procurement_tender_detail.Отритами дані зі сторінки  ['status']
    Should Be Equal  '${status should}'  '${status is}'


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
    Wait Until Element Is Visible  ${selector}  30
    Open Button  ${selector}


Натиснути "Завантадити документи" та отримати відповідь
    ${validation message}  Set Variable  //*[@class="ivu-modal-confirm"]//div[text()]
    ${selector}  Set Variable  //span[text()="Завантажити документи"]
    Click Element  ${selector}
    Wait Until Element Is Visible   ${validation message}  10
    ${status}  ${message}  Run Keyword And Ignore Error  Get Text  ${validation message}
	capture page screenshot  ${OUTPUTDIR}/my_screen{index}.png
	[Return]  ${message}


Виконати дії відповідно до тексту повідомлення
	[Arguments]  ${message}
	${ok button}  Set Variable  //*[@class="ivu-modal-confirm"]//span[text()="OK"]
	Run Keyword If  "Кваліфікаційні документи відправлені" in """${message}"""  Click Element  ${ok button}
	...  ELSE  Fail  Look to message above
