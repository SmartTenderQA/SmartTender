*** Settings ***
Resource  ../../src/src.robot
Test Teardown  Test Postcondition
Suite Setup  Suite Precondition
Suite Teardown  Close All Browsers



#  robot --consolecolors on -L TRACE:INFO -d test_output -v hub:None -v user:comm_tender_owner suites/commercial/create_tender.robot
*** Test Cases ***
Створити тендер
	[Tags]  create_tende
	Перейти у розділ (webclient)  Управління тендерами
	Натиснути додати(F7)  Додавання. Тендери
	Заповинити поле дата закінчення прийому пропозиції
	Заповнити поле категорія тендера
	Заповинити поле найменування тендера
	Заповнити поле вид тендера
	Натиснути "Додати" та змінити дату за необхідністю


Створити лоти
	[Tags]  create_tender
	actions.Активувати вкладку  Лоти
	Натиснути додати(F7)  Додавання лотів
	Створити довільний классифікатор ресурсів
	Закрити вікно додавання лотів
	Перевірити створений лот


Перевести тендер на другий єтап
	[Tags]  create_tender
	actions.Активувати вкладку  Тендери
	Натиснути надіслати вперед(Alt+Right)
	Закрити вікно  Запит на комерційну пропозицію_
	Закрити валідаційне вікно  Зберегти документ?  Так
	Підтвердити адреси електронної пошти
	Перевірити стадію тендера  2. Підготовка запиту


Перевести тендер на третій єтап
	[Tags]  create_tender
	actions.Активувати вкладку  Тендери
	Натиснути надіслати вперед(Alt+Right)
	Перевірити стадію тендера  3.Затвердження запиту


Перевести тендер на четвертий єтап
	[Tags]  create_tender
	actions.Активувати вкладку  Тендери
	Натиснути надіслати вперед(Alt+Right)
	Перевірити стадію тендера  4.Прийом комерційних пропозицій (Web-тендер online)


Перевірити посилання до на тендер організатором
	[Tags]  create_tender
	Натиснути на планету потрібного тендеру
	Log  ${data}






*** Keywords ***
Suite Precondition
	Open Browser In Grid  ${user}
	Авторизуватися  ${user}
	Створити словник  data


Test Postcondition
	Log Location
	Run Keyword If Test Failed  Capture Element Screenshot  //body
	Log  ${data}


##########################################################
Заповинити поле дата закінчення прийому пропозиції
	${date}  smart_get_time  3  d
	${date}  no_weekend  ${date}
	Wait Until Keyword Succeeds
	...  30
	...  2
	...  Заповнити "Дата закінч. прийому"  ${date}
	Set To Dictionary  ${data}  end_date   ${date}


Заповнити поле категорія тендера
    ${classification_name}  Вибрати довілну категорію тендера
	Set To Dictionary  ${data}  classification_name  ${classification_name}


Заповинити поле найменування тендера
	${text}  create_sentence  4
	Заповнити "Найм. тендера"  ${text}
	Set To Dictionary  ${data}  tender_name  ${text}


Заповнити поле вид тендера
	${tender_type}  Вибрати вид тендера  Відкриті торги. Аукціон
	Set To Dictionary  ${data}  tender_type  ${tender_type}


############################################################
Створити довільний классифікатор ресурсів
	${lot_name}  ${unit_name}  ${amount}  Створити классифікатор ресурсів
	${list}  Create List
	Set To Dictionary  ${data}  lots  ${list}
	${lot}  Create Dictionary
	Append To List  ${data.lots}  ${lot}
	Set To Dictionary  ${data.lots[0]}  lot_name  ${lot_name}
	Set To Dictionary  ${data.lots[0]}  unit_name  ${unit_name}
	Set To Dictionary  ${data.lots[0]}  unit_amount  ${amount}


Перевірити створений лот
	actions.Активувати вкладку  Лоти
	Первірити title створеного лоту
	Первірити unit_amount створеного лоту
	Первірити unit_name створеного лоту


Первірити title створеного лоту
	${get}  Get Text  (//*[@class="objbox selectable objbox-scrollable"])[2]//tr[1+1]//td[3]
	Should Be Equal  ${get}  ${data.lots[0].lot_name}


Первірити unit_amount створеного лоту
	${get}  Get Text  (//*[@class="objbox selectable objbox-scrollable"])[2]//tr[1+1]//td[4]
	${int}  Evaluate  str(int(${get}))
	Should Contain  ${int}  ${data.lots[0].unit_amount}


Первірити unit_name створеного лоту
	${get}  Get Text  (//*[@class="objbox selectable objbox-scrollable"])[2]//tr[1+1]//td[5]
	Should Contain  ${data.lots[0].unit_name}  ${get}


Натиснути на планету потрібного тендеру
    ${href}  Отримати посилання на вибраний тендер по значку "Планета"
	Set To Dictionary  ${data}  href  ${href}


Підтвердити адреси електронної пошти
	actions.Натиснути OkButton


Натиснути "Додати" та змінити дату за необхідністю
	${status}  Run Keyword And Return Status  Натиснути додати (додавання тендеру)
	Run Keyword If  '${status}' == 'False'  Змінити дату


Змінити дату
	${new_date}  Отримати дату закінчення прийому пропозиції з валідаційного повідомлення
	Wait Until Keyword Succeeds
	...  30
	...  2
	...  Заповнити "Дата закінч. прийому"  ${new_date}
	Set To Dictionary  ${data}  end_date   ${new_date}
	Натиснути "Додати" та змінити дату за необхідністю


Отримати дату закінчення прийому пропозиції з валідаційного повідомлення
	${get}  Get Text  css=.message-content
	${new_date}  Evaluate  re.search(r'[\\d.]+', '''${get}''').group(0)  re
	[Return]  ${new_date}


