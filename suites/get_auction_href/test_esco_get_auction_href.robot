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
	test_esco_propery.Створити тендер


If skipped create tender
	[Tags]  get_tender_data
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Підготувати учасників до участі в тендері
    [Tags]  create_tender  get_tender_data
    Close All Browsers
    Start  user1  provider1
    Start  user2  provider2
    Start  user3  provider3


Подати заявку на участь в тендері трьома учасниками
	:FOR  ${user}  IN  provider1  provider2  provider3
	\  Прийняти участь у тендері учасником  ${user}


Підтвердити прекваліфікацію для доступу до аукціону організатором
    Дочекатись початку періоду перкваліфікації
    Підтвердити прекваліфікацію учасників
    Підтвердити організатором формування протоколу розгляду пропозицій
    Перейти до стадії Аукціон


Підготувати учасників для отримання посилання на аукціон
    Close All Browsers
    Start  user1  provider1
    Go to  ${data['tender_href']}


Отримати поcилання на участь в аукціоні для учасників
	Дочекатись закінчення прийому пропозицій
	Дочекатися статусу тендера  Аукціон
    Перевірити отримання ссилки на участь в аукціоні  provider1


Підготувати користувачів для отримання ссилки на аукціон
    Close All Browsers
    Start  test_viewer  viewer
    Start  Bened  tender_owner
    Start  user4  provider4


Неможливість отримати поcилання на участь в аукціоні
	[Template]  Перевірити можливість отримати посилання на аукціон користувачем
	viewer
	tender_owner
	provider4



*** Keywords ***
Авторизуватися організатором
    Start  Bened  tender_owner
    ${data}  Create Dictionary
    Set Global Variable  ${data}


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


Відкрити браузер під роллю організатора та знайти потрібний тендер
    Close All Browsers
    Start  Bened  tender_owner
	Дочекатись закінчення загрузки сторінки(webclient)
	Перейти у розділ (webclient)  Открытые закупки энергосервиса (ESCO) (тестовые)
    Пошук тендеру по title (webclient)  ${data['title']}


Перевірити отримання ссилки на участь в аукціоні
    [Arguments]  ${role}
    Switch Browser  ${role}
    Натиснути кнопку "До аукціону"
	${auction_participate_href}  Отримати URL для участі в аукціоні
	Wait Until Keyword Succeeds  60  3  Перейти та перевірити сторінку участі в аукціоні  ${auction_participate_href}


Перейти та перевірити сторінку участі в аукціоні
	[Arguments]  ${auction_href}
	Go To  ${auction_href}
	Location Should Contain  bidder_id=
	Підтвердити повідомлення про умови проведення аукціону
	Wait Until Page Contains Element  //*[@class="page-header"]//h2  30
	Sleep  2
	Element Should Contain  //*[@class="page-header"]//h2  ${data['tender_uaid']}
	Element Should Contain  //*[@class="lead ng-binding"]  ${data['title']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['description']}
	Element Should Contain  //h4  Вхід на даний момент закритий.


Перевірити можливість отримати посилання на аукціон користувачем
	[Arguments]  ${role}
	Switch Browser  ${role}
	Go to  ${data['tender_href']}
	${auction_participate_href}  Run Keyword And Expect Error  *  Run Keywords
	...  Натиснути кнопку "До аукціону"
	...  AND  Отримати URL для участі в аукціоні


Підтвердити організатором формування протоколу розгляду пропозицій
    Click Element  (//div[contains(@class,'selectable')]/table//tr[contains(@class,'Row')])[1]
    Дочекатись закінчення загрузки сторінки(webclient)
    Натиснути кнопку Перечитать (Shift+F4)
    ${status}  Run Keyword And Return Status
    ...  Wait Until Element Is Visible  //*[@class='dxr-lblContent']/*[contains(text(), 'Надіслати вперед')]
    Run Keyword If  '${status}' != 'True'  Run Keywords
    ...  Sleep  60
    ...  AND  Підтвердити організатором формування протоколу розгляду пропозицій
    Click Element  //*[@class='dxr-lblContent']/*[contains(text(), 'Надіслати вперед')]
    Дочекатись закінчення загрузки сторінки(webclient)
    Підтвердити формування протоколу розгляду пропозицій за необхідністью


Підтвердити формування протоколу розгляду пропозицій за необхідністью
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Сформувати протокол розгляду пропозицій?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@id="IMMessageBoxBtnYes_CD"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


Перейти до стадії Аукціон
    Оновити дані першого в списку тендера (webclient)
    ${status}  Run Keyword And Return Status  Натиснути кнопку "Надіслати вперед"
    Run Keyword If  '${status}' != 'True'  Перейти до стадії Аукціон
    ${status}  Перевірити що стадія аукціон (webclient)
    Run Keyword If  '${status}' != 'True'  Перейти до стадії Аукціон


Перевірити що стадія аукціон (webclient)
    ${first tender}  set variable  (//div[contains(@class,'selectable')]/table//tr[contains(@class,'Row')])[1]
    ${stage}  get text  ${first tender}//td[count(//div[contains(text(), 'Стадія')]/ancestor::td[@draggable]/preceding-sibling::*)+1]
    ${status}  Run Keyword And Return Status  Should Contain  ${stage}  Аукціон
    [Return]  ${status}


