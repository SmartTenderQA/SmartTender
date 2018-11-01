*** Settings ***
Library     Faker/faker.py


*** Keywords ***
Відкрити бланк подачі заявки
  Reload Page
  Дочекатись закінчення загрузки сторінки(skeleton)
  Click Element  xpath=//button[@type='button']//*[contains(text(), 'Взяти участь')]


Додати файл для подачі заявки
  Wait Until Page Contains Element  xpath=//input[@type='file' and @accept]
  ${file_path}  ${file_name}  ${file_content}=  create_fake_doc
  Choose File  xpath=//input[@type='file' and @accept]  ${file_path}


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


Підтвердити заявку
	[Arguments]  ${tender_uaid}  ${dgf}=${Empty}
	Run Keyword If  '${site}' == 'test'  Run Keywords
	...  Go To  http://test.smarttender.biz/ws/webservice.asmx/ExecuteEx?calcId=_QA.ACCEPTAUCTIONBIDREQUEST&args={"IDLOT":"${tender_uaid}","SUCCESS":"true"}&ticket=
	...  AND  Wait Until Page Contains  True
	...  AND  Go Back
	...  ELSE
	...  Підтвердити заявки на продуктиві організатором  ${dgf}



Підтвердити заявки на продуктиві організатором
	[Arguments]  ${type}=ФГВ
    ${save location}  Get Location
	Go To  https://smarttender.biz/webclient/(S(53j1ylozgwqn1knunzwbpbvr))/?tz=3
	Дочекатись закінчення загрузки сторінки(webclient)
	Змінити групу  Администратор ЭТП (стандартный доступ) (E_ADM_STND)
	Відкрити вікно підтвердження заявок
	Активувати вкладку  Заявки на участие в торгах ${type}  /preceding-sibling::*[1]
	Пошук об'єкта у webclient по полю  ${data['title']}  Найменування лоту
	Підтвердити всі заявки  ${type}
	Go To  ${save location}


Відкрити вікно підтвердження заявок
	Wait Until Page Contains Element  //*[@title="Заявки на участие в аукционах Prozorro.Sale"]
	Click Element  //*[@title="Заявки на участие в аукционах Prozorro.Sale"]
	Дочекатись закінчення загрузки сторінки(webclient)


Підтвердити всі заявки
	[Arguments]  ${type}=ФГВ
	${tab}  Set Variable  (//td[contains(text(), 'Заявки на участие в торгах ${type}')]/ancestor::td[@id])[last()]//div[contains(@id, 'MainSted2PageControl') and @style='']
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
	\  Ігнорувати гарантійний внесок
	\  Element Should Contain  ${row}[${i}]//td[2]  Принята


Ігнорувати гарантійний внесок
	Run Keyword And Ignore Error
	...  Закрити валідаційне вікно  Внимание! Гарантийного взноса недостаточно для подачи предложения!  Принять
