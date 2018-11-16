*** Variables ***
${['title']}                            //*[@data-qa="main-block"]//*[@data-qa="title"]
${['description']}                      //*[@data-qa="main-block"]//*[@data-qa="description"]/span
${['tender_uaid']}                      //*[@data-qa="prozorro-number"]//a/span
${['item']['description']}              //*[@data-qa="nomenclature-title"]
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



*** Keywords ***
Перевірити коректність даних на сторінці
    [Arguments]  ${field}  ${selector}=${${field}}
    ${value}  Get Text  ${selector}
    ${field value}  Парсінг за необхідністью  ${field}  ${value}
    Should Be Equal  ${field value}  ${data${field}}


Парсінг за необхідністью
    [Arguments]  ${field}  ${value}
    ${result}  convert_page_values  ${field}  ${value}
    [Return]  ${result}