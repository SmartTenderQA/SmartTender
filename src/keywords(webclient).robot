*** Keywords ***
Натиснути OkButton
	${button}  Set Variable  //*[@data-name="OkButton"]
	Wait Until Page Contains Element  ${button}
	Click Element  ${button}
	Дочекатись закінчення загрузки сторінки(webclient)
	#Wait Until Element Is Not Visible  ${button}







Змінити групу
	[Arguments]  ${text}
	Click Element  //*[contains(@title, 'Змінити групу: ')]
	Wait Until Page Contains Element  //*[@class="dx-vam" and text()="${text}"]
	Click Element  //*[@class="dx-vam" and text()="${text}"]


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


Відмовитись у повідомленні про накладання ЕЦП на тендер
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Накласти ЕЦП на тендер?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@id="IMMessageBoxBtnNo"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


Натиснути ОК у фільтрі "Умова відбору тендерів" за необхідністю
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Умова відбору тендерів
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  //*[@title="Очистити"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)
    ...  AND  Click Element  //*[@title="OK"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


