*** Settings ***
Resource  ../../src/src.robot
Suite Setup  Precondition
Suite Teardown  Postcondition
Test Setup  Stop The Whole Test Execution If Previous Test Failed
Test Teardown  Run Keyword If Test Failed  Run Keywords  Capture Page Screenshot
...  AND  Log Location
...  AND  Log  ${data}
...  AND  debug


*** Variables ***

#Запуск
#robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None suites/small_privatization/dzk.robot
*** Test Cases ***
Створити аукціон
	Натиснути особистий кабінет
	dzk_auction.Натиснути створити аукціон
	dzk_auction.Заповнити всі обов'язкові поля


#	start_page.Натиснути На торговельний майданчик
#	old_search.Активувати вкладку ФГИ
#	small_privatization_search.Активувати вкладку  Реєстр об'єктів приватизації
#	small_privatization_search.Вибрати режим сторінки об'єктів приватизації  Кабінет
#	Run Keyword If  '${site}' == 'test'
#	...  small_privatization_search.Активувати перемемик тестового режиму на  вкл
#	small_privatization_search.Натиснути створити  об'єкт
#	small_privatization_object.Заповнити всі обов'язкові поля
#	small_privatization_object.Прикріпити документ
#	small_privatization_object.Натиснути кнопку зберегти
#	small_privatization_object.Опублікувати об'єкт у реєстрі
#	small_privatization_object.Отримати UAID для Об'єкту
#	Log To Console  object-UAID=${data['object']['UAID']}


*** Keywords ***
Precondition
    Start  USER_DZK  tender_owner


Postcondition
    Log  ${data}
    Close All Browsers


Натиснути особистий кабінет
	Page Should Contain Element  ${personal account}
	Click Element  ${personal account}
	Дочекатись закінчення загрузки сторінки