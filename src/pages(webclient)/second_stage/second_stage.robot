*** Keywords ***
Перейти до другої фази
    Натиснути надіслати вперед(Alt+Right)
    ${status}  Run Keyword And Return Status
    ...  Wait Until Element Is Visible  //*[@id="MessageBoxContent"]//p[contains(text(),"Перейти до другої фази?")]
    Run Keyword If  '${status}' == 'False'  Перейти до другої фази
    Закрити валідаційне вікно (Так/Ні)  Перейти до другої фази?  Так


Перейти до другого етапу
    Натиснути кнопку Перечитать (Shift+F4)
    ${status}  Run Keyword And Return Status  Wait Until Element Is Visible  //*[@title="До 2-го етапу"]
    Run Keyword If  '${status}' == 'False'  Перейти до другого етапу
    Натиснути елемент у якого title  До 2-го етапу
    Закрити валідаційне вікно  Умова відбору тендерів  OK


