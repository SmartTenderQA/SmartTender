*** Variables ***
${analytics}                                    //i[@class='fa fa-pie-chart']//ancestor::a
${calendar}                                     //i[@class='fa fa-calendar']//ancestor::a
${new_tender_page}                              //i[@class='fa fa-gavel']//ancestor::a
${balance}                                      (//i[@class='fa fa-money']//ancestor::a)[1]
${invoice}                                      //i[@class='fa fa-file-o']//ancestor::a
${acts}                                         //i[@class='fa fa-newspaper-o']//ancestor::a
${messages}                                     //i[@class='fa fa-envelope']//ancestor::a
${my_messages}                                  //i[@class='fa fa-inbox']//ancestor::a
${faq}                                          //i[@class='fa fa-question-circle']//ancestor::a
${subscription}                                 //i[@class='fa fa-wrench']//ancestor::a
${tenders}                                      //i[@class='fa fa-folder-o']//ancestor::a
${tenders_last}                                 //i[@class='fa fa-folder-open-o']//ancestor::a
${tenders_history}                              //i[@class='fa fa-history']//ancestor::a
${tenders_request}                              (//i[@class='fa fa-money']//ancestor::a)[2]
${paid_services}                                //i[@class='fa fa-shopping-bag']//ancestor::a
${tender_providing}                             //i[@class='fa fa-university']//ancestor::a
${legal_help}                                   //i[@class='fa fa-graduation-cap']//ancestor::a
${personal_data}                                //i[@class='fa fa-user']//ancestor::a
${company_profile}                              //i[@class='fa fa-building-o']//ancestor::a
${change_password}                              //i[@class='fa fa-key']//ancestor::a
${user_management}                              //i[@class='fa fa-users']//ancestor::a
${additional_services}                          //i[@class='fa fa-object-group']//ancestor::a
${my_documents}                                 //i[@class='fa fa-paperclip']//ancestor::a
${reports}                                      //i[@class='fa fa-file-text-o']//ancestor::a
${instructions}                                 //i[@class='fa fa-info']//ancestor::a
${owner}                                        //i[@class='fa fa-suitcase']//ancestor::a
${telegram_bot}                                 //i[@class='fa fa-telegram']//ancestor::a
${tenders}                                      //i[@class='fa fa-hand-o-right']//ancestor::a

${not collapsed menu button your account}       //*[contains(@class, "page-container") and not(contains(@class, "collapsed"))]//*[@class="sidebar-collapse"]
${collapsed menu button your account}           //*[contains(@class, "page-container") and contains(@class, "collapsed")]//*[@class="sidebar-collapse"]


*** Keywords ***
Розкрити меню в особистому кабінеті за необхідністю
	${status}  Run Keyword And Return Status  Page Should Contain Element  ${not collapsed menu button your account}
	Run Keyword If  "${status}" != "True"  Click Element  ${collapsed menu button your account}


Розкрити під-меню в особистому кабінеті за необхідністю
    [Arguments]  ${item}
    ${selector}  Set variable  ${${item}}
	${status}  Run Keyword And Return Status  Element Should Be Visible  ${selector}
	Run Keyword If  "${status}" != "True"  Click Element  ${selector}//ancestor::li[contains(@class,'root-level')]
	Wait Until Element Is Visible  ${selector}
	Sleep  .5