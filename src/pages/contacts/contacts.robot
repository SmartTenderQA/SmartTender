*** Variables ***
${button messages}                   xpath=//*[contains(@class,'fa-bell')]


*** Keywords ***
Зайти на сторінку povidomlenya
	Click Element  ${button messages}
	Location Should Contain  /povidomlenya/


Перевірити відсутність дзвіночка(povidomlenya)
	Run Keyword And Expect Error  Element with locator '${button messages}' not found.  Зайти на сторінку povidomlenya

