*** Variables ***
${tender found}                     //*[@id="tenders"]/tbody/*[@class="head"]//a[@href and @class="linkSubjTrading"]


*** Keywords ***
Перевірити унікальність результату пошуку
	${count}  Get Element Count  ${tender found}
	Should Be Equal  '${count}'  '1'