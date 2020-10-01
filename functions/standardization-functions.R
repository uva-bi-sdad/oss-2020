# FUNCTIONS FOR STANDARDIZING INSTIUTIONS IN ACADEMIC AND GOVERNMENT SECTORS

wrangle_gov <- function(data_frame, institution){
  for (pkg in c("tidyverse", "data.table", "maditr")) {library(pkg, character.only = TRUE)}
  institution <- enquo(institution)
  data_frame <- data_frame %>%
    #as.data.table() %>%
    ## this code will be implemented below
    mutate(institution = tolower(!!institution),
              institution = trimws(institution)) %>%
    separate(institution, ("institution"), "\\(", extra = "drop") %>%
    mutate(institution = str_replace_all(institution, "\\b(united states)\\b", "u.s.")) %>%
    # specific to the us gov manual and a-z index
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(judicial branch|federal agency - judicial)\\b"),
                                   yes = "u.s. judicial branch", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(legislative branch|the legislative branch|federal agency - legislative)\\b"),
                                   yes = "u.s. legislative branch", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(federal agency - executive|^executive department sub|executive branch: departments|executive department)\\b"),
                                   yes = "u.s. executive branch", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(quasi-official agencies)\\b"),
                                   yes = "u.s. quasi-official agencies", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(international organizations)\\b"),
                                   yes = "u.s. international organizations", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(^export bank|export-import bank of the u.s.)\\b"),
                                   yes = "export/import bank of the u.s.", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(geological survey)\\b"),
                                   yes = "u.s. geological survey", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(^fossil energy)\\b"),
                                   yes = "u.s. fossil energy", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(^forest service)\\b"),
                                   yes = "u.s. forest service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(^senate)\\b"),
                                   yes = "u.s. senate", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(^mint)\\b"),
                                   yes = "u.s. mint", no = institution)) %>%

    # high level departments (non-defense)
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(congress—u.s. house of representatives|house of representatives)\\b"),
                                   yes = "u.s. house of representatives", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(congress—u.s. senate|u.s. senate)\\b"),
                                   yes = "u.s. senate", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(agriculture department|usda|department of agriculture|u.s. department of agriculture|dept of ag|dept of ag.|dept. of ag.|u.s. dept of ag|us dept of ag|u.s. dept. of ag.|u.s. agriculture department)\\b"),
                                   yes = "u.s. department of agriculture", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of commerce|^commerce department)\\b"),
                                   yes = "u.s. department of commerce", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of education|doed|education department)\\b"),
                                   yes = "u.s. department of education", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of energy|doe|energy department)\\b"),
                                   yes = "u.s. department of energy", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of health and human services|hhs|u.s. department of health & human services|health and human services department)\\b"),
                                   yes = "u.s. department of health and human services", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of homeland security|dhs|homeland security department)\\b"),
                                   yes = "u.s. department of homeland security", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of housing and urban development|hud|housing and urban development, department of)\\b"),
                                   yes = "u.s. department of housing and urban development", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of justice|doj|justice department)\\b"),
                                   yes = "u.s. department of justice", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of labor|dol|labor department)\\b"),
                                   yes = "u.s. department of labor", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of state|state department)\\b"),
                                   yes = "u.s. department of state", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of the interior|interior department)\\b"),
                                   yes = "u.s. department of the interior", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of the treasury|treasury department)\\b"),
                                   yes = "u.s. department of the treasury", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(us department of veterans affairs|department of veterans affairs|veterans affairs department)\\b"),
                                   yes = "u.s. department of veterans affairs", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of transportation|transportation department)\\b"),
                                   yes = "u.s. department of transportation", no = institution)) %>%
    # us intelligence and defense
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(defense department|us dod|u.s. dod|u.s. d.o.d.|dept of defense|department of defense)\\b"),
                                   yes = "u.s. department of defense", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(CIA|central intelligence agency)\\b"),
                                   yes = "u.s. central intelligence agency", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(defense finance and accounting service(?! debt)|dfas|defense finance and accounting service)\\b"),
                                   yes = "u.s. defense finance and accounting service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(debt and claims management center|defense finance and accounting service debt and claims management center)\\b"),
                                   yes = "u.s. defense finance and accounting service - debt and claims management center", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(air force research laboratory|air force research labs)\\b"),
                                   yes = "u.s. air force research laboratory", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(air force reserve|us air force reserve command)\\b"),
                                   yes = "u.s. air force reserve command", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(air force(?! reserve)|department of the air force|us air force)\\b"),
                                   yes = "u.s. air force", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of the army|us army(?! corps)|army(?! corps)|u.s. army(?! corps))\\b"),
                                   yes = "u.s. department of the army", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(army corps of engineers|corps of engineers)\\b"),
                                   yes = "u.s. army corps of engineers", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(department of the navy|us navy|navy|u.s. navy)\\b"),
                                   yes = "u.s. department of the navy", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(cyber and infrastructure security agency|cisa|cybersecurity and infrastructure security agency)\\b"),
                                   yes = "u.s. cybersecurity and infrastructure security agency", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(director of national intelligence, office of|director of national intelligence|office of director of national intelligence)\\b"),
                                   yes = "u.s. office of director of national intelligence", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(coast guard)\\b"),
                                   yes = "u.s. coast guard", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(health affairs, assistant secretary of defense for|assistant secretary of defense for health affairs)\\b"),
                                   yes = "u.s. assistant secretary of defense for health affairs", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(marine corps|marines|the marines)\\b"),
                                   yes = "u.s. marine corps", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(u.s. military academy, west point|west point military academy|west point)\\b"),
                                   yes = "u.s. military academy, west point", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(european command)\\b"),
                                   yes = "u.s. european command", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(northern command)\\b"),
                                   yes = "u.s. northern command", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(pacific command)\\b"),
                                   yes = "u.s. pacific command", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(southern command)\\b"),
                                   yes = "u.s. southern command", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(strategic command)\\b"),
                                   yes = "u.s. strategic command", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(central command)\\b"),
                                   yes = "u.s. central command", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(special forces operations command)\\b"),
                                   yes = "u.s. special operations command", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(national guard)\\b"),
                                   yes = "u.s. national guard", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(national guard)\\b"),
                                yes = "u.s. national guard", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(national defense university)\\b"),
                                   yes = "u.s. national defense university", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(information resource management college|national defense university icollege|college of information and cyberspace|national defense university - college of information and cyberspace)\\b"),
                                   yes = "u.s. national defense university - college of information and cyberspace", no = institution)) %>%

    # bureaus
    mutate(institution = ifelse(test = str_detect(string = institution,
            pattern = "\\b(?i)(economics and statistics service|economics, statistics, and cooperative service|economic research service)\\b"),
                                   yes = "u.s. economic research service", no = institution)) %>% # ers
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(environmental management|environmental management, office of|office of environmental management)\\b"),
                                   yes = "u.s. office of environmental management", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(engraving and printing, bureau of|bureau of engraving and printing)\\b"),
                                   yes = "u.s. bureau of engraving and printing", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(economic analysis, bureau of|bureau of economic analysis)\\b"), # bea
                                   yes = "u.s. bureau of economic analysis", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(fiscal service, bureau of the|bureau of the fiscal service)\\b"),
                                   yes = "u.s. bureau of the fiscal service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(industry and security, bureau of|bureau of industry and security)\\b"),
                                   yes = "u.s. bureau of industry and security", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(justice statistics, bureau of|bureau of justice statistics)\\b"),
                                   yes = "u.s. bureau of justice statistics", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(labor statistics, bureau of|bureau of labor statistics)\\b"), # bls
                                   yes = "u.s. bureau of labor statistics", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(land management, bureau of|bureau of land management)\\b"), # blm
                                   yes = "u.s. bureau of land management", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(reclamation, bureau of|bureau of reclamation)\\b"),
                                   yes = "u.s. bureau of reclamation", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(safety and environmental enforcement, bureau of|bureau of safety and environmental enforcement)\\b"),
                                   yes = "u.s. bureau of safety and environmental enforcement", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(transportation statistics, bureau of|bureau of transportation statistics)\\b"),
                                   yes = "u.s. bureau of transportation statistics", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(ca-cst code reuse library|ca/cst/systems integration & innovation division|consular affairs, bureau of|bureau of consular affairs)\\b"),
                                   yes = "u.s. bureau of consular affairs", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
          pattern = "\\b(?i)(bureau of ocean energy management, regulation, & enforcement|ocean energy management, bureau of|bureau of ocean energy management)\\b"),
                                   yes = "u.s. bureau of ocean energy management", no = institution)) %>% # boem
    mutate(institution = ifelse(test = str_detect(string = institution,
    pattern = "\\b(?i)(alcohol, tobacco, firearms and explosives bureau|alcohol, tobacco, and firearms division|alcohol, tobacco, firearms and explosives bureau|bureau of alcohol, tobacco, and firearms|bureau of alcohol, tobacco, firearms and explosives)\\b"), # ATF = acronym
                                   yes = "u.s. bureau of alcohol, tobacco, firearms and explosives", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(international labor affairs, bureau of|bureau of international labor affairs)\\b"), # ATF = acronym
                                   yes = "u.s. bureau of international labor affairs", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(bureau of the census|census bureau|us census bureau)\\b"),
                                   yes = "u.s. census bureau", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(bureau of bureau of indian affairs|indian affairs|bureau of indian affairs)\\b"),
                                   yes = "u.s. bureau of indian affairs", no = institution)) %>%

    # offices
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(housing office|office of housing)\\b"),
                                   yes = "u.s. office of housing", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(compliance, office of|office of compliance)\\b"),
                                   yes = "u.s. office of compliance", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(comptroller of the currency, office of|office of comptroller of the currency|office of the comptroller of the currency)\\b"),
                                   yes = "u.s. office of the comptroller of the currency", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(disability employment policy, office of|office of disability employment policy)\\b"),
                                   yes = "u.s. office of disability employment policy", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
 pattern = "\\b(?i)(Elementary and Secondary Education, Office of|office of elementary and secondary education|u.s. office of elementary and secondary education|innovation and improvement office|office of innovation and improvement)\\b"),
                                   yes = "u.s. office of elementary and secondary education", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(government ethics, office of|office of government ethics)\\b"),
                                   yes = "u.s. office of government ethics", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(justice programs, office of|office of justice programs)\\b"),
                                   yes = "u.s. office of justice programs", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(juvenile justice and delinquency prevention, office of|office of juvenile justice and delinquency prevention)\\b"),
                                   yes = "u.s. office of juvenile justice and delinquency prevention", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(manufactured housing programs, office of|office of manufactured housing programs)\\b"),
                                   yes = "u.s. office of manufactured housing programs", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(minority health, office of|office of minority health)\\b"),
                                   yes = "u.s. office of minority health", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(natural resources revenue, office of|office of natural resources revenue)\\b"),
                                   yes = "u.s. office of natural resources revenue", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(nuclear energy, office of|office of nuclear energy)\\b"),
                                   yes = "u.s. office of nuclear energy", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(pardon attorney, office of|office of pardon attorney)\\b"),
                                   yes = "u.s. office of pardon attorney", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(postsecondary education, office of|office of postsecondary education)\\b"),
                                   yes = "u.s. office of postsecondary education", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(refugee resettlement, office of|office of refugee resettlement)\\b"),
                                   yes = "u.s. office of refugee resettlement", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(science and technology policy, office of|office of science and technology policy)\\b"),
                                   yes = "u.s. office of science and technology policy", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(servicemember affairs, office of|office of servicemember affairs)\\b"),
                                   yes = "u.s. office of servicemember affairs", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(special counsel, office of|office of special counsel)\\b"),
                                   yes = "u.s. office of special counsel", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(special education and rehabilitative services, office of|office of special education and rehabilitative services)\\b"),
                                   yes = "u.s. office of special education and rehabilitative services", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(surface mining, reclamation and enforcement, office of|office of surface mining, reclamation and enforcement)\\b"),
                                   yes = "u.s. office of surface mining, reclamation and enforcement", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(child support enforcement, office of|child support enforcement, office of)\\b"),
                                   yes = "u.s. office of child support enforcement", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(career, technical, and adult education, office of|office of career, technical, and adult education)\\b"),
                                   yes = "u.s. office of career, technical, and adult education", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                           pattern = "\\b(?i)(scientific and technical information, office of|office of scientific and technical information)\\b"),
                                   yes = "u.s. office of scientific and technical information", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(violence against women, office on|office on violence against women|office on violence against women)\\b"),
                                   yes = "u.s. office on violence against women", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(office of surface mining, reclamation and enforcement|office of surface mining reclamation and enforcement)\\b"),
                                   yes = "u.s. office of surface mining reclamation and enforcement", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(office of science and technology)\\b"),
                                   yes = "u.s. office of science and technology policy", no = institution)) %>%

    # courts
    mutate(institution = ifelse(test = str_detect(string = institution,
    pattern = "\\b(?i)(supreme court of the u.s.|the supreme court|supreme court of the us|the supreme court of the u.s.|SCOTUS)\\b"),
                                   yes = "u.s. supreme court", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(court of appeals for veterans claims)\\b"),
                                   yes = "u.s. court of appeals for veterans claims", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(court of appeals for the armed forces)\\b"),
                                   yes = "u.s. court of appeals for the armed forces", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(court of appeals for the federal circuit)\\b"),
                                   yes = "u.s. court of appeals for the federal circuit", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(court of federal claims)\\b"),
                                   yes = "u.s. court of federal claims", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(court of international trade)\\b"),
                                   yes = "u.s. court of international trade", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(bankruptcy courts)\\b"),
                                   yes = "u.s. bankruptcy courts", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(judicial circuit courts of appeal|circuit courts of appeal|u.s. judicial circuit courts of appeal|u.s. circuit courts of appeal|u.s. courts of appeal)\\b"),
                                   yes = "u.s. circuit courts of appeal", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(federal court interpreters)\\b"),
                                   yes = "u.s. federal court interpreters", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(lower courts)\\b"),
                                   yes = "u.s. lower courts", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(special courts)\\b"),
                                   yes = "u.s. special courts", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(tax court)\\b"),
                                   yes = "u.s. tax court", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(court services and offender supervision|court services and offender supervision agency for the district of columbia|court services and offender supervision agency)\\b"),
                                   yes = "u.s. court services and offender supervision agency", no = institution)) %>%

    # other organizations
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(Fire Administration|USFA)\\b"),
                                   yes = "u.s. fire administration", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                   pattern = "\\b(?i)(Federal Home Loan Mortgage Corporation|Freddie Mac|federal home loan mortgage corporation)\\b"),
                                 yes = "u.s. federal home loan mortgage corporation", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(federal national mortgage association|Fannie Mae)\\b"),
                                   yes = "u.s. federal national mortgage association", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(Government National Mortgage Association|Ginnie Mae)\\b"),
                                   yes = "u.s. government national mortgage association", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(united states access board|access board)\\b"),
                                   yes = "u.s. access board", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(administration for children and families|acf)\\b"),
                                   yes = "u.s. administration for children and families", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(advanced distributed learning|adl|adl-aicc)\\b"), # collaboration
                                   yes = "u.s. advanced distributed learning", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution, # contains a collaboration
                                                     pattern = "\\b(?i)(agency for healthcare research and quality|ahrq|agency for health care policy and research)\\b"),
                                   yes = "u.s. agency for healthcare research and quality", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(agency for international development|usaid)\\b"),
                                   yes = "u.s. agency for international development", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(agricultural marketing service|ams)\\b"),
                                   yes = "u.s. agricultural marketing service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(food and agriculture, national institute of|nifa|national institute of food and agriculture|cooperative state research, education, and extension service|national institute of food and agriculture (nifa))\\b"),
                                   yes = "u.s. national institute of food and agriculture", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(advanced research projects agency-energy|energy transformation acceleration fund|arpa-e)\\b"),
                                   yes = "u.s. advanced research projects agency-energy", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(agriculture research service|usda ars)\\b"), # ARS = acronym
                                   yes = "u.s. agricultural research service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(ames laboratory|ames lab|doe ames laboratory|the ames lab)\\b"),
                                   yes = "ames laboratory", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(ames research center)\\b"),
                                   yes = "nasa ames research center", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(tax and trade bureau|bureau of alcohol and tobacco tax and trade|alcohol and tobacco tax and trade bureau)\\b"), # TTB = acronym
                                   yes = "u.s. alcohol and tobacco tax and trade bureau", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(alcohol, drug abuse, and mental health administration|samhsa|substance abuse and mental health services administration)\\b"), # samhsa = acronym
                                   yes = "u.s. substance abuse and mental health services administration", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(national railroad passenger corporation|amtrak)\\b"),
                                   yes = "amtrak", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(animal and plant health inspection service|aphis|animal and plant health inspection service)\\b"),
                                   yes = "u.s. animal and plant health inspection service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(archives, national archives and records administration|nara|national archives and records administration)\\b"),
                                   yes = "u.s. national archives and records administration", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(arctic llc|arctic landscape conservation cooperative)\\b"),
                                   yes = "u.s. arctic landscape conservation cooperative", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(arctic research commission)\\b"),
                                   yes = "u.s. arctic research commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(argonne national laboratory|argonne national lab|argonne national labs)\\b"),
                                   yes = "argonne national laboratory", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(african development bank|african development foundation|nigeria trust fund|banque africaine de développement|banque africaine de dveloppement|banque africaine de developpement)\\b"),
                                   yes = "african development bank group", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(arthritis, musculoskeletal and skin diseases, national institute of|niams|national institute of arthritis, musculoskeletal and skin diseases|national institute of arthritis musculoskeletal and skin diseases)\\b"),
                                   yes = "u.s. national institute of arthritis, musculoskeletal and skin diseases", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(national institute of peace)\\b"),
                                   yes = "u.s. institute of peace", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(national institute of health|nih|national institutes of health)\\b"),
                                   yes = "u.s. national institutes of health", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(food and agriculture, national institute of|nifa|national institute of food and agriculture)\\b"),
                                   yes = "u.s. national institute of food and agriculture", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(national cancer institute|nci|us nci|national cancer institute)\\b"),
                                   yes = "u.s. national cancer institute", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(barry goldwater scholarship and excellence in education foundation|barry goldwater scholarship|barry goldwater foundation|barry goldwater program)\\b"),
                                   yes = "barry m. goldwater scholarship and excellence in education program", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(commission on presidential scholars|presidential scholars commission)\\b"),
                                   yes = "u.s. commission on presidential scholars", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
    pattern = "\\b(?i)(center for parent information and resources|parent information and resources center|parent information and resources center)\\b"),
                                   yes = "center for parent information and resources", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(cdc public health informatics lab|center for disease control|center for disease control and prevention|centers for disease control and prevention)\\b"),
                                   yes = "u.s. centers for disease control and prevention", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(centers for medicare & medicaid services|centers for medicare and medicaid services)\\b"),
                                   yes = "u.s. centers for medicare and medicaid services", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(civil rights division, department of justice|u.s. dept of justice, civil rights division)\\b"),
                                   yes = "u.s. department of justice, civil rights division", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(civil rights, department of health and human services office for)\\b"),
                                   yes = "u.s. department of health and human services, office for civil rights", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(civil rights, department of education office of)\\b"),
                                   yes = "u.s. department of education, office for civil rights", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                  pattern = "\\b(?i)(corporation for national & community service|corporation for national and community service)\\b"),
                                   yes = "u.s. corporation for national and community service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(business usa)\\b"),
                                   yes = "business usa", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(sandia national laboratory)\\b"),
                                   yes = "sandia national laboratories", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(council of inspectors general on integrity and efficiency|council of the inspectors general on integrity and efficiency|inspectors general)\\b"),
                                   yes = "u.s. council of the inspectors general on integrity and efficiency", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(global media, agency for|Agency for Global Media)\\b"),
                                   yes = "u.s. agency for global media", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
      pattern = "\\b(?i)(grain inspection, packers, and stockyards administration|grain inspection, packers and stockyards administration|grain inspection packers and stockyards administration)\\b"),
                                   yes = "u.s. grain inspection, packers and stockyards administration", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(health resources administration|health services administration|hrsa|health resources and services administration)\\b"),
                                   yes = "u.s. health resources and services administration", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(japan-u.s. friendship commission|japan-us friendship commission)\\b"),
                                   yes = "japan-u.s. friendship commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(john f. kennedy center for performing arts|kennedy center)\\b"),
                                   yes = "john f. kennedy center for the performing arts", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(medical payment advisory commission|medpac|medicare payment advisory commission)\\b"),
                                   yes = "u.s. medicare payment advisory commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(medicaid and chip payment and access commission|macpac|medicaid and chip payment and access commission)\\b"),
                                   yes = "u.s. medicaid and chip payment and access commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(occupational safety & health review commission|occupational safety and health review commission)\\b"),
                                   yes = "u.s. occupational safety and health review commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(rural business and cooperative programs|rural business-cooperative service)\\b"),
                                   yes = "u.s. rural business-cooperative service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(u.s. abilityone|u.s. abilityone commission|abilityone|abilityone commission)\\b"),
                                   yes = "u.s. abilityone commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(us-cert|us computer emergency readiness team|computer emergency readiness team)\\b"),
                                   yes = "u.s. computer emergency readiness team", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(^weather service|^national weather service)\\b"),
                                   yes = "u.s. national weather service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(^secret service$)\\b"),
                                   yes = "u.s. secret service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(postal service|us postal service|usps|u.s. postal service|the u.s. postal service|the us postal service)\\b"),
                                   yes = "u.s. postal service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(noaa fisheries|noaa|nmfs|national marine fisheries service)\\b"),
                                   yes = "u.s. national marine fisheries service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(capitol visitor center)\\b"),
                                   yes = "u.s. capitol visitor center", no = institution)) %>%

    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(trade representative)\\b"),
                                   yes = "u.s. trade representative", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                     pattern = "\\b(?i)(fedstats|federal interagency council on statistical policy)\\b"),
                                   yes = "u.s. federal interagency council on statistical policy", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(federal mediation and conciliation service|mediation and conciliation service|FMCS)\\b"),
                                   yes = "u.s. federal mediation and conciliation service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(agriculture library|us agriculture library|us library of agriculture|national library of agriculture)\\b"), # specific to az-index
                                yes = "u.s. national library of agriculture", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(patent and trademark office)\\b"), # specific to az-index
                                yes = "u.s. patent and trademark office", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(industrial college of the armed forces)\\b"),
                                yes = "dwight d. eisenhower school for national security and resource strategy", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(fleet forces command)\\b"),
                                yes = "u.s. fleet forces command", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(office of special education and rehabilitative services)\\b"),
                                yes = "u.s. office of special education and rehabilitative services", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(office of fossil energy|u.s. fossil energy)\\b"),
                                yes = "u.s. office of fossil energy", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(national prevention information network|prevention information network|cdc npin)\\b"),
                                yes = "cdc national prevention information network", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(office of child support enforcement|ocse)\\b"),
                                yes = "u.s. office of child support enforcement", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(customs and border protection)\\b"),
                                yes = "u.s. customs and border protection", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(immigration and customs enforcement|us customs)\\b"), # ice
                                yes = "u.s. immigration and customs enforcement", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(citizenship and immigration services|immigration and citizenship services)\\b"),
                                yes = "u.s. citizenship and immigration services", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(community planning and development|office of community planning and development)\\b"),
                                yes = "u.s. office of community planning and development", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(fair housing and equal opportunity|office of fair housing and equal opportunity)\\b"),
                                yes = "u.s. office of fair housing and equal opportunity", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(office of policy development and research|policy development and research)\\b"),
                                yes = "u.s. office of policy development and research", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(bureau of prisons|federal bureau of prisons)\\b"),
                                yes = "u.s. federal bureau of prisons", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(immigrant and employee rights section|office of immigrant and employee rights)\\b"),
                                yes = "u.s. office of immigrant and employee rights", no = institution)) %>%
   # specific to az-index
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(interpol)\\b"),
                                yes = "u.s. national central bureau - interpol", no = institution)) %>%

    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(office of the pardon attorney|office of pardon attorney)\\b"),
                                yes = "u.s. office of the pardon attorney", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(marshals service)\\b"),
                                yes = "u.s. marshals service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(parole commission)\\b"),
                                yes = "u.s. parole commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(hour and wage division|wage and hour division)\\b"),
                                yes = "u.s. wage and hour division", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(office of disability employment policy)\\b"),
                                yes = "u.s. office of disability employment policy", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(agency for toxic substances and disease registry|ATSDR)\\b"),
                                yes = "cdc agency for toxic substances and disease registry", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(national institute of occupational safety and health|NIOSH)\\b"),
                                yes = "cdc national institute of occupational safety and health", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(environmental protection agency|EPA)\\b"),
                                yes = "u.s. environmental protection ageny", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(general services administration|GSA)\\b"),
                                yes = "u.s. general services administration", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(securities and exchange commission|SEC)\\b"),
                                yes = "u.s. securities and exchange commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(office of personnel management|OPM)\\b"),
                                yes = "u.s. office of personnel management", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(defense intelligence agency|DIA)\\b"),
                                yes = "u.s. defense intelligence agency", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(consumer financial protection bureau|CFPB|u.s. bureau of consumer financial protection|Bureau of Consumer Financial Protection)\\b"),
                                yes = "u.s. consumer financial protection bureau", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(botanic garden)\\b"),
                                yes = "u.s. botanic garden", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(capitol police)\\b"),
                                yes = "u.s. capitol police", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(federal register|office of the federal register)\\b"),
                                yes = "u.s. office of the federal register", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(postal inspection service)\\b"),
                                yes = "u.s. postal inspection service", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(commission of fine arts)\\b"),
                                yes = "u.s. commission of fine arts", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(commodity futures trading commission)\\b"),
                                yes = "u.s. commodity futures trading commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(bureau of consumer financial protection)\\b"),
                                yes = "u.s. bureau of consumer financial protection", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(chemical safety board)\\b"),
                                yes = "u.s. chemical safety board", no = institution)) %>%


    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(commission on security and cooperation in europe|helsinki commission)\\b"),
                                yes = "u.s. commission on security and cooperation in europe", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(election assistance commission)\\b"),
                                yes = "u.s. election assistance commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(nuclear regulatory commission)\\b"),
                                yes = "u.s. nuclear regulatory commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
           pattern = "\\b(?i)(northwest power and conservation council|northwest power planning council|pacific northwest electric power and conservation planning council)\\b"),
                              yes = "u.s. northwest power and conservation council", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(office of cuba broadcasting)\\b"),
                                yes = "radio and tv martí", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(commission on international religious freedom)\\b"),
                                yes = "u.s. commission on international religious freedom", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(international trade commission)\\b"),
                                yes = "u.s. international trade commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(international trade administration)\\b"),
                                yes = "u.s. international trade administration", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(sentencing commission)\\b"),
                                yes = "u.s. sentencing commission", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(trade and development agency)\\b"),
                                yes = "u.s. trade and development agency", no = institution)) %>%

    # white house
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(council of economic advisers)\\b"),
                                yes = "u.s. council of economic advisers", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(council on environmental quality)\\b"),
                                yes = "u.s. council on environmental quality", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(national security council)\\b"),
                                yes = "u.s. national security council", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(office of management and budget)\\b"),
                                yes = "u.s. office of management and budget", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(office of national drug control policy)\\b"),
                                yes = "u.s. office of national drug control policy", no = institution)) %>%

    # exec
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(marketing and regulatory programs)\\b"),
                                yes = "usda marketing and regulatory programs", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(rural development)\\b"),
                                yes = "usda rural development", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(marketing and regulatory programs)\\b"),
                                yes = "usda marketing and regulatory programs", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(national institute of standards and technology)\\b"),
                                yes = "u.s. national institute of standards and technology", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(national oceanic and atmospheric administration)\\b"),
                                yes = "u.s. national oceanic and atmospheric administration", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(unified combatant commands)\\b"),
                                yes = "u.s. unified combatant commands", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(national laboratories)\\b"),
                                yes = "u.s. national laboratories", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(power administrations)\\b"),
                                yes = "u.s. power administrations", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(science office|office of science)\\b"),
                                yes = "u.s. office of science", no = institution)) %>%

    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(food and drug administration)\\b"),
                                yes = "u.s. food and drug administration", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(federal emergency management agency|FEMA)\\b"),
                                yes = "u.s. federal emergency management agency", no = institution)) %>%

###
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(administration for native americans|ANA)\\b"),
                                yes = "u.s. administration for native americans", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(national passport information center|NPIC)\\b"),
                                yes = "u.s. national passport information center", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(federal emergency management agency|FEMA)\\b"),
                                yes = "u.s. federal emergency management agency", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(joint military intelligence college|national defense intelligence college)\\b"),
                                yes = "u.s. national intelligence university", no = institution)) %>%
    mutate(institution = ifelse(test = str_detect(string = institution,
                                                  pattern = "\\b(?i)(joint program executive office for chemical and biological defense|JPEO-CBRND)\\b"),
                                yes = "u.s. joint program executive office for chemical and biological defense", no = institution)) %>%









    data_frame
}















