*** Keywords ***
Перейти до другої фази
    Натиснути надіслати вперед(Alt+Right)
    Wait Until Element Is Visible  //*[@id="MessageBoxContent"]//p[contains(text(),"Перейти до другої фази?")]
    validation.Закрити валідаційне вікно (Так/Ні)  Перейти до другої фази?  Так


Перейти до другого етапу
    Натиснути кнопку Перечитать (Shift+F4)
    Wait Until Element Is Visible  //*[@title="До 2-го етапу"]
    Click Element  //*[@title="До 2-го етапу"]
    Дочекатись закінчення загрузки сторінки(webclient)
    Закрити валідаційне вікно  Умова відбору тендерів  OK


