*** Keywords ***
Статус тендера повинен бути
    [Arguments]  ${status should}
    ${status is}  procurement_tender_detail.Отритами дані зі сторінки  ['status']
    Should Be Equal  '${status should}'  '${status is}'


Парсінг за необхідністью
    [Arguments]  ${field}  ${value}
    ${result}  convert_page_values  ${field}  ${value}
    [Return]  ${result}


Перевірити коректність даних на сторінці
    [Arguments]  ${field}
    ${value}  procurement_tender_detail.Отритами дані зі сторінки  ${field}
    Should Be Equal  ${value}  ${data${field}}


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