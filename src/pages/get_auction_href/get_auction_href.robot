*** Settings ***
Resource                                   get_auction_href_keywords.robot


*** Variables ***
${go to auction btn}                       //*[@data-qa="button-poptip-participate-view"]
${view auction btn}                        //*[@data-qa="button-poptip-view"]
${participate in auction link}             //*[@data-qa="link-participate"]
${view auction link}                       //*[@data-qa="link-view"]


*** Keywords ***
Отримати посилання на участь та прегляд аукціону для учасника
	Element Should Not Be Visible  ${view auction btn}   Ой! Що тут робить кнопка "Перегляд аукціону"
	Wait Until Element Is Visible  ${go to auction btn}  10
	Scroll Page To Element XPATH   ${go to auction btn}
	Click Element                  ${go to auction btn}
	get_auction_href_keywords.Дочекатись формування посилань на аукціон
	${auction_participate_href}    get_auction_href_keywords.Отримати URL для участі в аукціоні
	${auction_href}                Run Keyword If  '${SUITE NAME}' != 'Cdb1 Dutch'
	...  get_auction_href_keywords.Отримати URL на перегляд
	[Return]                       ${auction_participate_href}  ${auction_href}


Отримати посилання на прегляд аукціону не учасником
    Element Should Not Be Visible  ${go to auction btn}  Ой! Що тут робить кнопка "До аукціону"
	Wait Until Element Is Visible  ${view auction btn}   10
	Scroll Page To Element XPATH   ${view auction btn}
	Click Element                  ${view auction btn}
	get_auction_href_keywords.Дочекатись формування посилань на аукціон
    ${auction_href}                get_auction_href_keywords.Отримати URL на перегляд
    [Return]                       ${auction_href}
