*** Settings ***


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
	[Arguments]  ${text}
	${current tab}  Set Variable  //*[contains(@class, "active-tab")]
	${current tab name}  Get Text  ${current tab}//td[text()]
	Run Keyword If  "${text}" != "${current tab name}"  Click Element  //li[contains(@class, "page-tab") and contains(., "${text}")]
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
	${button}  Set Variable
	...  //*[contains(@class, "headerText") and contains(text(), "Зберегти документ?")]/ancestor::*//span[contains(text(), '${response}')]
	Wait Until Page Contains Element  ${button}
	Click Element  ${button}
	Wait Until Element Is Not Visible  ${button}
	Sleep  3


Перевірити стадію тендера
	[Arguments]  ${stage}
	${get}  Get Text  //tr[contains(@class, "rowselected")]//td[4]
	Should Contain  ${get}  ${stage}


###############################################
#				Alt+Right					  #
###############################################
Натиснути надіслати вперед(Alt+Right)
	Click Element  //*[contains(@title, "Alt+Right")]
	Дочекатись закінчення загрузки сторінки(webclient)
