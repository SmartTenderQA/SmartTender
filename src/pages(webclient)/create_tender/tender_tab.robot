*** Settings ***
Resource        keywords.robot


*** Keywords ***
Заповнити "Кількість переможців"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="MAXWINNERCOUNT"]//input
    Заповнити поле  ${selector}  ${value}


Заповнити "Срок рамкової угоди" місяців
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="DURAGRMONTH"]//input
    Заповнити поле  ${selector}  ${value}


Заповнити "Призвіще"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="FAMENG"]//input
    Заповнити поле  ${selector}  ${value}


Заповнити "Імя"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="NAMENG"]//input
    Заповнити поле  ${selector}  ${value}


Заповнити "По батькові"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="OTCHENG"]//input
    Заповнити поле  ${selector}  ${value}


Заповнити "Обговорення закупівлі до"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="DDM"]//input
	Clear input By JS  ${selector}
    Input Text  ${selector}  ${value}
    Press Key  ${selector}  \\13
    Sleep  1
    ${get}  Get Element Attribute  ${selector}  value
    ${status}  Run Keyword And Return Status  Should Be Equal  ${get}  ${value}
    Run Keyword If  ('${status}' == 'False') and ('${site}' == 'test')
    ...  Заповнити "Обговорення закупівлі до"  ${value}


Заповнити "Прийом пропозицій з"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="D_SCH"]//input
    Clear input By JS  ${selector}
    Input Text  ${selector}  ${value}
    Press Key  ${selector}  \\13
    Sleep  1
    ${get}  Get Element Attribute  ${selector}  value
    ${status}  Run Keyword And Return Status  Should Be Equal  ${get}  ${value}
    Run Keyword If  ('${status}' == 'False') and ('${site}' == 'test')
    ...  Заповнити "Прийом пропозицій з"  ${value}


Заповнити "Прийом пропозицій по"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="D_SROK"]//input
    Clear input By JS  ${selector}
    Input Text  ${selector}  ${value}
    Press Key  ${selector}  \\13
    Sleep  1
    ${get}  Get Element Attribute  ${selector}  value
    ${status}  Run Keyword And Return Status  Should Be Equal  ${get}  ${value}
    Run Keyword If  ('${status}' == 'False') and ('${site}' == 'test')
    ...  Заповнити "Прийом пропозицій по"  ${value}


Заповнити "Очікувана вартість закупівлі"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="INITAMOUNT"]//input
    Заповнити текстове поле  ${selector}  ${value}


Заповнити "Очікувана вартість закупівлі" для лоту
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="LOT_INITAMOUNT"]//input
    ${amount field}  Set Variable  //*[@data-name="LOT_MINSTEP"]//input
    Заповнити текстове поле  ${selector}  ${value}
    ${amount}  Get Element Attribute  ${amount field}  value
    [Return]  ${amount}


Заповнити "Мінімальний крок аукціону"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="MINSTEP_PERCENT"]//input
    Заповнити текстове поле  ${selector}  ${value}
    ${amount}  Get Element Attribute  //*[@data-name="MINSTEP"]//input  value
    [Return]  ${amount}


Заповнити "Мінімальний крок аукціону" для лоту
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="LOT_MINSTEP_PERCENT"]//input
    Заповнити текстове поле  ${selector}  ${value}
    ${amount}  Get Element Attribute  //*[@data-name="LOT_MINSTEP"]//input  value
    [Return]  ${amount}


Заповнити "Узагальнена назва закупівлі"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="TITLE"]//input
    Заповнити текстове поле  ${selector}  ${value}


Заповнити "Узагальнена назва закупівлі ENG"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="TITLE_EN"]//input
    Заповнити текстове поле  ${selector}  ${value}


Заповнити "Примітки до закупівлі"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="DESCRIPT"]//textarea
    Заповнити текстове поле  ${selector}  ${value}


Вибрати "Контактна особа"
    ${input field}  Set Variable  //*[@data-name="N_KDK_M"]//input[not(contains(@type,'hidden'))]
    Wait Until Keyword Succeeds  15  2  Click Element  ${input field}
	Дочекатись закінчення загрузки сторінки(webclient)
	Click Element  ${input field}/ancestor::tr/td[@title="Вибір з довідника (F10)"]
	Дочекатись закінчення загрузки сторінки(webclient)
	Вибрати довільну персону з довідника персоналу
    ${person}  Get Element Attribute  ${input field}  value
    [Return]  ${person}


Заповнити "Контактна особа"
    [Arguments]  ${name}
    ${selector}  set variable  //*[@data-name="N_KDK_M"]//input[not(contains(@type,'hidden'))]
    Заповнити текстове поле  ${selector}  ${name}


Заповнити "Назва предмета закупівлі"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name='KMAT']//input[not(contains(@type,'hidden'))]
    Заповнити текстове поле  ${selector}  ${value}


Заповнити "Назва предмета закупівлі ENG"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="RESOURSENAME_EN"]//input[not(contains(@type,'hidden'))]
    Заповнити текстове поле  ${selector}  ${value}


Заповнити "Об'єм постачання"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name='QUANTITY']//input
    Заповнити текстове поле  ${selector}  ${value}


Заповнити "Класифікація"
    ${input field}  Set Variable  //*[@data-name="MAINCLASSIFICATION"]//input[not(contains(@type,'hidden'))]
    Wait Until Keyword Succeeds  15  2  Click Element  ${input field}
	Дочекатись закінчення загрузки сторінки(webclient)
	Click Element  ${input field}/ancestor::tr/td[@title="Вибір з довідника (F10)"]
	Дочекатись закінчення загрузки сторінки(webclient)
	${id}  Вибрати довільну ЗЕЛЕНУ класифікацію
	Підтвердити вибір(F10)
	${id}  Get Element Attribute  ${input field}  value
	[Return]  ${id}


Заповнити "Одиниця виміру"
    ${input field}  Set Variable  //*[@data-name='EDI']//input[not(contains(@type,'hidden'))]
    Wait Until Keyword Succeeds  15  2  Click Element  ${input field}
	Sleep  1
	Дочекатись закінчення загрузки сторінки(webclient)
	Wait Until Keyword Succeeds  10  2  Click Element  ${input field}/ancestor::tr/td[@title="Вибір з довідника (F10)"]
	Дочекатись закінчення загрузки сторінки(webclient)
	${unit}  Вибрати довільну одиницю виміру
	Підтвердити вибір(F10)
	${unit}  Get Element Attribute  ${input field}  value
	[Return]  ${unit}


Заповнити "Індекс"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name='POSTALCODE']//input
    Заповнити текстове поле  ${selector}  ${value}


Заповнити "Вулиця"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name='STREETADDR']//input
    Заповнити текстове поле  ${selector}  ${value}


Заповнити "Місто"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name='CITY_KOD']//input[not(contains(@type,'hidden'))]
    Заповнити текстове поле  ${selector}  ${value}
    [Return]  ${value}


Заповнити "Строк поставки з"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="DDATEFROM"]//input
    Clear input By JS  ${selector}
    Input Text  ${selector}  ${value}
    Press Key  ${selector}  \\13
    Sleep  1
    ${get}  Get Element Attribute  ${selector}  value
    ${status}  Run Keyword And Return Status  Should Contain Any  ${value}  ${get}
    Run Keyword If  ('${status}' == 'False') and ('${site}' == 'test')
    ...  Заповнити "Строк поставки з"  ${value}


Заповнити "Строк поставки по"
    [Arguments]  ${value}
    ${selector}  set variable  //*[@data-name="DDATETO"]//input
    Clear input By JS  ${selector}
    Input Text  ${selector}  ${value}
    Press Key  ${selector}  \\13
    Sleep  1
    ${get}  Get Element Attribute  ${selector}  value
    ${status}  Run Keyword And Return Status  Should Contain Any  ${value}  ${get}
    Run Keyword If  ('${status}' == 'False') and ('${site}' == 'test')
    ...  Заповнити "Строк поставки по"  ${value}


