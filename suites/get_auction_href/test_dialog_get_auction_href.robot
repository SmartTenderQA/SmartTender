*** Settings ***
Resource  ../../src/src.robot
Suite Setup     Авторизуватися організатором
Suite Teardown  Suite Postcondition
Test Setup      Check Prev Test Status
Test Teardown   Run Keyword If Test Failed  Capture Page Screenshot


#  robot --consolecolors on -L TRACE:INFO -d test_output -e get_tender suites/get_auction_href/test_dialog_get_auction_href.robot
*** Test Cases ***
Створити тендер
	[Tags]  create_tender
	test_dialog_propery.Створити тендер


If skipped create tender
	[Tags]  get_tender
	${json}  Get File  ${OUTPUTDIR}/artifact.json
	${data}  conver json to dict  ${json}
	Set Global Variable  ${data}


Підготувати учасників до участі в тендері
    Close All Browsers
    Start  user1  provider1
    Start  user2  provider2
    Start  user3  provider3


Подати заявку на участь в тендері трьома учасниками на 1-му етапі
	:FOR  ${user}  IN  provider1  provider2  provider3
	\  Прийняти участь у тендері учасником на 1-му етапі  ${user}


Підтвердити прекваліфікацію для доступу до аукціону організатором
    Дочекатись початку періоду перкваліфікації
    Підтвердити прекваліфікацію учасників


Виконати дії для переведення тендера на 2-ий етап
    Підтвердити організатором формування протоколу розгляду пропозицій
    Start  user1  provider1
    Go to  ${data['tender_href']}
    Дочекатись закінчення періоду прекваліфікації
    Дочекатися статусу тендера  Очікування рішення організатора
    Перейти до другої фази
    Дочекатися учасником на рішення організатора
    Перейти до другого етапу
    Отримати tender_uaid та tender_href щойно стореного тендера
    Опублікувати процедуру


Підготувати учасників до участі в тендері на 2-ий етап
    Close All Browsers
    Start  user1  provider1
    Start  user2  provider2
    Start  user3  provider3


Подати заявку на участь в тендері трьома учасниками на 2-му етапі
	:FOR  ${user}  IN  provider1  provider2  provider3
	\  Прийняти участь у тендері учасником  ${user}


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
    Run Keyword If  '${role}' == 'provider1'  Sleep  3m
    Подати пропозицію учасником


Прийняти участь у тендері учасником на 1-му етапі
    [Arguments]  ${role}
    Switch Browser  ${role}
    Go to  ${data['tender_href']}
    Дочекатися статусу тендера  Прийом пропозицій
    Run Keyword If  '${role}' == 'provider1'  Sleep  3m
    Подати пропозицію учасником на 1-му етапі


Подати пропозицію учасником
	Перевірити кнопку подачі пропозиції
	Заповнити поле з ціною  1  1
    Додати файл  1
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Подати пропозицію учасником на 1-му етапі
	Перевірити кнопку подачі пропозиції
	Run Keyword And Ignore Error  Підтвердити відповідність
	Подати пропозицію
    Go Back


Відкрити браузер під роллю організатора та знайти потрібний тендер
    Close All Browsers
    Start  Bened  tender_owner
	Дочекатись закінчення загрузки сторінки(webclient)
	Перейти у розділ (webclient)  Конкурентний діалог(тестові)
    Пошук тендеру по title (webclient)  ${data['title']}


Підтвердити формування протоколу розгляду пропозицій за необхідністью
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Сформувати протокол розгляду пропозицій?
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  xpath=//*[@id="IMMessageBoxBtnYes_CD"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


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


Перейти до другої фази
    Switch Browser  tender_owner
    Wait Until Keyword Succeeds  5  1  Click Element  //*[@class='dxr-lblContent']/*[contains(text(), 'Надіслати вперед')]
    Дочекатись закінчення загрузки сторінки(webclient)
    ${status}  Run Keyword And Return Status  Підтвердити перехід до другої фази за необхідністью
    Run Keyword If  '${status}' == 'False'  Перейти до другої фази


Підтвердити перехід до другої фази за необхідністью
    Wait Until Page Contains  Перейти до другої фази?  10
    Click Element  xpath=//*[@id="IMMessageBoxBtnYes_CD"]
    Дочекатись закінчення загрузки сторінки(webclient)


Дочекатися учасником на рішення організатора
    Switch Browser  provider1
    Дочекатися статусу тендера  Завершено
    Close Browser


Перейти до другого етапу
    Switch Browser  tender_owner
    Натиснути кнопку Перечитать (Shift+F4)
    ${status}  Run Keyword And Return Status  Wait Until Element Is Visible  //*[@title="До 2-го етапу"]
    Run Keyword If  '${status}' == 'False'  Перейти до другого етапу
    Click Element  //*[@title="До 2-го етапу"]
    Дочекатись закінчення загрузки сторінки(webclient)
    ${status}  Run Keyword And Return Status  Wait Until Page Contains  Умова відбору тендерів
    Run Keyword If  '${status}' == 'True'  Run Keywords
    ...  Click Element  //*[@title="OK"]
    ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


Опублікувати процедуру
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
    Підтвердити публікацію процедури


Підтвердити публікацію процедури
    Wait Until Page Contains  Опублікувати процедуру?  10
    Click Element  xpath=//*[@id="IMMessageBoxBtnYes_CD"]
    Дочекатись закінчення загрузки сторінки(webclient)


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
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['quantity']}
	Element Should Contain  //*[contains(@ng-repeat, 'items')]  ${data['item']['unit']}
	Element Should Contain  //h4  Вхід на даний момент закритий.


Перевірити можливість отримати посилання на аукціон користувачем
	[Arguments]  ${role}
	Switch Browser  ${role}
	Go to  ${data['tender_href']}
	${auction_participate_href}  Run Keyword And Expect Error  *  Run Keywords
	...  Натиснути кнопку "До аукціону"
	...  AND  Отримати URL для участі в аукціоні