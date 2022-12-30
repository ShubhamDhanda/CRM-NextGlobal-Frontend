class Constants {
  static const String iosClientId =
      "373756743234-smi7ct7k75gfld20nfbhch2k36oc91ag.apps.googleusercontent.com";
  static const String androidClientId =
      "373756743234-du2ljnfisg6vnr6pucjcq7vhrruhg4tv.apps.googleusercontent.com";
  // static String baseURL = "http://192.168.54.150:8080";
  // static String baseURL = "http://conceptdashcrm-env.eba-bjgvjq2h.ca-central-1.elasticbeanstalk.com/";
  static String baseURL = "http://172.16.172.90:8080";
  static String login = "/api/login";

  static String suppliersDashboard = "/api/getDashboard/suppliers";
  static String logisticsDashboard = "/api/getDashboard/logistics";
  static String salesDashboard = "/api/getDashboard/sales";

  static String getAllCustomers = "/api/get/customers";
  static String searchCustomers = "/api/search/customers";
  static String filterCustomers = "/api/filter/customers";
  static String searchFilterCustomers = "/api/search/filter/customers";
  static String getAllCompanies = "/api/get/companies";
  static String getAllShippers = "/api/get/shippers";
  static String getAllSuppliers = "/api/get/suppliers";
  static String getAllEmployees = "/api/get/employees";
  static String getAllProjects = "/api/get/projects";
  static String getAllDataMining = "/api/get/list/dataMining";

  static String getAllRFP = "/api/get/rfp";
  static String getAllBudgets = "/api/get/budgets";
  static String getAllAssets = "/api/get/assets";
  static String getAllSoftware = "/api/get/softwares";
  static String getAllProposals = "/api/get/proposals";
  static String getTasksById = "/api/get/tasksById";
  static String getBudgetById = "/api/get/budget/id";
  static String getRFPById = "/api/get/rfp/id";

  static String getAllProjectNames = "/api/get/projectNames";
  static String getAllCompanyNames = "/api/get/companyNames";
  static String getAllEmployeeNames = "/api/get/employeeNames";
  static String getAllCustomerNames = "/api/get/customerNames";
  static String getAllDistributors = "/api/get/distributors";
  static String getAllContractors = "/api/get/contractors";
  static String getAllConsultants = "/api/get/consultants";
  static String getAllTimesheet = "/api/get/timesheet";
  static String getAllJobTitles = "/api/get/jobTitles";
  static String getCities = "/api/get/list/cities";
  static String getBudgets = "/api/get/list/budgets";
  static String getDepartments = "/api/get/list/departments";
  static String getProjectCategories = "/api/get/list/projectCategories";
  static String getAllProjectRfp = "/api/get/list/projectRfp";
  static String getAllCompetitors = "/api/get/list/competitors";
  static String getAllProducts = "/api/get/list/product";
  static String getAllTakeoffItems = "/api/get/list/takeoffItems";
  static String getAllInventory = "/api/get/list/inventory";

  static String addEmployee = "/api/add/employee";
  static String addContact = "/api/add/contact";
  static String addShipper = "/api/add/shipper";
  static String addSupplier = "/api/add/supplier";
  static String newOrder = "/api/add/order";
  static String addProject = "/api/add/project";
  static String addProposal = "/api/add/proposal";
  static String addBudget = "/api/add/budget";
  static String addRFP = "/api/add/rfp";
  static String addCompany = "/api/add/company";
  static String addToTimeSheet = "/api/add/timesheet";
  static String addTask = "/api/add/task";
  static String addAsset = "/api/add/asset";
  static String addSoftware = "/api/add/software";
  static String addJobTitle = "/api/add/jobTitle";
  static String addCompetitor = "/api/add/competitor";
  static String addProduct = "/api/add/product";
  static String addTakeoff = "/api/add/takeoff";

  static String updateCustomer = "/api/update/client";
  static String updateCompany = "/api/update/company";
  static String updateEmployee = "/api/update/employee";
  static String updateProject = "/api/update/project";
  static String updateTask = "/api/update/task";
  static String updateBudget = "/api/update/budget";
  static String updateRFP = "/api/update/rfp";
  static String updateProposal = "/api/update/proposal";
  static String updateCompetitor = "/api/update/competitor";
  static String updateProduct = "/api/update/product";
  static String updateTakeoff = "/api/update/takeoff";

  static List<String> cities = <String>[
    "Airdrie",
    "Grande Prairie",
    "Red Deer",
    "Beaumont",
    "Hanna",
    "St. Albert",
    "Bonnyville",
    "Hinton",
    "Spruce Grove",
    "Brazeau",
    "Irricana",
    "Strathcona County",
    "Breton",
    "Lacombe",
    "Strathmore",
    "Calgary",
    "Leduc",
    "Sylvan Lake",
    "Camrose",
    "Lethbridge",
    "Swan Hills",
    "Canmore",
    "McLennan",
    "Taber",
    "Didzbury",
    "Medicine Hat",
    "Turner Valley",
    "Drayton Valley",
    "Olds",
    "Vermillion",
    "Edmonton",
    "Onoway",
    "Wood Buffalo",
    "Ft. Saskatchewan",
    "Provost",
    "Burnaby",
    "Lumby",
    "City of Port Moody",
    "Cache Creek",
    "Maple Ridge",
    "Prince George",
    "Castlegar",
    "Merritt",
    "Prince Rupert",
    "Chemainus",
    "Mission",
    "Richmond",
    "Chilliwack",
    "Nanaimo",
    "Saanich",
    "Clearwater",
    "Nelson",
    "Sooke",
    "Colwood",
    "New Westminster",
    "Sparwood",
    "Coquitlam",
    "North Cowichan",
    "Surrey",
    "Cranbrook",
    "North Vancouver",
    "Terrace",
    "Dawson Creek",
    "North Vancouver",
    "Tumbler",
    "Delta",
    "Osoyoos",
    "Vancouver",
    "Fernie",
    "Parksville",
    "Vancouver",
    "Invermere",
    "Peace River",
    "Vernon",
    "Kamloops",
    "Penticton",
    "Victoria",
    "Kaslo",
    "Port Alberni",
    "Whistler",
    "Langley",
    "Port Hardy",
    "Birtle",
    "Flin Flon",
    "Swan River",
    "Brandon",
    "Snow Lake",
    "The Pas",
    "Cranberry Portage",
    "Steinbach",
    "Thompson",
    "Dauphin",
    "Stonewall",
    "Winnipeg",
    "Cap-Pele",
    "Miramichi",
    "Saint John",
    "Fredericton",
    "Moncton",
    "Saint Stephen",
    "Grand Bay-Westfield",
    "Oromocto",
    "Shippagan",
    "Grand Falls",
    "Port Elgin",
    "Sussex",
    "Memramcook",
    "Sackville",
    "Tracadie-Sheila",
    "Argentia",
    "Corner Brook",
    "Paradise",
    "Bishop's Falls",
    "Labrador City",
    "Portaux Basques",
    "Botwood",
    "Mount Pearl",
    "St. John's",
    "Brigus",
    "Town of Hay River",
    "Town of Inuvik",
    "Yellowknife",
    "Amherst",
    "Hants County",
    "Pictou",
    "Annapolis",
    "Inverness County",
    "Pictou County",
    "Argyle",
    "Kentville",
    "Queens",
    "Baddeck",
    "County of Kings",
    "Richmond",
    "Bridgewater",
    "Lunenburg",
    "Shelburne",
    "Cape Breton",
    "Lunenburg County",
    "Stellarton",
    "Chester",
    "Mahone Bay",
    "Truro",
    "Cumberland County",
    "New Glasgow",
    "Windsor",
    "East Hants",
    "New Minas",
    "Yarmouth",
    "Halifax",
    "Parrsboro",
    "Ajax",
    "Halton",
    "Peterborough",
    "Atikokan",
    "Halton Hills",
    "Pickering",
    "Barrie",
    "Hamilton",
    "Port Bruce",
    "Belleville",
    "Hamilton-Wentworth",
    "Port Burwell",
    "Blandford-Blenheim",
    "Hearst",
    "Port Colborne",
    "Blind River",
    "Huntsville",
    "Port Hope",
    "Brampton",
    "Ingersoll",
    "Prince Edward",
    "Brant",
    "James",
    "Quinte West",
    "Brantford",
    "Kanata",
    "Renfrew",
    "Brock",
    "Kincardine",
    "Richmond Hill",
    "Brockville",
    "King",
    "Sarnia",
    "Burlington",
    "Kingston",
    "Sault Ste. Marie",
    "Caledon",
    "Kirkland Lake",
    "Scarborough",
    "Cambridge",
    "Kitchener",
    "Scugog",
    "Chatham-Kent",
    "Larder Lake",
    "Souix Lookout CoC Sioux Lookout",
    "Chesterville",
    "Leamington",
    "Smiths Falls",
    "Clarington",
    "Lennox-Addington",
    "South-West Oxford",
    "Cobourg",
    "Lincoln",
    "St. Catharines",
    "Cochrane",
    "Lindsay",
    "St. Thomas",
    "Collingwood",
    "London",
    "Stoney Creek",
    "Cornwall",
    "Loyalist Township",
    "Stratford",
    "Cumberland",
    "Markham",
    "Sudbury",
    "Deep River",
    "Metro Toronto",
    "Temagami",
    "Dundas",
    "Merrickville",
    "Thorold",
    "Durham",
    "Milton",
    "Thunder Bay",
    "Dymond",
    "Nepean",
    "Tillsonburg",
    "Ear Falls",
    "Newmarket",
    "Timmins",
    "East Gwillimbury",
    "Niagara",
    "Toronto",
    "East Zorra-Tavistock",
    "Niagara Falls",
    "Uxbridge",
    "Elgin",
    "Niagara-on-the-Lake",
    "Vaughan",
    "Elliot Lake",
    "North Bay",
    "Wainfleet",
    "Flamborough",
    "North Dorchester",
    "Wasaga Beach",
    "Fort Erie",
    "North Dumfries",
    "Waterloo",
    "Fort Frances",
    "North York",
    "Waterloo",
    "Gananoque",
    "Norwich",
    "Welland",
    "Georgina",
    "Oakville",
    "Wellesley",
    "Glanbrook",
    "Orangeville",
    "West Carleton",
    "Gloucester",
    "Orillia",
    "West Lincoln",
    "Goulbourn",
    "Osgoode",
    "Whitby",
    "Gravenhurst",
    "Oshawa",
    "Wilmot",
    "Grimsby",
    "Ottawa",
    "Windsor",
    "Guelph",
    "Ottawa-Carleton",
    "Woolwich",
    "Haldimand-Norfork",
    "Owen Sound",
    "York",
    "Alberton",
    "Montague",
    "Stratford",
    "Charlottetown",
    "Souris",
    "Summerside",
    "Cornwall",
    "Alma",
    "Fleurimont",
    "Longueuil",
    "Amos",
    "Gaspe",
    "Marieville",
    "Anjou",
    "Gatineau",
    "Mount Royal",
    "Aylmer",
    "Hull",
    "Montreal",
    "Beauport",
    "Joliette",
    "Montreal Region",
    "Bromptonville",
    "Jonquiere",
    "Montreal-Est",
    "Brosssard",
    "Lachine",
    "Quebec",
    "Chateauguay",
    "Lasalle",
    "Saint-Leonard",
    "Chicoutimi",
    "Laurentides",
    "Sherbrooke",
    "Coaticook",
    "LaSalle",
    "Sorel",
    "Coaticook",
    "Laval",
    "Thetford Mines",
    "Dorval",
    "Lennoxville",
    "Victoriaville",
    "Drummondville",
    "Levis",
    "Avonlea",
    "Melfort",
    "Swift Current",
    "Colonsay",
    "Nipawin",
    "Tisdale",
    "Craik",
    "Prince Albert",
    "Unity",
    "Creighton",
    "Regina",
    "Weyburn",
    "Eastend",
    "Saskatoon",
    "Wynyard",
    "Esterhazy",
    "Shell Lake",
    "Yorkton",
    "Gravelbourg",
    "Carcross",
    "Whitehorse"
  ];

  static List<String> provinces = [
    "Alberta",
    "British Columbia",
    "Manitoba",
    "New Brunswick",
    "Newfoundland And Labrador",
    "Northwest Territories",
    "Nova Scotia",
    "Ontario",
    "Prince Edward Island",
    "Quebec",
    "Saskatchewan",
    "Yukon"
  ];

  static List<String> countries = [
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Anguilla",
    "Antigua & Barbuda",
    "Argentina",
    "Armenia",
    "Aruba",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    "Belize",
    "Benin",
    "Bermuda",
    "Bhutan",
    "Bolivia",
    "Bosnia & Herzegovina",
    "Botswana",
    "Brazil",
    "British Virgin Islands",
    "Brunei",
    "Bulgaria",
    "Burkina Faso",
    "Burundi",
    "Cambodia",
    "Cameroon",
    "Canada",
    "Cape Verde",
    "Cayman Islands",
    "Chad",
    "Chile",
    "China",
    "Colombia",
    "Congo",
    "Cook Islands",
    "Costa Rica",
    "Cote D Ivoire",
    "Croatia",
    "Cruise Ship",
    "Cuba",
    "Cyprus",
    "Czech Republic",
    "Denmark",
    "Djibouti",
    "Dominica",
    "Dominican Republic",
    "Ecuador",
    "Egypt",
    "El Salvador",
    "Equatorial Guinea",
    "Estonia",
    "Ethiopia",
    "Falkland Islands",
    "Faroe Islands",
    "Fiji",
    "Finland",
    "France",
    "French Polynesia",
    "French West Indies",
    "Gabon",
    "Gambia",
    "Georgia",
    "Germany",
    "Ghana",
    "Gibraltar",
    "Greece",
    "Greenland",
    "Grenada",
    "Guam",
    "Guatemala",
    "Guernsey",
    "Guinea",
    "Guinea Bissau",
    "Guyana",
    "Haiti",
    "Honduras",
    "Hong Kong",
    "Hungary",
    "Iceland",
    "India",
    "Indonesia",
    "Iran",
    "Iraq",
    "Ireland",
    "Isle of Man",
    "Israel",
    "Italy",
    "Jamaica",
    "Japan",
    "Jersey",
    "Jordan",
    "Kazakhstan",
    "Kenya",
    "Kuwait",
    "Kyrgyz Republic",
    "Laos",
    "Latvia",
    "Lebanon",
    "Lesotho",
    "Liberia",
    "Libya",
    "Liechtenstein",
    "Lithuania",
    "Luxembourg",
    "Macau",
    "Macedonia",
    "Madagascar",
    "Malawi",
    "Malaysia",
    "Maldives",
    "Mali",
    "Malta",
    "Mauritania",
    "Mauritius",
    "Mexico",
    "Moldova",
    "Monaco",
    "Mongolia",
    "Montenegro",
    "Montserrat",
    "Morocco",
    "Mozambique",
    "Namibia",
    "Nepal",
    "Netherlands",
    "Netherlands Antilles",
    "New Caledonia",
    "New Zealand",
    "Nicaragua",
    "Niger",
    "Nigeria",
    "Norway",
    "Oman",
    "Pakistan",
    "Palestine",
    "Panama",
    "Papua New Guinea",
    "Paraguay",
    "Peru",
    "Philippines",
    "Poland",
    "Portugal",
    "Puerto Rico",
    "Qatar",
    "Reunion",
    "Romania",
    "Russia",
    "Rwanda",
    "Saint Pierre & Miquelon",
    "Samoa",
    "San Marino",
    "Satellite",
    "Saudi Arabia",
    "Senegal",
    "Serbia",
    "Seychelles",
    "Sierra Leone",
    "Singapore",
    "Slovakia",
    "Slovenia",
    "South Africa",
    "South Korea",
    "Spain",
    "Sri Lanka",
    "St Kitts & Nevis",
    "St Lucia",
    "St Vincent",
    "St. Lucia",
    "Sudan",
    "Suriname",
    "Swaziland",
    "Sweden",
    "Switzerland",
    "Syria",
    "Taiwan",
    "Tajikistan",
    "Tanzania",
    "Thailand",
    "Timor L'Este",
    "Togo",
    "Tonga",
    "Trinidad & Tobago",
    "Tunisia",
    "Turkey",
    "Turkmenistan",
    "Turks & Caicos",
    "Uganda",
    "Ukraine",
    "United Arab Emirates",
    "United Kingdom",
    "Uruguay",
    "Uzbekistan",
    "Venezuela",
    "Vietnam",
    "Virgin Islands (US)",
    "Yemen",
    "Zambia",
    "Zimbabwe"
  ];
}
