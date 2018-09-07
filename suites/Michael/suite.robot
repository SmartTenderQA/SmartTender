*** Settings ***
Resource  ../../src/src.robot
Test Teardown  Test Postcondition
Suite Setup  Suite Precondition
Suite Teardown  Suite Postcondition

*** Variables ***
${webclient_start_page}      https://webclient.it-enterprise.com/client/(S(hmdkfxfl5ow4ejt5ptiszejh))/?proj=K_BUHETLA2_UK&Iconset=Master&win=1&tz=3
${cpmb_start_page}           http://192.168.1.205/wsmbdemo_all/client



*** Test Cases ***
Запуск проекта MASTER
  Натиснути адміністрування
  Розгорнути користувачі
  Натиснути Користувачі та групи
  Перевірити відкриту сторінку


*** Keywords ***
Suite Precondition
  ${start_page}  Отримати стартовий URL
  Start
  Дочекатись закінчення загрузки сторінки(webclient)
  Авторизуватися
  Run Keyword If  "${start_from}" == "webclient"  Run Keywords
  ...  Click Element  css=.dxmLite_DevEx li
  ...  AND  Дочекатись закінчення загрузки сторінки(webclient)


Отримати стартовий URL
  ${start_page}  Run Keyword If  "${start_from}" == "webclient"  Set Variable  ${webclient_start_page}
  ...  ELSE  Set Variable  ${cpmb_start_page}
  Set Global Variable  ${start_page}
  [Return]  ${start_page}


Test Postcondition
  Run Keyword If Test Failed  Capture Page Screenshot


Авторизуватися
  Run Keyword  Вибрати Ім'я користувача ${start_from}
  Ввести пароль
  Натиснути Увійти


Вибрати Ім'я користувача webclient
  Click Element  //*[@data-name="Login"]//td[@id]
  Sleep  1
  Click Element  //*[contains(text(), "Главный бухгалтер")]


Вибрати Ім'я користувача cpmb
  Click Element  //*[@data-name="Login"]//td[@id]
  Sleep  1
  Click Element  //*[contains(text(), "Головний бухгалтер")]


Ввести пароль
  No Operation


Натиснути Увійти
  Click Element  //div[@class='dxb' and contains(., 'Увійти')]
  Дочекатись закінчення загрузки сторінки(webclient)


Натиснути адміністрування
  Wait Until Element Is Visible  //*[@data-key="AD.ADM"]
  Sleep  2
  Click Element  //*[@data-key="AD.ADM"]
  Дочекатись закінчення загрузки сторінки(webclient)


Натиснути користувачі
  Click Element  //div[@data-key and contains(., "Користувачi")]


Натиснути Користувачі та групи webclient
  Wait Until Element Is Visible  //div[@data-key and contains(., "Користувачі та групи")]
  Sleep  2
  Double Click Element  //div[@data-key and contains(., "Користувачі та групи")]
  Дочекатись закінчення загрузки сторінки(webclient)
  Sleep  3
  Wait Until Page Does Not Contain Element  //div[@data-key and contains(., "Користувачі та групи")]


Натиснути Користувачі та групи cpmb
  Wait Until Element Is Visible  //div[@data-itemkey and contains(., "Користувачі та групи")]
  Sleep  2
  Double Click Element  //div[@data-itemkey and contains(., "Користувачі та групи")]
  Дочекатись закінчення загрузки сторінки(webclient)
  Sleep  3
  Wait Until Page Does Not Contain Element  //div[@data-itemkey and contains(., "Користувачі та групи")]


Перевірити відкриту сторінку
  Element Should Be Visible  //*[@data-placeid="TBN"]//td[text()="Користувачi"]
  Element Should Be Visible  //*[@class="dx-vam" and contains(text(), "РОЗРОБНИК")]


Натиснути Користувачі та групи
  Run Keyword  Натиснути Користувачі та групи ${start_from}


Розгорнути користувачі
  Run Keyword If  "${start_from}" == "webclient"  Натиснути користувачі
