*** Keywords ***
Оголосити закупівлю
    Натиснути надіслати вперед(Alt+Right)
    Закрити валідаційне вікно (Так/Ні)  Оголосити закупівлю  Так
    Ignore WebClient Error
    Run Keyword And Ignore Error
    ...  Закрити валідаційне вікно (Так/Ні)  Увага! Бюджет перевищує  Так
    Підтвердити повідомлення про перевірку публікації документу за необхідністю
    Закрити валідаційне вікно (Так/Ні)  Накласти ЕЦП на тендер?  Ні


Оголосити тендер
	Натиснути надіслати вперед(Alt+Right)
    Закрити валідаційне вікно (Так/Ні)  Оголосити  Так
	Підтвердити повідомлення про перевірку публікації документу за необхідністю
	Ignore WebClient Error
	Перевірка на успішність публікації тендера


Опублікувати процедуру
    #Вибрати перший тендер
    Натиснути кнопку Перечитать (Shift+F4)
    Натиснути надіслати вперед(Alt+Right)
    Закрити валідаційне вікно (Так/Ні)  Опублікувати процедуру?  Так


Перейти до стадії закупівлі (webclient)
    [Arguments]  ${stage name}
    #Вибрати перший тендер
    Натиснути кнопку Перечитать (Shift+F4)
    Натиснути кнопку "Надіслати вперед"
    ${current name}  Get Text  ${first tender webclient}//td[count(//div[contains(text(), 'Стадія')]/ancestor::td[@draggable]/preceding-sibling::*)+1]
    Should Contain  ${stage name}  ${current name}


Відкрити вікно створення тендеру     #TODO переписати кейворд
  Wait Until Keyword Succeeds  30  3  Run Keywords
  ...  Click Element  xpath=//a[@title="Додати (F7)"]
  ...  AND  Wait Until Element Is Not Visible  ${webClient loading}  120
  ...  AND  Wait Until Keyword Succeeds  120  3  Element Should Be Visible  xpath=//*[contains(text(), 'Процедура')]/following-sibling::table

###############################################
#				Alt+Right					  #
###############################################
Натиснути надіслати вперед(Alt+Right)
	Click Element  //*[contains(@title, "Alt+Right")]
	Дочекатись закінчення загрузки сторінки(webclient)


###############################################
#				Shift+F4   					  #
###############################################
Натиснути кнопку Перечитать (Shift+F4)
    Click Element  //*[@title="Перечитать (Shift+F4)"]|//*[@title="Перечитати (Shift+F4)"]
    Дочекатись закінчення загрузки сторінки(webclient)