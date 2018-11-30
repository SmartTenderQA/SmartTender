*** Variables ***
${contract iframe}			css=#ui-id-1>iframe


*** Keywords ***
Перевірити заголовок договору
	${should header}  Set Variable  Договір
	${is header}  Get Text  css=#ui-id-2
	Should Be Equal  ${is header}  ${should header}


Перевірити перший абзац договору
	Select Frame  ${contract iframe}
	${should text}  Set Variable  Для участі у будь-якому статусі в електронних торгах (закупівлях) Вам необхідно укласти відповідний договір із Оператором електронного майданчика Smarttender.biz. Для цього Ви може скористатися Акцептом оферти (прийняття умов договору приєднання).
	${is text}  Get Text  css=p
	Should Contain  ${is text}  ${should text}
	Unselect Frame


Перевірити лінки в тексті договору
	Select Frame  ${contract iframe}
	${should link1}  Set Variable  https://smarttender.biz/instruktsii/dogovir-pryednannya-so-2015-003-pro-nadannya-informatsiynyh-poslug-pid-chas-provedennya-protsedur-publichnyh-zakupivel-prozorro-ta-zakupivel-rialto/
	${should link2}  Set Variable  https://smarttender.biz/instruktsii/dogovir-pryednannya-so-2016-001-pro-nadannya-poslug-z-organizatsii-ta-provedennya-vidkrytyh-elektronnyh-torgiv-auktsioniv/
	${is link1}  Get Element Attribute  ${contract link1}  href
	${is link2}  Get Element Attribute  ${contract link2}  href
	Should Be Equal  ${is link1}  ${should link1}
	Should Be Equal  ${is link2}  ${should link2}
	Unselect Frame