*** Settings ***
Resource        keywords.robot


*** Keywords ***
Заповнити "Дата закінч. прийому"
    [Arguments]  ${date}
    ${date input}  Set Variable  //*[@data-name="D_SROK"]//input
    Очистити поле з датою  ${date input}
    Clear Element Text  ${date input}
    Sleep  .5
	Input Text  ${date input}  ${date}
	Sleep  .5
	Click Element  ${date input}
	Sleep  .5
	${get}  Get Element Attribute  ${date input}  value
	Should Be Equal  ${get}  ${date}


Вибрати довілну категорію тендера
    Відкрити вікно(F10)  Категорія тендера  Класифікація
	${classification_name}  Вибрати довільну ЗЕЛЕНУ класифікацію
	Підтвердити вибір(F10)
	Перевірити вибір(F10)  Категорія тендера  ${classification_name}
    [Return]  ${classification_name}


Вибрати вид тендера
	[Arguments]  ${tender_type}
	Заповнити поле за допомогою(F10)
	...  Вид тендер
	...  Прості довідники
	...  ${tender_type}
    [Return]  ${tender_type}


Заповнити "Найм. тендера"
    [Arguments]  ${text}
    ${textarea}  Set Variable  //*[contains(text(), "Найм. тендера")]/following-sibling::table//textarea
    Input Text  ${textarea}  ${text}
	Sleep  .5
	Click Element  ${textarea}
	Sleep  .5
	${get}  Get Element Attribute  ${textarea}  value
	Should Be Equal  ${get}   ${text}


Створити классифікатор ресурсів
	Відкрити вікно(F10)  Лот  Тендер. Классификатор ресурсов  //*[@id="pcModalMode_PW-1"]
	Натиснути додати(F7)  Додавання. Класифікатор ресурсів  //*[@id="pcModalMode_PW-1"]
	${lot_name}  Заповнити поле найменування для класифікатора
	${unit_name}  Вибрати одиниці виміру для классифікатора ресурсів
	Натиснути OkButton
	Підтвердити вибір(F10)
	${amount}  Вказати кількість одиниць виміру для классифікатора ресурсів
	Run Keyword And Ignore Error  Натиснути OkButton
	[Return]  ${lot_name}  ${unit_name}  ${amount}


Закрити вікно додавання лотів
	${selector}  Set Variable  //*[@id="pcModalMode_PWH-1"]//*[@alt="Close"]
	Click Element  ${selector}
	Wait Until Element Is Not Visible  ${selector}  30