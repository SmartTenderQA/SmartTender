*** Settings ***
Resource  ../../src/src.robot
Suite Setup     Авторизуватися організатором
Suite Teardown  Suite Postcondition
Test Setup      Check Prev Test Status
Test Teardown   Run Keyword If Test Failed  Capture Page Screenshot


#  robot --consolecolors on -L TRACE:INFO -d test_output -i create_tender suites/get_auction_href/test_esco_get_auction_href.robot
*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	Switch Browser  tender_owner
	Перейти у розділ (webclient)  Открытые закупки энергосервиса (ESCO) (тестовые)
	Відкрити вікно створення тендеру
	Заповнити endDate періоду пропозицій
	Заповнити minimalStep для tender
	Заповнити title для tender
  	Заповнити title_eng для tender
    Додати предмет в тендер
    Додати документ до тендара власником (webclient)
    Зберегти чернетку
    Оголосити закупівлю
    Пошук тендеру по title (webclient)  ${data['title']}
    Отримати tender_uaid та tender_href щойно стореного тендера
    Звебегти дані в файл


If skipped create tender
	[Tags]  get_tender_data
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Підготувати учасників
    [Tags]  create_tender  get_tender_data
    Close All Browsers
    Start  user1  provider1
    Start  user2  provider2
    Start  user3  provider3


Подати заявку на участь в тендері трьома учасниками
	[Tags]  create_tender  get_tender_data
	[Template]  Прийняти участь у тендері учасником
	provider1
	provider2
	provider3


Підтвердити прекваліфікацію для доступу до аукціону організатором
    [Tags]  create_tender  get_tender_data
    Дочекатись початку періоду перкваліфікації
    Підтвердити прекваліфікацію учасників


Підготувати учасників
    [Tags]  create_tender  get_tender_data
    Close All Browsers
    Start  user1  provider1
    Go to  ${data['tender_href']}


Отримати поcилання на участь в аукціоні для учасників
	[Tags]  create_tender  get_tender_data
	Перевірити отримання ссилки на участь в аукціоні  provider1


Підготувати учасників
    [Tags]  create_tender  get_tender_data
    Close All Browsers
    Start  viewer_test  viewer
    Go to  ${data['tender_href']}
    Start  Bened  tender_owner
    Go to  ${data['tender_href']}
    Start  user4  provider4
    Go to  ${data['tender_href']}


Неможливість отримати поcилання на участь в аукціоні
	[Tags]  create_tender  get_tender_data
	[Template]  Перевірити можливість отримати посилання на аукціон користувачем
	viewer
	tender_owner
	provider4




*** Keywords ***
Авторизуватися організатором
    Start  Bened  tender_owner
    ${data}  Create Dictionary
    Set Global Variable  ${data}


Заповнити endDate періоду пропозицій
    ${date}  get_time_now_with_deviation  40  minutes
    ${value}  Create Dictionary  endDate=${date}
    Set To Dictionary  ${data}  tenderPeriod  ${value}
    Заповнити текстове поле  //*[@data-name="D_SROK"]//input  ${date}


Заповнити minimalStep для tender
    ${minimal_step_percent}  random_number  1  3
    ${value}  Create Dictionary  percent=${minimal_step_percent}
    Set To Dictionary  ${data}  minimalStep  ${value}
    Заповнити текстове поле  xpath=//*[@data-name="MINSTEP_PERCENT"]//input   ${minimal_step_percent}


Заповнити title для tender
    ${text}  create_sentence  5
    ${title}  Set Variable  [ТЕСТУВАННЯ] ${text}
    Set To Dictionary  ${data}  title  ${title}
    Заповнити текстове поле  xpath=//*[@data-name="TITLE"]//input   ${title}


Заповнити title_eng для tender
    ${text_en}  create_sentence  5
    ${title_en}  Set Variable  [ТЕСТУВАННЯ] ${text_en}
    Set To Dictionary  ${data}  title_en  ${title_en}
    Заповнити текстове поле  xpath=//*[@data-name="TITLE_EN"]//input   ${title_en}


Додати предмет в тендер
    Заповнити description для item
    Заповнити description_eng для item
    Заповнити postalCode для item
    Заповнити streetAddress для item
    Заповнити locality для item


Заповнити description для item
    ${description}  create_sentence  5
    ${value}  Create Dictionary  description=${description}
    Set To Dictionary  ${data}  item  ${value}
    Заповнити текстове поле  xpath=(//*[@data-name='KMAT']//input)[1]  ${description}


Заповнити description_eng для item
    ${description_en}  create_sentence  5
    ${value}  Create Dictionary  description_en=${description_en}
    Set To Dictionary  ${data}  item  ${value}
    Заповнити текстове поле  xpath=//*[@data-name="RESOURSENAME_EN"]//input[1]  ${description_en}


Заповнити postalCode для item
    ${postal code}  random_number  10000  99999
    Заповнити текстове поле  xpath=//*[@data-name='POSTALCODE']//input  ${postal code}
    Set To Dictionary  ${data['item']}  postal code  ${postal code}


Заповнити streetAddress для item
    ${address}  create_sentence  1
    ${address}  Set Variable  ${address[:-1]}
    Заповнити текстове поле  xpath=//*[@data-name='STREETADDR']//input  ${address}
    Set To Dictionary  ${data['item']}  streetAddress  ${address}


Заповнити locality для item
    ${input}  Set Variable  //*[@data-name='CITY_KOD']//input[not(contains(@type,'hidden'))]
    ${selector}  Set Variable  //*[text()="Місто"]/ancestor::*[contains(@class, 'dhxcombo_hdrtext')]/../following-sibling::*/*[@class='dhxcombo_option']
    ${name}  Wait Until Keyword Succeeds  30  3  Вибрати та повернути елемент у випадаючому списку  ${input}  ${selector}
    Set To Dictionary  ${data['item']}  city  ${name}


Прийняти участь у тендері учасником
    [Arguments]  ${role}
    Switch Browser  ${role}
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Прийом пропозицій
    Sleep  2m
    Подати пропозицію esco учасником


Подати пропозицію esco учасником
	wait until keyword succeeds  3m  5s  Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною для першого лоту
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Заповнити поле з ціною для першого лоту
    Fill ESCO  1


Fill ESCO
    [Arguments]  ${number_of_lot}
    ${number_of_lot}  Evaluate  ${number_of_lot}+1
    input text  xpath=(${block}[${number_of_lot}]//input)[1]  1
    input text  xpath=(${block}[${number_of_lot}]//input)[2]  0
    input text  xpath=(${block}[${number_of_lot}]//input)[3]  95
    input text  xpath=(${block}[${number_of_lot}]//input)[6]  100


Дочекатись початку періоду перкваліфікації
    ${tender end date}  Get text  //*[@data-qa="tendering-period"]//*[@data-qa="date-end"]
    Дочекатись дати  ${tender end date}
    Дочекатися статусу тендера  Прекваліфікація


Дочекатись початку аукціону
    ${auction start date}  Get text  //*[@data-qa="auction-start"]//span[@data-qa]
    Дочекатись дати  ${auction start date}
    Дочекатися статусу тендера  Аукціон


Підтвердити прекваліфікацію учасників
    Close All Browsers
    Start  Bened  tender_owner
	Дочекатись закінчення загрузки сторінки(webclient)
	Перейти у розділ (webclient)  Открытые закупки энергосервиса (ESCO) (тестовые)
    Пошук тендеру по title (webclient)  ${data['title']}
    Натиснути кнопку Перечитать (Shift+F4)
    Wait Until Element Is Visible  //*[@data-placeid="CRITERIA"]//td[text()="Прекваліфікація"]
    ${count}  Get Element Count  //*[@title="Учасник"]/ancestor::div[3]//tr[contains(@class,"Row")]//td[@class and @title][1]
    :FOR  ${i}  IN RANGE  1  ${count}+1
    \  Надати рішення про допуск до аукціону учасника  ${i}
    Підтвердити закінчення розгляду учасників та перейти на наступну стадію



Надати рішення про допуск до аукціону учасника
    [Arguments]  ${i}
    ${selector}  Set Variable  (//*[@title="Учасник"]/ancestor::div[3]//tr[contains(@class,"Row")]//td[@class and @title][1])[${i}]
    Click Element  ${selector}
    Sleep  .5
    Натиснути кнопку Просмотр (F4)
    Дочекатись закінчення загрузки сторінки(webclient)
    Page Should Contain  Відіслати рішення
    Click Element  //*[@title="Допустити до аукціону"]
    Sleep  .5
    Click Element  (//*[@data-type="CheckBox"]//td/span)[1]
    Click Element  (//*[@data-type="CheckBox"]//td/span)[2]
    Sleep  .5
    Click Element  //*[@title="Відіслати рішення"]
    Погодитись з рішенням прекваліфікації
    Відмовитись від накладання ЕЦП на кваліфікацію


Погодитись з рішенням прекваліфікації
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Ви впевнені у своєму рішенні?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@id="IMMessageBoxBtnYes_CD"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


Відмовитись від накладання ЕЦП на кваліфікацію
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Накласти ЕЦП на кваліфікацію?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@id="IMMessageBoxBtnNo_CD"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


Підтвердити закінчення розгляду учасників та перейти на наступну стадію
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Розгляд учасників закінчено? Перевести закупівлю на наступну стадію?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@id="IMMessageBoxBtnYes_CD"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


Перевірити отримання ссилки на участь в аукціоні
    [Arguments]  ${role}
    Switch Browser  ${role}
    Дочекатись початку аукціону
    Отримати посилання на аукціон учасником  ${role}