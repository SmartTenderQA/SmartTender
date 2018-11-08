*** Keywords ***
###############################################
#					  F10					  #
###############################################
Відкрити вікно(F10)
	[Arguments]  ${field}  ${title}  ${additional_xpath}=${EMPTY}
	[Documentation]  Відкриває довідник по найменування поля ${field} та перевіряє ${title} відкритого вікна
	${input field}  Set Variable  ${additional_xpath}//*[contains(text(), "${field}")]/following-sibling::div
	Wait Until Keyword Succeeds  15  2  Click Element  ${input field}//input
	Sleep  1
	Click Element  ${input field}//td[contains(@title, 'F10')]
	Дочекатись закінчення загрузки сторінки(webclient)
	Wait Until Page Contains Element  //*[@class="dxpc-headerContent" and contains(., "${title}")]  10


Підтвердити вибір(F10)
	${ok button}  Set Variable  //*[@title="Вибрати"]
	Click Element  ${ok button}
	Дочекатись закінчення загрузки сторінки(webclient)
	Wait Until Page Does Not Contain Element  ${ok button}


Перевірити вибір(F10)
	[Arguments]  ${field}  ${text}
	${get}  Get Element Attribute  //*[contains(text(), "${field}")]/following-sibling::div//input  value
	Should Contain  ${get}  ${text}


###############################################
#					   F7					  #
###############################################
Натиснути додати(F7)
	[Arguments]  ${text}  ${additional_xpath}=${EMPTY}
	Click Element  ${additional_xpath}//*[@title="Додати (F7)"]
	Дочекатись закінчення загрузки сторінки(webclient)
	Wait Until Page Contains Element
	...  //*[contains(@id, "pcModalMode") and contains(., "${text}") and not(contains(@style, "visibility: hidden"))]


###############################################
#					   TAB					  #
###############################################
Активувати вкладку
	[Arguments]  ${text}  ${end_to_xpath}=${Empty}
	${current tab}  Set Variable  //*[contains(@class, "active-tab")]
	${current tab name}  Get Text  ${current tab}//td[text()]
	Run Keyword If  "${text}" != "${current tab name}"  Click Element  //li[contains(@class, "page-tab") and contains(., "${text}")]${end_to_xpath}
	Дочекатись закінчення загрузки сторінки(webclient)
	Wait Until Page Contains Element  ${current tab}//td[contains(text(), "${text}")]
	Sleep  2


#################
Натиснути "Додати"
	${button}  Set Variable  //*[@data-name="OkButton"]
	Wait Until Page Contains Element  ${button}
	Click Element  ${button}
	Дочекатись закінчення загрузки сторінки(webclient)
	Wait Until Element Is Not Visible  ${button}


Закрити вікно
	[Arguments]  ${title}
	${button}  Set Variable  //*[contains(@class, "headerText") and contains(text(), "${title}")]/../../div[contains(@class, 'close')]
	Wait Until Page Contains Element  ${button}
	Click Element  ${button}
	Wait Until Page Does Not Contain Element  ${button}


Закрити валідаційне вікно
	[Arguments]  ${title}  ${response}
	${button}  Set Variable  //*[contains(@class, "headerText") and contains(text(), "${title}")]/ancestor::*//span[contains(text(), '${response}')]
	Wait Until Page Contains Element  ${button}
	Click Element  ${button}
	Wait Until Element Is Not Visible  ${button}
	Sleep  3


Перевірити стадію тендера
	[Arguments]  ${stage}
	${get}  Get Text  //tr[contains(@class, "rowselected")]//td[4]
	Should Contain  ${get}  ${stage}



Змінити групу
	[Arguments]  ${text}
	Click Element  //*[contains(@title, 'Змінити групу: ')]
	Wait Until Page Contains Element  //*[contains(text(), "${text}")]
	Click Element  //*[contains(text(), "${text}")]

###############################################
#				Alt+Right					  #
###############################################
Натиснути надіслати вперед(Alt+Right)
	Click Element  //*[contains(@title, "Alt+Right")]
	Дочекатись закінчення загрузки сторінки(webclient)


###############################################
#				Shift+F4   					  #
###############################################
Натиснути кнопку Перечитать (Shift+F4)
    Click Element  //*[@title="Перечитать (Shift+F4)"]
    Дочекатись закінчення загрузки сторінки(webclient)


###############################################
#			       F4   					  #
###############################################
Натиснути кнопку Просмотр (F4)
    Click Element  //*[@title="Просмотр (F4)"]
    Дочекатись закінчення загрузки сторінки(webclient)


###############################################
#				Other   					  #
###############################################
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


Підтвердити повідомлення про перевищення бюджету за необхідністю
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Увага! Бюджет перевищує
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@class="message-box"]//*[.='Так']
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


Відмовитись у повідомленні про накладання ЕЦП на тендер
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Накласти ЕЦП на тендер?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@id="IMMessageBoxBtnNo"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


Підтвердити повідомлення про перевірку публікації документу за необхідністю
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  перевірте публікацію Вашого документу
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@title="OK"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


Натиснути ОК у фільтрі "Умова відбору тендерів" за необхідністю
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Умова відбору тендерів
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@title="OK"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)




