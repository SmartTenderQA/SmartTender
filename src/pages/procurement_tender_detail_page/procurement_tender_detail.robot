*** Settings ***
Library  		convert_page_values.py
Resource  		keywords.robot


*** Variables ***
${['procedure-type']}                   //*[@data-qa="procedure-type"]//div[2]
${['status']}                           //*[@data-qa="status"]|//*[@data-qa="auctionStatus"]
${['title']}                            //*[@data-qa="main-block"]//*[@data-qa="title"]
${['description']}                      //*[@data-qa="main-block"]//*[@data-qa="description"]/span
${['tender_uaid']}                      //*[@data-qa="prozorro-number"]//a/span
${['item']['title']}                    //*[@data-qa="nomenclature-title"]
${['item']['city']}                     //*[@data-qa="nomenclature-delivery-address"]
${['item']['streetAddress']}            //*[@data-qa="nomenclature-delivery-address"]
${['item']['postal code']}              //*[@data-qa="nomenclature-delivery-address"]
${['item']['id']}                       //*[@data-qa="nomenclature-main-classification-code"]
${['item']['id title']}                 //*[@data-qa="nomenclature-main-classification-title"]
${['item']['unit']}                     //*[@data-qa="nomenclature-count"]
${['item']['quantity']}                 //*[@data-qa="nomenclature-count"]
${['tenderPeriod']['startDate']}        //*[@data-qa="tendering-period"]//*[@data-qa="date-start"]
${['tenderPeriod']['endDate']}          //*[@data-qa="tendering-period"]//*[@data-qa="date-end"]
${['enquiryPeriod']['endDate']}         //*[@data-qa="enquiry-period"]//*[@data-qa="date-end"]
${['value']['amount']}                  //*[@data-qa="budget-amount"]
${['value']['minimalStep']['percent']}  //*[@data-qa="budget-min-step"]//span[1]
${['contactPerson']['name']}            //*[text()="Контактна особа"]/following-sibling::div//*[@data-qa="value"]
${['prozorro-id']}						//*[@data-qa="prozorro-id"]//*[@data-qa="value"]
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
	${selector}  keywords.Отримати локатор по назві поля	${field}
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