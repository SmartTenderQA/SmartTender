*** Variables ***
${dozorro btn}                       xpath=//*[@data-qa="tabs"]//*[contains(text(),'Dozorro')]
${review add}                        xpath=//*[@type='button']/*[contains(text(), 'Залишити відгук')]
${review submit}                     xpath=//button[@type="submit"]
${review_list}                       xpath=(//div[@class="ivu-select-selection"]/span)[4]
${review_list_close}                 xpath=//*[@class='ivu-modal' and not(contains(@style,'display: none'))]//*[@class="ivu-modal-close"]


*** Keywords ***
Відкрити сторінку відгуки Dozorro
    Wait Until Keyword Succeeds  30  3  Click Element At Coordinates  ${dozorro btn}  -30  0
    Дочекатись закінчення загрузки сторінки


Натиснути кнопку залишити відгук
    Wait Until Keyword Succeeds  30s  5  Click Element  ${review add}
    Sleep  2s


Розкрити список відгуків
    Click Element  ${review_list}


Закрити список відгуків
    Wait Until Keyword Succeeds  30s  5  Click Element  ${review_list_close}


Відправити відгук
    Click Element  ${review submit}
    Дочекатись закінчення загрузки сторінки
    ${status}  Run Keyword And Return Status
    ...  Wait Until Element Is Not Visible  ${review submit}  10s
    Run Keyword If  '${status}' == 'False'  Відправити відгук
    Wait Until Element Is Not Visible  xpath=//*[@class="ivu-notice"]  10s


Подати коментар
    Click Element  xpath=//*[@type="submit"]
    Wait Until Element Is Not Visible  xpath=//*[@type="submit"]  20s
    Дочекатись закінчення загрузки сторінки
    Wait Until Element Is Not Visible  xpath=//*[@class="ivu-notice"]  20s
