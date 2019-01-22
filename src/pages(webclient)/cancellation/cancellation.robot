*** Keywords ***
Вказати причину скасування тендера
    ${input}  Set Variable  //*[@data-name="reason"]//textarea
    ${text}  create_sentence  5
    Element Text Should Be
    ...  //span[contains(@class, "headerText") and contains(@id, "ModalMode")]
    ...  Скасування тендеру
    Input Text  ${input}  ${text}
    [Return]  ${text}


Вказати причину скасування лота
    ${input}  Set Variable  //*[@data-name="reason"]//textarea
    ${text}  create_sentence  5
    Element Text Should Be
    ...  //span[contains(@class, "headerText") and contains(@id, "ModalMode")]
    ...  Скасування лоту
    Input Text  ${input}  ${text}
    [Return]  ${text}


Вкласти документ "Протокол скасування"
    Click Element  //div[@title="Додати"]|//div[@title="Добавить"]
    Дочекатись закінчення загрузки сторінки(webclient)
    Wait Until Page Contains Element  xpath=//*[@type='file'][1]
    ${doc}=  create_fake_doc
    ${path}  Set Variable  ${doc[0]}
    ${name}  Set Variable  ${doc[1]}
    Choose File  xpath=//*[@type='file'][1]  ${path}
    Click Element  xpath=(//span[.='ОК'])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    Page Should Contain  ${name}
    [Return]  ${name}


Вибрати "Тип скасування"
    [Arguments]  ${type}
    Click Element  //*[text()="Тип скасування"]/following-sibling::table
    Wait Until Element Is Visible  //*[text()="${type}"]
    Click Element  //*[text()="${type}"]