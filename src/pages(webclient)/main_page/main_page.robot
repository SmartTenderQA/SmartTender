*** Keywords ***
Отримати tender_uaid вибраного тендера
    ${uaid}   Get Text  ${first tender}/a
    [Return]  ${uaid}


Отримати tender_href вибраного тендера
    ${href}  Get Element Attribute
    ...  ${first tender}/following-sibling::td/a|${first tender}/preceding-sibling::td/a  href
    [Return]  ${href}


Отримати посилання на вибраний тендер по значку "Планета"
	Click Element  //tr[contains(@class, "rowselected")]//td[3]
	Wait Until Page Contains Element  //*[@id="pcCustomDialog_PW-1"]//a
	${value}  Get Element Attribute  //*[@id="pcCustomDialog_PW-1"]//a  onclick
	${href}  ${ticket}  get_tender_href_for_commercial_owner  ${value}
	Go To  ${href}${ticket}
	Location Should Contain  ?ticket=
	[Return]  ${href}


Вибрати тендер за номером (webclient)
    [Arguments]  ${i}
    Click Element  xpath=(//div[contains(@class,'selectable')]/table//tr[contains(@class,'Row')])[${i}]//td[2]
    Дочекатись закінчення загрузки сторінки(webclient)


Вибрати лот за номером (webclient)
    [Arguments]  ${i}
    Click Element  xpath=(//*[@data-placeid="LOTS"]//td[text()="Лот"])[${i}]
    Дочекатись закінчення загрузки сторінки(webclient)


Порахувати кількість торгів (webclient)
    ${n}  Get Element Count  xpath=(//div[contains(@class,'selectable')]/table//tr[contains(@class,'Row')])//td[2]
    Run Keyword If  '${n}' == '0'  Не знайдено жодного тендера!
    [Return]  ${n}


###############################################
#				  Search					  #
###############################################
Пошук об'єкта у webclient по полю
	[Arguments]  ${field}  ${value}
	${find tender field}  Set Variable  xpath=((//tr[@class=' has-system-column'])[1]/td[count(//div[contains(text(), '${field}')]/ancestor::td[@draggable]/preceding-sibling::*)+1]//input)[1]
	Wait Until Keyword Succeeds  10  1  Click Element  ${find tender field}
	Clear Element Text  ${find tender field}
	Sleep  .5
	Input Text  ${find tender field}  ${value}
	#${get}  Get Element Attribute  ${find tender field}  value
	#${status}  Run Keyword And Return Status  Should Be Equal  ${get}  ${value}
	#Run Keyword If  '${status}' == 'False'  Пошук об'єкта у webclient по полю  Номер тендер  ${value}
	Press Key  ${find tender field}  \\13
	Дочекатись закінчення загрузки сторінки(webclient)


Пошук об'єкта у webclient по полю ФГИ
	[Arguments]  ${field}  ${value}
	${count}  Get Element Count  (//*[@class="gridbox"])[2]//div[contains(text(), "${field}")]/ancestor::td[@draggable]/preceding-sibling::*
	${find tender field}  Set Variable  ((//*[@class="gridbox"])[2]//*[@class=" has-system-column"]//td)[${count}+1]
	Click Element  xpath=${find tender field}//input
	Input Text  xpath=${find tender field}//input  ${value}
	${get}  Get Element Attribute  xpath=${find tender field}//input  value
	${status}  Run Keyword And Return Status  Should Be Equal  ${get}  ${value}
	Run Keyword If  '${status}' == 'False'  Пошук об'єкта у webclient по полю ФГИ  ${value}  ${field}
	Press Key  xpath=${find tender field}//input  \\13
	Sleep  1


Знайти тендер організатором по title
    [Arguments]  ${title}
    Capture Page Screenshot
    Пошук об'єкта у webclient по полю  Узагальнена назва закупівлі  ${title}
    ${status}  Run Keyword And Return Status  Вибрати тендер за номером (webclient)  1
    Run Keyword If  '${status}' == 'False'  Run Keywords
    ...  Натиснути кнопку Перечитать (Shift+F4)  AND
    ...  Знайти тендер організатором по title  ${title}


Дочекатись стадії закупівлі
    [Arguments]  ${stage}
    ${selector}  Set Variable
    ...  xpath=//*[@data-placeid="TENDER"]//tr[contains(@class,"Row")]/td[count(//div[contains(text(), 'Стадія')])+1]
    Натиснути кнопку Перечитать (Shift+F4)
    ${now}  Get Text  ${selector}
    ${status}  Run Keyword And Return Status  Should Contain  ${now}  ${stage}
    Run Keyword If  '${status}' == 'False'  Run Keywords
    ...  Sleep  5  AND  Дочекатись стадії закупівлі  ${stage}
