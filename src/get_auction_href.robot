*** Keywords ***
Натиснути кнопку "Додати документи"
    Reload Page
    ${selector}  Set Variable  //a[contains(@class, "btn-success") and contains(text(), "Додати документи")]
    Wait Until Element Is Visible  ${selector}
    Click Element  ${selector}


Натиснути кнопку "Підтвердити пропозицію"
    Wait Until Element Is Visible  //span[contains(text(), "Підтвердити пропозицію")]
    Click Element  //span[contains(text(), "Підтвердити пропозицію")]
    Дочекатись закінчення загрузки сторінки
    Wait Until Element Is Visible  //span[contains(text(), "Так")]
    Click Element  //span[contains(text(), "Так")]
    Дочекатись закінчення загрузки сторінки
    Wait Until Element Is Visible  //a[contains(text(), "Перейти")]
    Open Button  //a[contains(text(), "Перейти")]


Дочекатись початку періоду перкваліфікації
    Reload Page
    ${tender end date}  Отритами дані зі сторінки  ['tenderPeriod']['endDate']
    Дочекатись дати  ${tender end date}
    Дочекатися статусу тендера  Прекваліфікація


Дочекатись закінчення прийому пропозицій
    Reload Page
    ${tender end date}  Отритами дані зі сторінки  ['tenderPeriod']['endDate']
    Дочекатись дати  ${tender end date}


Дочекатись закінчення періоду прекваліфікації
    ${selector}  Set Variable  //*[@data-qa="prequalification"]//*[@data-qa="date-end"]
    Reload Page
    Wait Until Element Is Visible  ${selector}  30
    Sleep  1
    ${tender end date}  Get text  ${selector}
    Дочекатись дати  ${tender end date}
