*** Keywords ***
#################################################################
#							Web									#
#################################################################
Відкрити бланк подачі заявки
  Reload Page
  Дочекатись закінчення загрузки сторінки(skeleton)
  Click Element  xpath=//button[@type='button']//*[contains(text(), 'Взяти участь')]
  Дочекатись закінчення загрузки сторінки


Додати файл для подачі заявки
	${selector}  Set Variable  //input[@type='file' and @accept]
	Wait Until Page Contains Element  ${selector}
	${n}  Get Element Count  ${selector}/..
	:FOR  ${i}  IN RANGE  ${n}
    \  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
	\  Choose File  ${selector}  ${file_path}


Ввести ім'я для подачі заявки
  Input Text  xpath=//*[contains(text(), "Ім'я")]/following-sibling::*//input  Тостер


Підтвердити відповідність для подачі заявки
  Select Checkbox  xpath=//*[@class="group-line"]//input


Відправити заявку для подачі пропозиції та закрити валідаційне вікно
  Click Element  xpath=//button[@class="ivu-btn ivu-btn-primary pull-right ivu-btn-large"]
  Wait Until Page Contains  Ваша заявка відправлена!  120
  Sleep  3
  Click Element  xpath=//*[contains(text(), 'Ваша заявка відправлена!') or contains(text(), 'Ваша заявка розглядається!')]/ancestor::*[@class='ivu-modal-content']//a
  Wait Until Element Is Not Visible  xpath=//*[contains(text(), 'Ваша заявка відправлена!')]/ancestor::*[@class='ivu-modal-content']//a


#################################################################
#						Web Client								#
#################################################################
Пройти кваліфікацію для подачі пропозиції
	Відкрити бланк подачі заявки
	Додати файл для подачі заявки
	Ввести ім'я для подачі заявки
	Підтвердити відповідність для подачі заявки
	Відправити заявку для подачі пропозиції та закрити валідаційне вікно


Підтвердити заявку
	[Arguments]  ${tender_uaid/tender_type}  ${type}=для ФГВ
	Run Keyword If  '${site}' == 'test'  Run Keywords
	...  Execute Javascript  window.open('http://test.smarttender.biz/ws/webservice.asmx/ExecuteEx?calcId=_QA.ACCEPTAUCTIONBIDREQUEST&args={"IDLOT":"${data['tender_id']}","SUCCESS":"true"}&ticket=');
	...  AND  Select Window  New
	...  AND  Wait Until Page Contains Element  css=.text
	...  AND  Element Should Contain  css=.text  True
	...  AND  Close Window
	...  AND  Select Window  undefined
	...  ELSE
	...  Підтвердити заявки на продуктиві організатором ${type}


Підтвердити заявки на продуктиві організатором для ФГВ
    ${save location}  Get Location
	Go To  https://smarttender.biz/webclient/(S(53j1ylozgwqn1knunzwbpbvr))/?tz=3
	Дочекатись закінчення загрузки сторінки(webclient)
	Змінити групу  Администратор ЭТП (стандартный доступ) (E_ADM_STND)
	Відкрити вікно підтвердження заявок
	Wait Until Keyword Succeeds  20  2  Пошук об'єкта у webclient по полю  Найменування лоту  ${data['title']}
	Підтвердити всі заявки для ФГВ
	Go To  ${save location}


Підтвердити заявки на продуктиві організатором для ФГИ
    ${save location}  Get Location
	Go To  https://smarttender.biz/webclient/(S(53j1ylozgwqn1knunzwbpbvr))/?tz=3
	Дочекатись закінчення загрузки сторінки(webclient)
	Змінити групу  Администратор ЭТП (стандартный доступ) (E_ADM_STND)
	Відкрити вікно підтвердження заявок
	Активувати вкладку  Заявки на участие в торгах ФГИ  /preceding-sibling::*[1]
	Wait Until Keyword Succeeds  20  2  Пошук об'єкта у webclient по полю ФГИ  Найменування лоту  ${data['title']}
	Підтвердити всі заявки для ФГИ
	Go To  ${save location}


Відкрити вікно підтвердження заявок
	Wait Until Page Contains Element  //*[@title="Заявки на участие в аукционах Prozorro.Sale"]
	Wait Until Keyword Succeeds  16  2  Click Element  //*[@title="Заявки на участие в аукционах Prozorro.Sale"]
	Дочекатись закінчення загрузки сторінки(webclient)


Підтвердити всі заявки для ФГВ
	${tab}  Set Variable  (//*[@class="gridbox"])[1]
	${row}  Set Variable  ${tab}//tr[contains(@class, 'Row')]
	${n}  Get Element Count  ${row}
	:FOR  ${i}  IN RANGE  1  ${n}+1
	\  Click Element  ${row}[${i}]//img[contains(@src, 'checkBoxUnchecked')]
	\  Дочекатись закінчення загрузки сторінки(webclient)
	\  Click Element  ${row}[${i}]//img[contains(@src, 'checkBoxUnchecked')][last()]
	\  Дочекатись закінчення загрузки сторінки(webclient)
	\  Підтвердити заявку для ФГВ  ${i}  ${row}


Підтвердити заявку для ФГВ
    [Arguments]  ${i}  ${row}
    Sleep  30
	Click Element  ${row}[${i}]//img[contains(@src, 'qe0102')]
	Дочекатись закінчення загрузки сторінки(webclient)
	Click Element  //*[@id='pcModalMode_PW-1' and contains(., 'Решение')]//li[contains(., 'Принять')]
	Дочекатись закінчення загрузки сторінки(webclient)
	${status}  Run Keyword And Return Status  Element Should Contain  ${row}[${i}]//td[2]  Принята
	Run Keyword If  ${status} == ${false}  Закрити валідаційне вікно  Тендер, на який ви хочете подати пропозицію не існує! Перевірте правильність посилання  ОК
	Run Keyword If  ${status} == ${false}  Підтвердити заявку для ФГВ  ${i}  ${row}


Підтвердити всі заявки для ФГИ
	${tab}  Set Variable  (//*[@class="gridbox"])[2]
	${row}  Set Variable  ${tab}//tr[contains(@class, 'Row')]
	${n}  Get Element Count  ${row}
	:FOR  ${i}  IN RANGE  1  ${n}+1
	\  Click Element  ${row}[${i}]//img[contains(@src, 'checkBoxUnchecked')]
	\  Дочекатись закінчення загрузки сторінки(webclient)
	\  Click Element  ${row}[${i}]//img[contains(@src, 'checkBoxUnchecked')][last()]
	\  Дочекатись закінчення загрузки сторінки(webclient)
	\  Sleep  180
	\  Click Element  ${row}[${i}]//img[contains(@src, 'qe0102')]
	\  Дочекатись закінчення загрузки сторінки(webclient)
	\  Click Element  //*[@id='pcModalMode_PW-1' and contains(., 'Решение')]//li[contains(., 'Принять')]
	\  Дочекатись закінчення загрузки сторінки(webclient)
	\  Закрити валідаційне вікно  Внимание! Гарантийного взноса недостаточно для подачи предложения!  Так
	\  Element Should Contain  ${row}[${i}]//td[2]  Принята
