*** Keywords ***
Заповнити "Обговорення закупівлі до"
    [Arguments]  ${date}
    ${selector}  set variable  //*[@data-name="DDM"]//input
    Заповнити текстове поле  ${selector}  ${date}


Заповнити "Прийом пропозицій з"
    [Arguments]  ${date}
    ${selector}  set variable  //*[@data-name="D_SCH"]//input
    Заповнити текстове поле  ${selector}  ${date}


Заповнити "Прийом пропозицій по"
    [Arguments]  ${date}
    ${selector}  set variable  //*[@data-name="D_SROK"]//input
    Заповнити текстове поле  ${selector}  ${date}


Заповнити "Очікувана вартість закупівлі"
    [Arguments]  ${date}
    ${selector}  set variable  //*[@data-name="INITAMOUNT"]//input
    Заповнити текстове поле  ${selector}  ${date}


Заповнити "Мінімальний крок аукціону"
    [Arguments]  ${date}
    ${selector}  set variable  //*[@data-name="MINSTEP_PERCENT"]//input
    Заповнити текстове поле  ${selector}  ${date}


Заповнити "Узагальнена назва закупівлі"
    [Arguments]  ${date}
    ${selector}  set variable  //*[@data-name="TITLE"]//input
    Заповнити текстове поле  ${selector}  ${date}


Заповнити "Примітки до закупівлі"
    [Arguments]  ${date}
    ${selector}  set variable  //*[@data-name="DESCRIPT"]//textarea
    Заповнити текстове поле  ${selector}  ${date}


Заповнити "Назва предмета закупівлі"
    [Arguments]  ${date}
    ${selector}  set variable  //*[@data-name='KMAT']//input[not(contains(@type,'hidden'))]
    Заповнити текстове поле  ${selector}  ${date}


Заповнити "Об'єм постачання"
    [Arguments]  ${date}
    ${selector}  set variable  //*[@data-name='QUANTITY']//input
    Заповнити текстове поле  ${selector}  ${date}


Заповнити "Класифікація"
    ${input field}  Set Variable  //*[@data-name="MAINCLASSIFICATION"]//input[not(contains(@type,'hidden'))]
    Wait Until Keyword Succeeds  15  2  Click Element  ${input field}
	Sleep  1
	Дочекатись закінчення загрузки сторінки(webclient)
	Click Element  ${input field}/ancestor::tr/td[@title="Вибір з довідника (F10)"]
	Дочекатись закінчення загрузки сторінки(webclient)
	${id}  Вибрати довільну ЗЕЛЕНУ класифікацію
	Підтвердити вибір(F10)
	[Return]  ${id}


Заповнити "Класифікація"
    ${input field}  Set Variable  //*[@data-name='EDI']//input[not(contains(@type,'hidden'))]
    Wait Until Keyword Succeeds  15  2  Click Element  ${input field}
	Sleep  1
	Дочекатись закінчення загрузки сторінки(webclient)
	Click Element  ${input field}/ancestor::tr/td[@title="Вибір з довідника (F10)"]
	Дочекатись закінчення загрузки сторінки(webclient)
	${id}  Вибрати довільну ЗЕЛЕНУ класифікацію
	Підтвердити вибір(F10)
	[Return]  ${id}
