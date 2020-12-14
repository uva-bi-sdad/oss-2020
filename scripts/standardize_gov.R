# FUNCTIONS FOR STANDARDIZING INSTIUTIONS IN ACADEMIC AND GOVERNMENT SECTORS

standardize_gov <- function(df, institution){

  library("tidyverse")
  library("tidytable")

  #institution <- enquo(institution)
 df <- df %>%
   as.data.table() %>%
   #rename(institution = company) %>%
   ## this code will be implemented below
   mutate.(institution = tolower(institution), institution = trimws(institution)) %>%
   separate(institution, ("institution"), "\\(", extra = "drop") %>%
   mutate.(institution = str_replace_all(institution, "\\b(united states)\\b", "u.s.")) %>%
   # specific to the us gov manual and a-z index
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(judicial branch|federal agency - judicial)\\b"),
                                "u.s. judicial branch",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution,
                                                   "\\b(?i)(legislative branch|the legislative branch|federal agency - legislative)\\b"), "u.s. legislative branch",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution,
                                                   "\\b(?i)(federal agency - executive|^executive department sub|executive branch: departments|executive department)\\b"),
                                "u.s. executive branch",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution,
                                                   "\\b(?i)(executive branch: the president|the executive office of the president|executive office of the president)\\b"),
                                "executive office of the u.s. president",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution, "\\b(?i)(quasi-official agencies|u.s. quasi-official agencies)\\b"),
                                "u.s. quasi-official governmental institution",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution,
                                                   "\\b(?i)(Executive Branch: Independent Agencies and Government Corporations|independent agency)\\b"), "u.s. independent agency",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution, "\\b(?i)(independent board, commission, committee)\\b"),
                                "u.s. independent board, commission, committee",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution, "\\b(?i)(international organizations)\\b"),
                                "u.s. international organizations",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution,  "\\b(?i)(^export bank|export-import bank of the u.s.)\\b"),
                                "export/import bank of the u.s.",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution,  "\\b(?i)(geological survey)\\b"), "u.s. geological survey",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution,  "\\b(?i)(^fossil energy)\\b"), "u.s. fossil energy",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution, "\\b(?i)(^forest service)\\b"),  "u.s. forest service",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution, "\\b(?i)(^senate)\\b"), "u.s. senate",  institution)) %>%
   mutate.(institution = ifelse(str_detect( institution, "\\b(?i)(^mint)\\b"), "u.s. mint",  institution)) %>%
   # worked above this

   # high level departments (non-defense)
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(congress—u.s. house of representatives|house of representatives)\\b"),
                                  "u.s. house of representatives", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(congress—u.s. senate|u.s. senate)\\b"),
                                  "u.s. senate", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(agriculture department|usda|department of agriculture|u.s. department of agriculture|dept of ag|dept of ag.|dept. of ag.|u.s. dept of ag|us dept of ag|u.s. dept. of ag.|u.s. agriculture department)\\b"),
                                  "u.s. department of agriculture", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(department of commerce|^commerce department)\\b"),
                                  "u.s. department of commerce", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(department of education|doed|education department)\\b"),
                                  "u.s. department of education", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(department of energy|doe|energy department)\\b"),
                                  "u.s. department of energy", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(department of health and human services|hhs|u.s. department of health & human services|health and human services department)\\b"),
                                  "u.s. department of health and human services", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(department of homeland security|dhs|homeland security department)\\b"),
                                  "u.s. department of homeland security", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(department of housing and urban development|hud|housing and urban development, department of)\\b"),
                                  "u.s. department of housing and urban development", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(department of justice|doj|justice department)\\b"),
                                  "u.s. department of justice", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(department of labor|dol|labor department)\\b"),
                                  "u.s. department of labor", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(department of state|state department)\\b"),
                                  "u.s. department of state", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(department of the interior|interior department)\\b"),
                                  "u.s. department of the interior", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(department of the treasury|treasury department)\\b"),
                                  "u.s. department of the treasury", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(us department of veterans affairs|department of veterans affairs|veterans affairs department)\\b"),
                                  "u.s. department of veterans affairs", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(department of transportation|transportation department)\\b"),
                                  "u.s. department of transportation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(defense department|us dod|u.s. dod|u.s. d.o.d.|dept of defense|department of defense)\\b"),
                                  "u.s. department of defense", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(CIA|central intelligence agency)\\b"),
                                  "u.s. central intelligence agency", institution)) %>%
   mutate(institution = ifelse(str_detect(institution, "\\b(?i)(defense finance and accounting service(?! debt)|dfas|defense finance and accounting service)\\b"),
                                  "u.s. defense finance and accounting service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(debt and claims management center|defense finance and accounting service debt and claims management center)\\b"),
                                  "u.s. defense finance and accounting service - debt and claims management center", institution)) %>%
   mutate(institution = ifelse(str_detect(institution, "\\b(?i)(air force research laboratory|air force research labs)\\b"),
                                  "u.s. air force research laboratory", institution)) %>%
   mutate(institution = ifelse(str_detect(institution, "\\b((?<!library of )congress)\\b"), "u.s. congress", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(air force reserve|us air force reserve command)\\b"),
                                  "u.s. air force reserve command", institution)) %>%
   mutate(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(air force(?! reserve)|department of the air force|us air force)\\b"),
                                  "u.s. air force", institution)) %>%
   mutate(institution = ifelse(str_detect(institution,
                                                   "\\b(?i)(department of the army|us army(?! corps)|army(?! corps)|u.s. army(?! corps))\\b"),
                                 "u.s. department of the army", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(army corps of engineers|corps of engineers)\\b"),
                                  "u.s. army corps of engineers", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(department of the navy|us navy|navy|u.s. navy)\\b"),
                                  "u.s. department of the navy", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
   "\\b(?i)(cyber and infrastructure security agency|cisa|cybersecurity and infrastructure security agency)\\b"),
                                  "u.s. cybersecurity and infrastructure security agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
   "\\b(?i)(director of national intelligence, office of|director of national intelligence|office of director of national intelligence)\\b"),
                                  "u.s. office of director of national intelligence", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(coast guard)\\b"),
                                  "u.s. coast guard", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(health affairs, assistant secretary of defense for|assistant secretary of defense for health affairs)\\b"),
                                  "u.s. assistant secretary of defense for health affairs", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(marine corps|marines|the marines)\\b"),
                                  "u.s. marine corps", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(u.s. military academy, west point|west point military academy|west point)\\b"),
                                  "u.s. military academy, west point", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(european command)\\b"),  "u.s. european command", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(northern command)\\b"),  "u.s. northern command", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(pacific command)\\b"), "u.s. pacific command", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(southern command)\\b"), "u.s. southern command", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(strategic command)\\b"), "u.s. strategic command", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(central command)\\b"),  "u.s. central command", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(special forces operations command)\\b"), "u.s. special operations command", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(national guard)\\b"), "u.s. national guard", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national guard)\\b"), "u.s. national guard", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(national defense university)\\b"),  "u.s. national defense university", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
   "\\b(?i)(information resource management college|national defense university icollege|college of information and cyberspace|national defense university - college of information and cyberspace)\\b"),
                                  "u.s. national defense university - college of information and cyberspace", institution)) %>%
   # bureaus
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(economics and statistics service|economics, statistics, and cooperative service|economic research service)\\b"),
                                  "u.s. economic research service", institution)) %>% # ers
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(environmental management|environmental management, office of|office of environmental management)\\b"),
                                  "u.s. office of environmental management", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(engraving and printing, bureau of|bureau of engraving and printing)\\b"),
                                  "u.s. bureau of engraving and printing", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(economic analysis, bureau of|bureau of economic analysis)\\b"), # bea
                                  "u.s. bureau of economic analysis", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(fiscal service, bureau of the|bureau of the fiscal service)\\b"),
                                  "u.s. bureau of the fiscal service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(industry and security, bureau of|bureau of industry and security)\\b"),
                                  "u.s. bureau of industry and security", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(justice statistics, bureau of|bureau of justice statistics)\\b"),
                                  "u.s. bureau of justice statistics", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(labor statistics, bureau of|bureau of labor statistics)\\b"), # bls
                                  "u.s. bureau of labor statistics", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(land management, bureau of|bureau of land management)\\b"), # blm
                                  "u.s. bureau of land management", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(reclamation, bureau of|bureau of reclamation)\\b"),
                                  "u.s. bureau of reclamation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(safety and environmental enforcement, bureau of|bureau of safety and environmental enforcement)\\b"),
                                  "u.s. bureau of safety and environmental enforcement", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(transportation statistics, bureau of|bureau of transportation statistics)\\b"),
                                  "u.s. bureau of transportation statistics", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(ca-cst code reuse library|ca/cst/systems integration & innovation division|consular affairs, bureau of|bureau of consular affairs)\\b"),
                                  "u.s. bureau of consular affairs", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(bureau of ocean energy management, regulation, & enforcement|ocean energy management, bureau of|bureau of ocean energy management)\\b"),
                                  "u.s. bureau of ocean energy management", institution)) %>% # boem
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(alcohol, tobacco, firearms and explosives bureau|alcohol, tobacco, and firearms division|alcohol, tobacco, firearms and explosives bureau|bureau of alcohol, tobacco, and firearms|bureau of alcohol, tobacco, firearms and explosives)\\b"), # ATF = acronym
                                  "u.s. bureau of alcohol, tobacco, firearms and explosives", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(international labor affairs, bureau of|bureau of international labor affairs)\\b"), # ATF = acronym
                                  "u.s. bureau of international labor affairs", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(bureau of the census|census bureau|us census bureau)\\b"),
                                  "u.s. census bureau", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(bureau of bureau of indian affairs|indian affairs|bureau of indian affairs)\\b"),
                                  "u.s. bureau of indian affairs", institution)) %>%

   # offices
   mutate(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)((?<!multifamily )housing office|office of housing)\\b"),
                                  "u.s. office of housing", institution)) %>%
   mutate(institution = ifelse(str_detect(institution,  "\\b(?i)(Multifamily Housing Office)\\b"),
                                  "u.s. office of multifamily housing", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(compliance, office of|office of compliance)\\b"),
                                  "u.s. office of compliance", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(comptroller of the currency, office of|office of comptroller of the currency|office of the comptroller of the currency)\\b"),
                                  "u.s. office of the comptroller of the currency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(disability employment policy, office of|office of disability employment policy)\\b"),  "u.s. office of disability employment policy", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(Elementary and Secondary Education, Office of|office of elementary and secondary education|u.s. office of elementary and secondary education|innovation and improvement office|office of innovation and improvement)\\b"),
                                  "u.s. office of elementary and secondary education", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(government ethics, office of|office of government ethics)\\b"),
                                  "u.s. office of government ethics", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(justice programs, office of|office of justice programs)\\b"),
                                  "u.s. office of justice programs", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(juvenile justice and delinquency prevention, office of|office of juvenile justice and delinquency prevention)\\b"), "u.s. office of juvenile justice and delinquency prevention", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(manufactured housing programs, office of|office of manufactured housing programs)\\b"), "u.s. office of manufactured housing programs", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(minority health, office of|office of minority health)\\b"),
                                  "u.s. office of minority health", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(natural resources revenue, office of|office of natural resources revenue)\\b"),
                                  "u.s. office of natural resources revenue", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(nuclear energy, office of|office of nuclear energy)\\b"),
                                  "u.s. office of nuclear energy", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(pardon attorney, office of|office of pardon attorney)\\b"),
                                  "u.s. office of pardon attorney", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(postsecondary education, office of|office of postsecondary education)\\b"),
                                  "u.s. office of postsecondary education", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(refugee resettlement, office of|office of refugee resettlement)\\b"),
                                  "u.s. office of refugee resettlement", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(science and technology policy, office of|office of science and technology policy)\\b"), "u.s. office of science and technology policy", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(servicemember affairs, office of|office of servicemember affairs)\\b"),
                                  "u.s. office of servicemember affairs", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(special counsel, office of|office of special counsel)\\b"),
                                  "u.s. office of special counsel", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(special education and rehabilitative services, office of|office of special education and rehabilitative services)\\b"),  "u.s. office of special education and rehabilitative services", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(surface mining, reclamation and enforcement, office of|office of surface mining, reclamation and enforcement)\\b"), "u.s. office of surface mining, reclamation and enforcement", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(child support enforcement, office of|child support enforcement, office of)\\b"),
                                  "u.s. office of child support enforcement", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(career, technical, and adult education, office of|office of career, technical, and adult education)\\b"), "u.s. office of career, technical, and adult education", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(scientific and technical information, office of|office of scientific and technical information)\\b"), "u.s. office of scientific and technical information", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(violence against women, office on|office on violence against women|office on violence against women)\\b"), "u.s. office on violence against women", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(office of surface mining, reclamation and enforcement|office of surface mining reclamation and enforcement)\\b"), "u.s. office of surface mining reclamation and enforcement", institution)) %>%

   # courts
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(supreme court of the u.s.|the supreme court|supreme court of the us|the supreme court of the u.s.|SCOTUS|u.s. supreme court)\\b"),
                                  "supreme court of the u.s.", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(court of appeals for veterans claims)\\b"),  "u.s. court of appeals for veterans claims", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(court of appeals for the armed forces)\\b"), "u.s. court of appeals for the armed forces", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(court of appeals for the federal circuit)\\b"),  "u.s. court of appeals for the federal circuit", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(court of federal claims)\\b"),  "u.s. court of federal claims", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(court of international trade)\\b"),   "u.s. court of international trade", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(bankruptcy courts)\\b"),  "u.s. bankruptcy courts", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(judicial circuit courts of appeal|circuit courts of appeal|u.s. judicial circuit courts of appeal|u.s. circuit courts of appeal|u.s. courts of appeal)\\b"), "u.s. circuit courts of appeal", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(federal court interpreters)\\b"),  "u.s. federal court interpreters", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(lower courts)\\b"),   "u.s. lower courts", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(special courts)\\b"),  "u.s. special courts", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(tax court)\\b"),  "u.s. tax court", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(court services and offender supervision|court services and offender supervision agency for the district of columbia|court services and offender supervision agency)\\b"), "u.s. court services and offender supervision agency", institution)) %>%
   # other organizations
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(Fire Administration|USFA)\\b"),
                                  "u.s. fire administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(Federal Home Loan Mortgage Corporation|Freddie Mac|federal home loan mortgage corporation)\\b"),
                                  "u.s. federal home loan mortgage corporation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal national mortgage association|Fannie Mae)\\b"),
                                  "u.s. federal national mortgage association", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(Government National Mortgage Association|Ginnie Mae)\\b"),
                                  "u.s. government national mortgage association", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(united states access board|access board)\\b"),
                                  "u.s. access board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(administration for children and families|acf)\\b"),
                                  "u.s. administration for children and families", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(advanced distributed learning|adl|adl-aicc)\\b"), # collaboration
                                  "u.s. advanced distributed learning", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, # contains a collaboration
                                                    "\\b(?i)(agency for healthcare research and quality|ahrq|agency for health care policy and research)\\b"),
                                  "u.s. agency for healthcare research and quality", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(agency for international development|usaid)\\b"),
                                  "u.s. agency for international development", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(agricultural marketing service|ams)\\b"),
                                  "u.s. agricultural marketing service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(food and agriculture, national institute of|nifa|national institute of food and agriculture|cooperative state research, education, and extension service|national institute of food and agriculture (nifa))\\b"),
                                  "u.s. national institute of food and agriculture", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(advanced research projects agency-energy|energy transformation acceleration fund|arpa-e)\\b"),
                                  "u.s. advanced research projects agency-energy", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(Agricultural Research Service|agriculture research service|usda ars)\\b"), # ARS = acronym
                                  "u.s. agricultural research service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(ames laboratory|ames lab|doe ames laboratory|the ames lab)\\b"),
                                  "ames laboratory", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(ames research center)\\b"),
                                  "nasa ames research center", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(tax and trade bureau|bureau of alcohol and tobacco tax and trade|alcohol and tobacco tax and trade bureau)\\b"), # TTB = acronym
                                  "u.s. alcohol and tobacco tax and trade bureau", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(alcohol, drug abuse, and mental health administration|samhsa|substance abuse and mental health services administration)\\b"), # samhsa = acronym
                                  "u.s. substance abuse and mental health services administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national railroad passenger corporation|amtrak)\\b"),
                                  "amtrak", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(animal and plant health inspection service|aphis|animal and plant health inspection service)\\b"),
                                  "u.s. animal and plant health inspection service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(archives, national archives and records administration|nara|national archives and records administration)\\b"),
                                  "u.s. national archives and records administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(arctic llc|arctic landscape conservation cooperative)\\b"),
                                  "u.s. arctic landscape conservation cooperative", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(arctic research commission)\\b"),
                                  "u.s. arctic research commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(argonne national laboratory|argonne national lab|argonne national labs)\\b"),
                                  "argonne national laboratory", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(african development bank|african development foundation|nigeria trust fund|banque africaine de développement|banque africaine de dveloppement|banque africaine de developpement)\\b"),
                                  "african development bank group", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                           "\\b(?i)(lawrence livermore national laboratory|lawrence livermore national laboratories|lawrence livermore national lab|lawrence livermore national laboratory llnl|llnl)\\b"),
                                "lawrence livermore national laboratory", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                           "\\b(?i)(lawrence berkeley national lab)\\b"),
                                "lawrence berkeley national laboratory", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                           "\\b(?i)(Los Alamos National Laboratory|los alamos|lanl)\\b"),
                                "lawrence berkeley national laboratory", institution)) %>%




   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national institute of peace|institute of peace)\\b"), #az-specific
                                  "u.s. institute of peace", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national institute of health|nih|national institutes of health)\\b"),
                                  "u.s. national institutes of health", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(food and agriculture, national institute of|nifa|national institute of food and agriculture)\\b"),
                                  "u.s. national institute of food and agriculture", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national cancer institute|nci|us nci|national cancer institute)\\b"),
                                  "u.s. national cancer institute", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(barry goldwater scholarship and excellence in education foundation|barry goldwater scholarship|barry goldwater foundation|barry goldwater program)\\b"),
                                  "barry m. goldwater scholarship and excellence in education program", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(commission on presidential scholars|presidential scholars commission)\\b"),
                                  "u.s. commission on presidential scholars", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(center for parent information and resources|parent information and resources center|parent information and resources center)\\b"),
                                  "center for parent information and resources", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(cdc - public health informatics lab|center for disease control|center for disease control and prevention|centers for disease control and prevention)\\b"),
                                  "u.s. centers for disease control and prevention", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(centers for medicare & medicaid services|centers for medicare and medicaid services)\\b"),
                                  "u.s. centers for medicare and medicaid services", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(civil rights division, department of justice|u.s. dept of justice, civil rights division)\\b"),
                                  "u.s. department of justice, civil rights division", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(civil rights, department of health and human services office for)\\b"),
                                  "u.s. department of health and human services, office for civil rights", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(civil rights, department of education office of)\\b"),
                                  "u.s. department of education, office for civil rights", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(corporation for national & community service|corporation for national and community service)\\b"),
                                  "u.s. corporation for national and community service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(business usa)\\b"),
                                  "business usa", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(sandia national laboratory)\\b"),
                                  "sandia national laboratories", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(council of inspectors general on integrity and efficiency|council of the inspectors general on integrity and efficiency|inspectors general)\\b"),
                                  "u.s. council of the inspectors general on integrity and efficiency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(global media, agency for|Agency for Global Media)\\b"),
                                  "u.s. agency for global media", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(grain inspection, packers, and stockyards administration|grain inspection, packers and stockyards administration|grain inspection packers and stockyards administration)\\b"),
                                  "u.s. grain inspection, packers and stockyards administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(japan-u.s. friendship commission|japan-us friendship commission)\\b"),
                                  "japan-u.s. friendship commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(john f. kennedy center for performing arts|kennedy center)\\b"),
                                  "john f. kennedy center for the performing arts", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(medical payment advisory commission|medpac|medicare payment advisory commission)\\b"),
                                  "u.s. medicare payment advisory commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(medicaid and chip payment and access commission|macpac|medicaid and chip payment and access commission)\\b"),
                                  "u.s. medicaid and chip payment and access commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(occupational safety & health review commission|occupational safety and health review commission)\\b"),
                                  "u.s. occupational safety and health review commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(rural business and cooperative programs|rural business-cooperative service)\\b"),
                                  "u.s. rural business-cooperative service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(u.s. abilityone|u.s. abilityone commission|abilityone|abilityone commission)\\b"),
                                  "u.s. abilityone commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(us-cert|us computer emergency readiness team|computer emergency readiness team)\\b"),
                                  "u.s. computer emergency readiness team", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(^weather service|^national weather service)\\b"),
                                  "u.s. national weather service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(^secret service$)\\b"),
                                  "u.s. secret service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(postal service|us postal service|usps|u.s. postal service|the u.s. postal service|the us postal service)\\b"),
                                  "u.s. postal service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(noaa fisheries|noaa|nmfs|national marine fisheries service)\\b"),
                                  "u.s. national marine fisheries service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(capitol visitor center)\\b"),
                                  "u.s. capitol visitor center", institution)) %>%

   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(trade representative)\\b"),
                                  "u.s. trade representative", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(fedstats|federal interagency council on statistical policy)\\b"),
                                  "u.s. federal interagency council on statistical policy", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal mediation and conciliation service|mediation and conciliation service|FMCS)\\b"),
                                  "u.s. federal mediation and conciliation service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(agriculture library|us agriculture library|us library of agriculture|national library of agriculture)\\b"), # specific to az-index
                                  "u.s. national library of agriculture", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(patent and trademark office)\\b"), # specific to az-index
                                  "u.s. patent and trademark office", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(industrial college of the armed forces)\\b"),
                                  "dwight d. eisenhower school for national security and resource strategy", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(fleet forces command)\\b"),
                                  "u.s. fleet forces command", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(office of special education and rehabilitative services)\\b"),
                                  "u.s. office of special education and rehabilitative services", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(office of fossil energy|u.s. fossil energy)\\b"),
                                  "u.s. office of fossil energy", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national prevention information network|prevention information network|cdc npin)\\b"),
                                  "cdc - national prevention information network", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(office of child support enforcement|ocse)\\b"),
                                  "u.s. office of child support enforcement", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(customs and border protection)\\b"),
                                  "u.s. customs and border protection", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(immigration and customs enforcement|us customs)\\b"), # ice
                                  "u.s. immigration and customs enforcement", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(citizenship and immigration services|immigration and citizenship services)\\b"),
                                  "u.s. citizenship and immigration services", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(community planning and development|office of community planning and development)\\b"),
                                  "u.s. office of community planning and development", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(fair housing and equal opportunity|office of fair housing and equal opportunity)\\b"),
                                  "u.s. office of fair housing and equal opportunity", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(office of policy development and research|policy development and research)\\b"),
                                  "u.s. office of policy development and research", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(bureau of prisons|federal bureau of prisons)\\b"),
                                  "u.s. federal bureau of prisons", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(immigrant and employee rights section|office of immigrant and employee rights)\\b"),
                                  "u.s. office of immigrant and employee rights", institution)) %>%

   # specific to az-index
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(interpol)\\b"), "u.s. national central bureau - interpol", institution)) %>%

   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(office of the pardon attorney|office of pardon attorney)\\b"),
                                  "u.s. office of the pardon attorney", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(marshals service)\\b"),
                                  "u.s. marshals service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(parole commission)\\b"),
                                  "u.s. parole commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(hour and wage division|wage and hour division)\\b"),
                                  "u.s. wage and hour division", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(office of disability employment policy)\\b"),
                                  "u.s. office of disability employment policy", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(agency for toxic substances and disease registry|ATSDR)\\b"),
                                  "cdc - agency for toxic substances and disease registry", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national institute of occupational safety and health|NIOSH)\\b"),
                                  "cdc - national institute of occupational safety and health", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(environmental protection agency|EPA)\\b"),
                                  "u.s. environmental protection ageny", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(general services administration|GSA)\\b"),
                                  "u.s. general services administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(securities and exchange commission|SEC)\\b"),
                                  "u.s. securities and exchange commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(office of personnel management|OPM)\\b"),
                                  "u.s. office of personnel management", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(defense intelligence agency|DIA)\\b"),
                                  "u.s. defense intelligence agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(consumer financial protection bureau|CFPB|u.s. bureau of consumer financial protection|Bureau of Consumer Financial Protection)\\b"),
                                  "u.s. consumer financial protection bureau", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(botanic garden)\\b"),
                                  "u.s. botanic garden", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(capitol police)\\b"),
                                  "u.s. capitol police", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal register|office of the federal register)\\b"),
                                  "u.s. office of the federal register", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(postal inspection service)\\b"),
                                  "u.s. postal inspection service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(commission of fine arts)\\b"),
                                  "u.s. commission of fine arts", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(commodity futures trading commission)\\b"),
                                  "u.s. commodity futures trading commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(bureau of consumer financial protection)\\b"),
                                  "u.s. bureau of consumer financial protection", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(chemical safety board)\\b"),
                                  "u.s. chemical safety board", institution)) %>%


   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(commission on security and cooperation in europe|helsinki commission)\\b"),
                                  "u.s. commission on security and cooperation in europe", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(election assistance commission)\\b"),
                                  "u.s. election assistance commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(nuclear regulatory commission)\\b"),
                                  "u.s. nuclear regulatory commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(northwest power and conservation council|northwest power planning council|pacific northwest electric power and conservation planning council)\\b"),
                                  "u.s. northwest power and conservation council", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(office of cuba broadcasting)\\b"),
                                  "radio and tv martí", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(commission on international religious freedom)\\b"),
                                  "u.s. commission on international religious freedom", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(international trade commission)\\b"),
                                  "u.s. international trade commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(international trade administration)\\b"),
                                  "u.s. international trade administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(sentencing commission)\\b"),
                                  "u.s. sentencing commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(trade and development agency)\\b"),
                                  "u.s. trade and development agency", institution)) %>%

   # white house
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(council of economic advisers)\\b"),
                                  "u.s. council of economic advisers", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(council on environmental quality)\\b"),
                                  "u.s. council on environmental quality", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national security council)\\b"),
                                  "u.s. national security council", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(office of management and budget)\\b"),
                                  "u.s. office of management and budget", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(office of national drug control policy)\\b"),
                                  "u.s. office of national drug control policy", institution)) %>%

   # exec
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(marketing and regulatory programs)\\b"),
                                  "usda - marketing and regulatory programs", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(rural development)\\b"),
                                  "usda - rural development", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national institute of standards and technology)\\b"),
                                  "u.s. national institute of standards and technology", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national oceanic and atmospheric administration)\\b"),
                                  "u.s. national oceanic and atmospheric administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(unified combatant commands)\\b"),
                                  "u.s. unified combatant commands", institution)) %>%
   mutate(institution = ifelse(str_detect(institution,
                                                 "\\b(?i)((?<!sandia )national laboratories)\\b"),
                               "u.s. national laboratories", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(power administrations)\\b"),
                                  "u.s. power administrations", institution)) %>%
   mutate(institution = ifelse(str_detect(institution,
                                                 "\\b(?i)(science office|office of science(?! and technology policy))\\b"),
                               "u.s. office of science", institution)) %>%

   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(food and drug administration)\\b"),
                                  "u.s. food and drug administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal emergency management agency|FEMA)\\b"),
                                  "u.s. federal emergency management agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(administration for native americans|ANA)\\b"),
                                  "u.s. administration for native americans", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national passport information center|NPIC)\\b"),
                                  "u.s. national passport information center", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal emergency management agency|FEMA)\\b"),
                                  "u.s. federal emergency management agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(joint military intelligence college|national defense intelligence college|national intelligence university)\\b"),
                                  "u.s. national intelligence university", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(joint program executive office for chemical and biological defense|JPEO-CBRND)\\b"),
                                  "u.s. joint program executive office for chemical and biological defense", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national institute of corrections)\\b"),
                                  "u.s. national institute of corrections", institution)) %>%

   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national flood insurance program)\\b"),
                                  "u.s. national flood insurance program", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(center for food safety and applied nutrition)\\b"),
                                  "u.s. center for food safety and applied nutrition", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(committee for the implementation of textile agreements)\\b"),
                                  "u.s. committee for the implementation of textile agreements", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(joint forces staff college)\\b"),
                                  "u.s. joint forces staff college", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national war college)\\b"),
                                  "u.s. national war college", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(weights and measures division)\\b"),
                                  "u.s. weights and measures division", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national heart, lung, and blood institute)\\b"),
                                  "nih - national heart, lung, and blood institute", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national institute of diabetes and digestive and kidney diseases)\\b"),
                                  "nih - national institute of diabetes and digestive and kidney diseases", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national institute of mental health)\\b"),
                                  "nih - national institute of mental health", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national institute of neurological disorders and stroke)\\b"),
                                  "nih - national institute of neurological disorders and stroke", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(arthritis, musculoskeletal and skin diseases, national institute of|niams|national institute of arthritis, musculoskeletal and skin diseases|national institute of arthritis musculoskeletal and skin diseases)\\b"),
                                  "nih - national institute of arthritis, musculoskeletal and skin diseases", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national institute of deafness and other communication disorders)\\b"),
                                  "nih - national institute of deafness and other communication disorders", institution)) %>%


   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national ocean service)\\b"),
                                  "u.s. national ocean service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(seafood inspection program)\\b"),
                                  "u.s. seafood inspection program", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal housing administration)\\b"),
                                  "u.s. federal housing administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national institute of justice)\\b"),
                                  "u.s. national institute of justice", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(center for parent information and resources)\\b"),
                                  "u.s. center for parent information and resources", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(rehabilitation services administration)\\b"),
                                  "u.s. rehabilitation services administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(bonneville power administration)\\b"),
                                  "u.s.  bonneville power administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(southeastern power administration)\\b"),
                                  "u.s. southeastern power administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(southwestern power administration)\\b"),
                                  "u.s. southwestern power administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(western area power administration)\\b"),
                                  "u.s. western area power administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(rural housing service)\\b"),
                                  "u.s. rural housing service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(rural utilities service)\\b"),
                                  "u.s. rural utilities service", institution)) %>%


   #USDA
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(natural resources conservation service)\\b"),
                                  "u.s. natural resources conservation service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(risk management agency)\\b"),
                                  "u.s. risk management agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(center for nutrition policy and promotion)\\b"),
                                  "u.s. center for nutrition policy and promotion", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(farm service agency)\\b"),
                                  "u.s. farm service agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(food and nutrition service)\\b"),
                                  "u.s. food and nutrition service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(food safety and inspection service)\\b"),
                                  "u.s. food safety and inspection service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(foreign agricultural service)\\b"),
                                  "u.s. foreign agricultural service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(national agricultural statistics service)\\b"),
                                  "u.s. national agricultural statistics service", institution)) %>%
   #DOC
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(economic development administration)\\b"),
                                  "u.s. economic development administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(minority business development agency)\\b"),
                                  "u.s. minority business development agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(national technical information service)\\b"),
                                  "u.s. national technical information service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national telecommunications and information administration)\\b"),
                                  "u.s. national telecommunications and information administration", institution)) %>%
   #DOD
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(defense acquisition university)\\b"),
                                  "u.s. defense acquisition university", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(defense advanced research projects agency)\\b"),
                                  "u.s. defense advanced research projects agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(defense commissary agency)\\b"),
                                  "u.s. defense commissary agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(defense contract audit agency)\\b"),
                                  "u.s. defense contract audit agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(defense contract management agency)\\b"),
                                  "u.s. defense contract management agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(defense health agency)\\b"),
                                  "u.s. defense health agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(defense information systems agency)\\b"),
                                  "u.s. defense information systems agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(defense logistics agency)\\b"),
                                  "u.s. defense logistics agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(defense security cooperation agency)\\b"),
                                  "u.s. defense security cooperation agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(defense security service)\\b"),
                                  "u.s. defense security service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(defense technical information center)\\b"),
                                  "u.s. defense technical information center", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(defense threat reduction agency)\\b"),
                                  "u.s. defense threat reduction agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal voting assistance program)\\b"),
                                  "u.s. federal voting assistance program", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(joint chiefs of staff)\\b"),
                                  "u.s. joint chiefs of staff", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(missile defense agency)\\b"),
                                  "u.s. missile defense agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national geospatial-intelligence agency)\\b"),
                                  "u.s. national geospatial-intelligence agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national reconnaissance office)\\b"),
                                  "u.s. national reconnaissance office", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national security agency|NSA)\\b"),
                                  "u.s. national security agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(pentagon force protection agency)\\b"),
                                  "u.s. pentagon force protection agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(office of economic adjustment)\\b"),
                                  "u.s. office of economic adjustment", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(prisoner of war and missing in action accounting agency)\\b"),
                                  "u.s. prisoner of war and missing in action accounting agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(uniformed services university of the health sciences)\\b"),
                                  "u.s. uniformed services university of the health sciences", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(washington headquarters services)\\b"),
                                  "u.s. washington headquarters services", institution)) %>%
   # DOE
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(english language acquisition office)\\b"),
                                  "u.s. english language acquisition office", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal student aid information center)\\b"),
                                  "u.s. federal student aid information center", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(institute of education sciences)\\b"),
                                  "u.s. institute of education sciences", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(energy information administration)\\b"),
                                  "u.s. energy information administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal energy regulatory commission)\\b"),
                                  "u.s. federal energy regulatory commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national nuclear security administration)\\b"),
                                  "u.s. national nuclear security administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(administration for community living)\\b"),
                                  "u.s. administration for community living", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(indian health service)\\b"),
                                  "u.s. indian health service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national health information center)\\b"),
                                  "u.s. national health information center", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(president's council on fitness, sports and nutrition)\\b"),
                                  "u.s. president's council on fitness, sports and nutrition", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal law enforcement training center)\\b"),
                                  "u.s. federal law enforcement training center", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal protective service)\\b"),
                                  "u.s. federal protective service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(transportation security administration)\\b"),
                                  "u.s. transportation security administration", institution)) %>%


   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(office of lead hazard control and healthy homes)\\b"),
                                  "u.s. office of lead hazard control and healthy homes", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(public and indian housing)\\b"),
                                  "u.s. public and indian housing", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(antitrust division)\\b"),
                                  "u.s. antitrust division", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(community oriented policing services)\\b"),
                                  "u.s. community oriented policing services", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(drug enforcement administration)\\b"),
                                  "u.s. drug enforcement administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(elder justice initiative)\\b"),
                                  "u.s. elder justice initiative", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(executive office for immigration review)\\b"),
                                  "u.s. executive office for immigration review", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal bureau of investigation)\\b"),
                                  "u.s. federal bureau of investigation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(foreign claims settlement commission)\\b"),
                                  "u.s. foreign claims settlement commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(trustee program)\\b"),
                                  "u.s. trustee program", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(employee benefits security administration)\\b"),
                                  "u.s. employee benefits security administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(employment and training administration)\\b"),
                                  "u.s. employment and training administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(mine safety and health administration)\\b"),
                                  "u.s. mine safety and health administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(job corps)\\b"),
                                  "u.s. job corps", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(mine safety and health administration)\\b"),
                                  "u.s. mine safety and health administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(occupational safety and health administration|OSHA)\\b"),
                                  "u.s. occupational safety and health administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(veterans' employment and training service)\\b"),
                                  "u.s. veterans' employment and training service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(women's bureau)\\b"),
                                  "u.s. women's bureau", institution)) %>%

   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(arms control and international security)\\b"),
                                  "u.s. arms control and international security", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(economic growth, energy, and the environment)\\b"),
                                  "u.s. economic growth, energy, and the environment", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,"\\b(?i)(political affairs)\\b"), "u.s. political affairs", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(public diplomacy and public affairs)\\b"), "u.s. public diplomacy and public affairs", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(federal consulting group)\\b"),  "u.s. federal consulting group", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(fish and wildlife service)\\b"), "u.s. fish and wildlife service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national park service)\\b"),  "u.s. national park service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(internal revenue service|IRS)\\b"),  "u.s. internal revenue service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(taxpayer advocacy panel)\\b"),  "u.s. taxpayer advocacy panel", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(federal aviation administration)\\b"),  "u.s. federal aviation administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(federal highway administration)\\b"),  "u.s. federal highway administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(federal motor carrier safety administration)\\b"),  "u.s. federal motor carrier safety administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(federal railroad administration)\\b"), "u.s. federal railroad administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(federal transit administration)\\b"), "u.s. federal transit administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(maritime administration)\\b"), "u.s. maritime administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national highway traffic safety administration)\\b"), "u.s. national highway traffic safety administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,  "\\b(?i)(office of the assistant secretary for research and technology)\\b"),
                                  "u.s. office of the assistant secretary for research and technology", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(pipeline and hazardous materials safety administration)\\b"),
                                  "u.s. pipeline and hazardous materials safety administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(saint lawrence seaway development corporation)\\b"),
                                  "saint lawrence seaway development corporation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national cemetery administration)\\b"),
                                  "u.s. national cemetery administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(veterans benefits administration)\\b"),
                                  "u.s. veterans benefits administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(veterans health administration)\\b"),
                                  "u.s. veterans health administration", institution)) %>%
   mutate(institution = ifelse(str_detect(institution,
   "\\b(?i)((?<!mental )health resources administration|(?<!mental )health services administration|hrsa|health resources and services administration)\\b"),
                               "u.s. health resources and services administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(architect of the capitol)\\b"),
                                  "u.s. architect of the capitol", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(library of congress)\\b"),
                                  "u.s. library of congress", institution)) %>%


   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(congressional budget office)\\b"),
                                  "u.s. congressional budget office", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(government accountability office)\\b"),
                                  "u.s. government accountability office", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(government publishing office)\\b"),
                                  "u.s. government publishing office", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(house office of inspector general)\\b"),
                                  "u.s. house office of inspector general", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(house office of the clerk)\\b"),
                                  "u.s. house office of the clerk", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(open world leadership center)\\b"),
                                  "u.s. open world leadership center", institution)) %>%

   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(congressional research service)\\b"),
                                  "u.s. congressional research service", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(copyright office)\\b"),
                                  "u.s. copyright office", institution)) %>%
   ##
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal communications commission|FCC)\\b"),
                                  "u.s. federal communications commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal housing finance agency|FHFA)\\b"),
                                  "u.s. federal housing finance agency", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(endangered species program)\\b"),
                                  "u.s. endangered species program", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(migratory bird conservation commission)\\b"),
                                  "u.s. migratory bird conservation commission", institution)) %>%
   ##
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(legal services corporation)\\b"),
                                  "u.s. legal services corporation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national constitution center)\\b"),
                                  "u.s. national constitution center", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national gallery of art)\\b"),
                                  "u.s. national gallery of art", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(state justice institute)\\b"),
                                  "u.s. state justice institute", institution)) %>%
   ##
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(advisory council on historic preservation)\\b"),
                                  "u.s. advisory council on historic preservation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(citizens' stamp advisory committee)\\b"),
                                  "u.s. citizens' stamp advisory committee", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(coordinating council on juvenile justice and delinquency prevention)\\b"),
                                  "u.s. coordinating council on juvenile justice and delinquency prevention", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal financial institutions examination council)\\b"),
                                  "u.s. federal financial institutions examination council", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal geographic data committee)\\b"),
                                  "u.s. federal geographic data committee", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal laboratory consortium for technology transfer)\\b"),
                                  "u.s. federal laboratory consortium for technology transfer", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal library and information center committee)\\b"),
                                  "u.s. federal library and information center committee", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(interagency alternative dispute resolution working group)\\b"),
                                  "u.s. interagency alternative dispute resolution working group", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(interagency committee for the management of noxious and exotic weeds)\\b"),
                                  "u.s. interagency committee for the management of noxious and exotic weeds", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(interagency council on homelessness)\\b"),
                                  "u.s. interagency council on homelessness", institution)) %>%


   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(chief acquisition officers council)\\b"),
                                  "u.s. chief acquisition officers council", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(chief financial officers council)\\b"),
                                  "u.s. chief financial officers council", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(chief human capital officers council)\\b"),
                                  "u.s. chief human capital officers council", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(chief information officers council)\\b"),
                                  "u.s. chief information officers council", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(commission on civil rights)\\b"),
                                  "u.s. commission on civil rights", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(consumer product safety commission)\\b"),
                                  "u.s. consumer product safety commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(defense nuclear facilities safety board)\\b"),
                                  "u.s. defense nuclear facilities safety board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(equal employment opportunity commission)\\b"),
                                  "u.s. equal employment opportunity commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(farm credit administration)\\b"),
                                  "u.s. farm credit administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal deposit insurance corporation)\\b"),
                                  "u.s. federal deposit insurance corporation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal election commission)\\b"),
                                  "u.s. federal election commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal labor relations authority)\\b"),
                                  "u.s. federal labor relations authority", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal maritime commission)\\b"),
                                  "u.s. federal maritime commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal mine safety and health review commission)\\b"),
                                  "u.s. federal mine safety and health review commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal reserve system)\\b"),
                                  "u.s. federal reserve system", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal retirement thrift investment board)\\b"),
                                  "u.s. federal retirement thrift investment board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(federal trade commission|FTC)\\b"),
                                  "u.s. federal trade commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(institute of museum and library services)\\b"),
                                  "u.s. institute of museum and library services", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(merit systems protection board)\\b"),
                                  "u.s. merit systems protection board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(institute of museum and library services)\\b"),
                                  "u.s. institute of museum and library services", institution)) %>%


   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national aeronautics and space administration|nasa)\\b"),
                                  "u.s. national aeronautics and space administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national capital planning commission)\\b"),
                                  "u.s. national capital planning commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national credit union administration)\\b"),
                                  "u.s. national credit union administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(national endowment for the arts)\\b"),
                                  "u.s. national endowment for the arts", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national endowment for the humanities)\\b"),
                                  "u.s. national endowment for the humanities", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,"\\b(?i)(national labor relations board)\\b"),
                                  "u.s. national labor relations board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national mediation board)\\b"),
                                  "u.s. national mediation board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national science foundation|BMI)\\b"),
                                  "u.s. national science foundation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national transportation safety board)\\b"),
                                  "u.s. national transportation safety board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(peace corps)\\b"), "u.s. peace corps", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(pension benefit guaranty corporation)\\b"),
                                  "u.s. pension benefit guaranty corporation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(postal regulatory commission)\\b"),
                                  "u.s. postal regulatory commission", institution)) %>%


   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(privacy and civil liberties oversight board)\\b"),
                                  "u.s. privacy and civil liberties oversight board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution,
                                                    "\\b(?i)(railroad retirement board)\\b"),
                                  "u.s. railroad retirement board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(selective service system)\\b"),
                                  "u.s. selective service system", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(small business administration)\\b"),
                                  "u.s. small business administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(social security administration)\\b"),
                                  "u.s. social security administration", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(surface transportation board)\\b"),
                                  "u.s. surface transportation board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(federal interagency committee on education)\\b"),
                                  "u.s. federal interagency committee on education", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(marine mammal commission)\\b"),
                                  "u.s. marine mammal commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national council on disability)\\b"),
                                  "u.s. national council on disability", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national park foundation)\\b"),
                                  "u.s. national park foundation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(northern border regional commission)\\b"),
                                  "u.s. northern border regional commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(nuclear waste technical review board)\\b"),
                                  "u.s. nuclear waste technical review board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(social security advisory board)\\b"),
                                  "u.s. social security advisory board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(indian arts and crafts board)\\b"),
                                  "u.s. indian arts and crafts board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(federal financing bank)\\b"),
                                  "u.s. federal financing bank", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(indoor air quality)\\b"),
                                  "u.s. indoor air quality", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national pesticide information center)\\b"),
                                  "u.s. national pesticide information center", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(wireless telecommunications bureau)\\b"),
                                  "u.s. wireless telecommunications bureau", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(office of investor education and advocacy)\\b"),
                                  "u.s. office of investor education and advocacy", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(federal executive boards)\\b"),
                                  "u.s. federal executive boards", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(armed forces retirement home)\\b"),
                                  "u.s. armed forces retirement home", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(federal accounting standards advisory board)\\b"),
                                  "u.s. federal accounting standards advisory board", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(holocaust memorial museum)\\b"),
                                  "u.s. holocaust memorial museum", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(joint board for the enrollment of actuaries)\\b"),
                                  "u.s. joint board for the enrollment of actuaries", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(joint fire science program)\\b"),
                                  "u.s. joint fire science program", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(meat and poultry hotline)\\b"),
                                  "u.s. meat and poultry hotline", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national indian gaming commission)\\b"),
                                  "u.s. national indian gaming commission", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national interagency fire center)\\b"),
                                  "u.s. national interagency fire center", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(judicial panel on multidistrict litigation)\\b"),
                                  "u.s. judicial panel on multidistrict litigation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(joint congressional committee on inaugural ceremonies)\\b"),
                                  "u.s. joint congressional committee on inaugural ceremonies", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(farm credit system insurance corporation)\\b"),
                                  "u.s. farm credit system insurance corporation", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(federal judicial center)\\b"),
                                  "u.s. federal judicial center", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(national foundation on the arts and the humanities)\\b"),
                                  "u.s. national foundation on the arts and the humanities", institution)) %>%
   mutate.(institution = ifelse(str_detect(institution, "\\b(?i)(overseas private investment corporation)\\b"),
                                  "u.s. overseas private investment corporation", institution))


   df
}















