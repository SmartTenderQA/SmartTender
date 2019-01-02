*** Keywords ***
Додати документ до тендара власником (webclient)
    Перейти на вкладку документи (webclient)
    Додати документ власником


Перейти на вкладку документи (webclient)
    Wait Until Keyword Succeeds  30  2  Click Element  xpath=//*[contains(@id,'TabControl_T4T')]//*[contains(text(),'Документи')]
    Wait Until Page Contains Element  xpath=//*[@data-name="ADDATTACHMENT_L"]  15


Додати документ власником
    Click Element  xpath=//*[@data-name="BTADDATTACHMENT"]/div
    Дочекатись закінчення загрузки сторінки(webclient)
    Wait Until Page Contains Element  xpath=//*[@type='file'][1]
    ${doc}=  create_fake_doc
    ${path}  Set Variable  ${doc[0]}
    ${name}  Set Variable  ${doc[1]}
    Choose File  xpath=//*[@type='file'][1]  ${path}
    Click Element  xpath=(//span[.='ОК'])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    Page Should Contain  ${name}
