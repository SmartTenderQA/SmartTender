*** Keywords ***
Оголосити закупівлю
    Натиснути надіслати вперед(Alt+Right)
    Закрити валідаційне вікно (Так/Ні)  Оголосити закупівлю  Так
    Ignore WebClient Error
    Run Keyword And Ignore Error
    ...  Закрити валідаційне вікно (Так/Ні)  Увага! Бюджет перевищує  Так
    Підтвердити повідомлення про перевірку публікації документу за необхідністю
    Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на тендер?  Ні


Оголосити тендер
	Натиснути надіслати вперед(Alt+Right)
    Закрити валідаційне вікно (Так/Ні)  Оголосити  Так
	Підтвердити повідомлення про перевірку публікації документу за необхідністю
	Ignore WebClient Error
	Перевірка на успішність публікації тендера


Опублікувати процедуру
    #Вибрати перший тендер
    Натиснути кнопку Перечитать (Shift+F4)
    Натиснути надіслати вперед(Alt+Right)
    Закрити валідаційне вікно (Так/Ні)  Опублікувати процедуру?  Так
    Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на тендер?  Ні


Відкрити вікно створення тендеру     #TODO переписати кейворд
  Wait Until Keyword Succeeds  30  3  Run Keywords
  ...  Click Element  xpath=//a[@title="Додати (F7)"]
  ...  AND  Wait Until Element Is Not Visible  ${webClient loading}  120
  ...  AND  Wait Until Keyword Succeeds  120  3  Element Should Be Visible  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table


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
    Click Element  //*[@title="Перечитать (Shift+F4)"]|//*[@title="Перечитати (Shift+F4)"]
    Дочекатись закінчення загрузки сторінки(webclient)


###############################################
#					  F10					  #
###############################################
Відкрити вікно(F10)
	[Arguments]  ${field}  ${title}  ${additional_xpath}=${EMPTY}
	[Documentation]  Відкриває довідник по найменування поля ${field} та перевіряє ${title} відкритого вікна
	${input field}  Set Variable  ${additional_xpath}//*[contains(text(), "${field}")]/following-sibling::div
	Wait Until Keyword Succeeds  15  2  Click Element  ${input field}//input
	Sleep  1
	Дочекатись закінчення загрузки сторінки(webclient)
	Wait Until Keyword Succeeds  10  2  Click Element  ${input field}//td[contains(@title, 'F10')]
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


###############################################
#			       F4   					  #
###############################################
Натиснути кнопку Просмотр (F4)
    ${selector}  Set Variable  //*[@title="Просмотр (F4)"]|//*[@title="Перегляд (F4)"]
    Wait Until Element Is Visible  ${selector}  15
    Click Element  ${selector}
    Дочекатись закінчення загрузки сторінки(webclient)


###############################################
#			       Other  					  #
###############################################
Натиснути додати (додавання тендеру)
    ${selector}  Set Variable  //a[@title="Додати"]//span[text()="Додати"]
    Wait Until Element Is Visible  ${selector}  15
    Click Element  ${selector}
    Дочекатись закінчення загрузки сторінки(webclient)
    Element Should Not Be Visible  ${selector}


Натиснути додати (додавання предмету)
    ${selector}  Set Variable  //*[@data-name="GRID_ITEMS_HIERARCHY"]//*[@title="Додати"]
    Wait Until Element Is Visible  ${selector}  15
    Click Element  ${selector}
    Дочекатись закінчення загрузки сторінки(webclient)


Натиснути OkButton
	${button}  Set Variable  //*[@data-name="OkButton"]|//a[@title="Зберегти"]|//a[@title="OK"]
	Wait Until Page Contains Element  ${button}
	Click Element  ${button}
	Дочекатись закінчення загрузки сторінки(webclient)
	#Wait Until Element Is Not Visible  ${button}


Натиснути кнопку "Кваліфікація"
    ${selector}  Set Variable  //a[@title="Кваліфікація"]|//a[@title="Квалификация"]
    Wait Until Element Is Visible  ${selector}  15
    Click Element  ${selector}
    Дочекатись закінчення загрузки сторінки(webclient)


Натиснути кнопку "Прикріпити договір"
    ${selector}  Set Variable  //a[@title="Прикріпити договір"]
    Wait Until Element Is Visible  ${selector}  15
    Click Element  ${selector}
    Дочекатись закінчення загрузки сторінки(webclient)


Натиснути кнопку "Підписати договір"
    ${selector}  Set Variable  //a[@title="Підписати договір"]
    Wait Until Element Is Visible  ${selector}  15
    Click Element  ${selector}
    Дочекатись закінчення загрузки сторінки(webclient)


Натиснути кнопку "Заповнити ціни за одиницю товару"
    ${selector}  Set Variable  //a[@title="Заповнити ціни за одиницю товару"]
    Wait Until Element Is Visible  ${selector}  15
    Click Element  ${selector}
    Дочекатись закінчення загрузки сторінки(webclient)


Натиснути кнопку "Коригувати рамкову угоду"
    ${selector}  Set Variable  //a[@title="Коригувати рамкову угоду"]
    Wait Until Element Is Visible  ${selector}  15
    Click Element  ${selector}
    Дочекатись закінчення загрузки сторінки(webclient)


Натиснути кнопку "Заключить рамочное соглашение"
    ${selector}  Set Variable  //a[@title="Заключить рамочное соглашение"]
    Wait Until Element Is Visible  ${selector}  15
    Click Element  ${selector}
    Дочекатись закінчення загрузки сторінки(webclient)


Натиснути кнопку "Скасування тендеру"
    ${selector}  Set Variable  //a[@title="Скасування тендеру"]
    Wait Until Element Is Visible  ${selector}  15
    Click Element  ${selector}
    Дочекатись закінчення загрузки сторінки(webclient)


Натиснути кнопку "Отмена лота"
    ${selector}  Set Variable  //a[@title="Отмена лота"]
    Wait Until Element Is Visible  ${selector}  15
    Click Element  ${selector}
    Дочекатись закінчення загрузки сторінки(webclient)