*** Variables ***
${first tender webclient}         (//div[contains(@class,'selectable')]/table//tr[contains(@class,'Row')])[1]


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


Вибрати перший тендер
    Click Element  ${first tender webclient}
    Дочекатись закінчення загрузки сторінки(webclient)


###############################################
#				  Search					  #
###############################################
Пошук об'єкта у webclient по полю
	[Arguments]  ${field}  ${value}
	${find tender field}  Set Variable  xpath=(//tr[@class=' has-system-column'])[1]/td[count(//div[contains(text(), '${field}')]/ancestor::td[@draggable]/preceding-sibling::*)+1]//input
	Wait Until Keyword Succeeds  10  1  Click Element  ${find tender field}
	Input Text  ${find tender field}  ${value}
	${get}  Get Element Attribute  ${find tender field}  value
	${status}  Run Keyword And Return Status  Should Be Equal  ${get}  ${value}
	Run Keyword If  '${status}' == 'False'  Пошук об'єкта у webclient по полю  Номер тендер  ${value}
	Press Key  ${find tender field}  \\13
	Sleep  1


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
