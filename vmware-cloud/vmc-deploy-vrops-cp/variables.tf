##################################################################################
# VARIABLES
##################################################################################

# vSphere Settings

variable "vsphere_server" {
  type        = string
  description = "The fully qualified domain name or IP address of the vCenter Server instance."
  sensitive   = true
}
variable "vsphere_username" {
  type        = string
  description = "The username to login to the vCenter Server instance."
  sensitive   = true
}
variable "vsphere_password" {
  type        = string
  description = "The password for the login to the vCenter Server instance."
  sensitive   = true
}
variable "vsphere_insecure" {
  type        = bool
  description = "Allow insecure connections. Set to true for self-signed certificates."
  default     = false
}
variable "vsphere_host" {
  type        = string
  description = "The fully qualified domain name or IP address of the initial ESXi host."
}
variable "vsphere_datacenter" {
  type        = string
  description = "The target vSphere datacenter object name. "
}
variable "vsphere_datastore" {
  type        = string
  description = "The target vSphere datastore object name."
}
variable "vsphere_cluster" {
  type        = string
  description = "The target vSphere cluster object name."
}
variable "vsphere_network" {
  type        = string
  description = "The target vSphere network object name."
}
variable "vsphere_folder" {
  type        = string
  description = "The target vSphere folder object name."
}

# Cloud Proxy Settings

variable "cloud_proxy_ovf_remote" {
  type        = string
  description = "The URL for the cloud proxy OVA file. Leave blank if using local."
  default     = null
}
variable "cloud_proxy_ovf_local" {
  type        = string
  description = "The local path to the cloud proxy OVA file. Leave blank if using remote."
  default     = null
}
variable "cloud_proxy_deployment_option" {
  type        = string
  description = "The deployment option for tge cloud proxy."
  default     = "smallcp"
}

/*
- Small Cloud Proxy = "smallcp"
  Use this configuration for environments up to 8000 VMs. 
  This deployment will require 2 vCPUs and 8GB Memory for the vApp. 

- Standard Cloud Proxy =  "standardcp"
  Use this configuration for environments between 8000 and 40000 VMs. 
  This deployment will require 4 vCPUs and 32GB Memory for the vApp. 

For more detailed sizing information, please visit https://kb.vmware.com/kb/78491.
*/

variable "cloud_proxy_otk" {
  type        = string
  description = "The VMware Cloud Services One Time Key (OTK) to register the virtual appliance."
  sensitive   = true
}
variable "cloud_proxy_root_password" {
  type        = string
  description = "The password for the root user account."
  sensitive   = true
}
variable "cloud_proxy_name" {
  type        = string
  description = "The name for the virtual appliance in the vSphere inventory."
}
variable "cloud_proxy_display_name" {
  type        = string
  description = "The display name to identify this cloud proxy in the VMware Cloud Services portal."
}
variable "cloud_proxy_ipv6_enabled" {
  type        = string
  description = "Enable IPv6 on the virtual appliance. One of `True` or `False`"
  default     = "False"
}
variable "cloud_proxy_timezone" {
  type        = string
  description = "Timezone for the virtual appliance."
  default     = "Etc/UTC"
}

/*
Default: 
  "Etc/UTC"

Options:
  "America/Argentina/Buenos_Aires",
  "Etc/GMT-1",
  "Africa/Abidjan",
  "Africa/Accra",
  "Africa/Addis_Ababa",
  "Africa/Algiers",
  "Africa/Asmara",
  "Africa/Asmera",
  "Africa/Bamako",
  "Africa/Bangui",
  "Africa/Banjul",
  "Africa/Bissau",
  "Africa/Blantyre",
  "Africa/Brazzaville",
  "Africa/Bujumbura",
  "Africa/Cairo",
  "Africa/Cape Verde",
  "Africa/Casablanca",
  "Africa/Ceuta",
  "Africa/Conakry",
  "Africa/Dakar",
  "Africa/Dar_es_Salaam",
  "Africa/Djibouti",
  "Africa/Douala",
  "Africa/El_Aaiun",
  "Africa/Freetown",
  "Africa/Gaborone",
  "Africa/Harare",
  "Africa/Johannesburg",
  "Africa/Juba",
  "Africa/Kampala",
  "Africa/Khartoum",
  "Africa/Kigali",
  "Africa/Kinshasa",
  "Africa/Lagos",
  "Africa/Libreville",
  "Africa/Lome",
  "Africa/Luanda",
  "Africa/Lubumbashi",
  "Africa/Lusaka",
  "Africa/Malabo",
  "Africa/Maputo",
  "Africa/Maseru",
  "Africa/Mbabane",
  "Africa/Mogadishu",
  "Africa/Monrovia",
  "Africa/Nairobi",
  "Africa/Ndjamena",
  "Africa/Niamey",
  "Africa/Nouakchott",
  "Africa/Ouagadougou",
  "Africa/Porto-Novo",
  "Africa/Sao_Tome",
  "Africa/Seychelles",
  "Africa/Timbuktu",
  "Africa/Tripoli",
  "Africa/Tunis",
  "Africa/Windhoek",
  "America/Adak",
  "America/Amazon",
  "America/Anchorage",
  "America/Anguilla",
  "America/Antigua",
  "America/Araguaina",
  "America/Argentina/Catamarca",
  "America/Argentina/ComodRivadavia",
  "America/Argentina/Cordoba",
  "America/Argentina/Jujuy",
  "America/Argentina/La_Rioja",
  "America/Argentina/Mendoza",
  "America/Argentina/Rio_Gallegos",
  "America/Argentina/Salta",
  "America/Argentina/San_Juan",
  "America/Argentina/San_Luis",
  "America/Argentina/Tucuman",
  "America/Argentina/Ushuaia",
  "America/Aruba",
  "America/Asuncion",
  "America/Atikokan",
  "America/Atka",
  "America/Bahia",
  "America/Baker Island",
  "America/Bahia_Banderas",
  "America/Barbados",
  "America/Belem",
  "America/Belize",
  "America/Blanc-Sablon",
  "America/Boa_Vista",
  "America/Bogota",
  "America/Boise",
  "America/Bolivia",
  "America/Brasilia",
  "America/Buenos_Aires",
  "America/Cambridge_Bay",
  "America/Campo_Grande",
  "America/Cancun",
  "America/Caracas",
  "America/Catamarca",
  "America/Cayenne",
  "America/Cayman",
  "America/Chicago",
  "America/Chihuahua",
  "America/Colombia Summer",
  "America/Colombia",
  "America/Coral_Harbour",
  "America/Cordoba",
  "America/Costa_Rica",
  "America/Creston",
  "America/Cuiaba",
  "America/Curacao",
  "America/Danmarkshavn",
  "America/Dawson",
  "America/Dawson_Creek",
  "America/Denver",
  "America/Detroit",
  "America/Dominica",
  "America/Edmonton",
  "America/Eirunepe",
  "America/El_Salvador",
  "America/Ensenada",
  "America/Ecuador",
  "America/Falkland Islands Standard",
  "America/Falkland Islands Summer",
  "America/Falkland Islands",
  "America/Fernando de Noronha",
  "America/Fort_Wayne",
  "America/Fortaleza",
  "America/Glace_Bay",
  "America/Godthab",
  "America/Goose_Bay",
  "America/Grand_Turk",
  "America/Grenada",
  "America/Guadeloupe",
  "America/Guatemala",
  "America/Guayaquil",
  "America/Guyana",
  "America/Halifax",
  "America/Havana",
  "America/Hawaii-Aleutian Daylight",
  "America/Hawaii-Aleutian Standard",
  "America/Hermosillo",
  "America/Indiana/Indianapolis",
  "America/Indiana/Knox",
  "America/Indiana/Marengo",
  "America/Indiana/Petersburg",
  "America/Indiana/Tell_City",
  "America/Indiana/Vevay",
  "America/Indiana/Vincennes",
  "America/Indiana/Winamac",
  "America/Indianapolis",
  "America/Inuvik",
  "America/Iqaluit",
  "America/Jamaica",
  "America/Jujuy",
  "America/Juneau",
  "America/Kentucky/Louisville",
  "America/Kentucky/Monticello",
  "America/Knox_IN",
  "America/Kralendijk",
  "America/La_Paz",
  "America/Lima",
  "America/Los_Angeles",
  "America/Louisville",
  "America/Lower_Princes",
  "America/Maceio",
  "America/Managua",
  "America/Manaus",
  "America/Marigot",
  "America/Martinique",
  "America/Matamoros",
  "America/Mazatlan",
  "America/Mendoza",
  "America/Menominee",
  "America/Merida",
  "America/Metlakatla",
  "America/Mexico_City",
  "America/Miquelon",
  "America/Moncton",
  "America/Monterrey",
  "America/Montevideo",
  "America/Montreal",
  "America/Montserrat",
  "America/Nassau",
  "America/New_York",
  "America/Nipigon",
  "America/Nome",
  "America/Noronha",
  "America/North_Dakota/Beulah",
  "America/North_Dakota/Center",
  "America/North_Dakota/New_Salem",
  "America/Ojinaga",
  "America/Panama",
  "America/Pangnirtung",
  "America/Paraguay Summer",
  "America/Paraguay",
  "America/Paramaribo",
  "America/Peru",
  "America/Phoenix",
  "America/Port_of_Spain",
  "America/Port-au-Prince",
  "America/Porto_Acre",
  "America/Porto_Velho",
  "America/Puerto_Rico",
  "America/Rainy_River",
  "America/Rankin_Inlet",
  "America/Recife",
  "America/Regina",
  "America/Resolute",
  "America/Rio_Branco",
  "America/Rosario",
  "America/Saint Pierre and Miquelon Standard",
  "America/Santa_Isabel",
  "America/Santarem",
  "America/Santiago",
  "America/Santo_Domingo",
  "America/Sao_Paulo",
  "America/Scoresbysund",
  "America/Shiprock",
  "America/Sitka",
  "America/St_Barthelemy",
  "America/St_Johns",
  "America/St_Kitts",
  "America/St_Lucia",
  "America/St_Thomas",
  "America/St_Vincent",
  "America/Suriname",
  "America/Swift_Current",
  "America/Tegucigalpa",
  "America/Thule",
  "America/Thunder_Bay",
  "America/Tijuana",
  "America/Toronto",
  "America/Tortola",
  "America/Uruguay Summer",
  "America/Uruguay Standard",
  "America/Vancouver",
  "America/Venezuelan Standard",
  "America/Virgin",
  "America/Whitehorse",
  "America/Winnipeg",
  "America/Yakutat",
  "America/Yellowknife",
  "Antarctica/Casey",
  "Antarctica/Davis",
  "Antarctica/DumontDUrville",
  "Antarctica/Macquarie",
  "Antarctica/Mawson",
  "Antarctica/McMurdo",
  "Antarctica/Palmer",
  "Antarctica/Rothera",
  "Antarctica/Showa Station",
  "Antarctica/South_Pole",
  "Antarctica/Syowa",
  "Antarctica/Troll",
  "Antarctica/Vostok",
  "Arctic/Longyearbyen",
  "Asia/Aden",
  "Asia/Afghanistan",
  "Asia/Almaty",
  "Asia/Amman",
  "Asia/Anadyr",
  "Asia/Aqtau",
  "Asia/Aqtobe",
  "Asia/Armenia",
  "Asia/Ashgabat",
  "Asia/Ashkhabad",
  "Asia/Azerbaijan",
  "Asia/Baghdad",
  "Asia/Bahrain",
  "Asia/Baku",
  "Asia/Bangkok",
  "Asia/Beirut",
  "Asia/Bhutan",
  "Asia/Bishkek",
  "Asia/Brunei",
  "Asia/Calcutta",
  "Asia/Central Indonesia",
  "Asia/China Standard",
  "Asia/China",
  "Asia/Choibalsan",
  "Asia/Chongqing",
  "Asia/Chungking",
  "Asia/Colombo",
  "Asia/Dacca",
  "Asia/Damascus",
  "Asia/Dhaka",
  "Asia/Dili",
  "Asia/Dubai",
  "Asia/Dumont d'Urville",
  "Asia/Dushanbe",
  "Asia/Gaza",
  "Asia/Gulf Standard",
  "Asia/Harbin",
  "Asia/Hebron",
  "Asia/Ho_Chi_Minh",
  "Asia/Hong Kong",
  "Asia/Hovd",
  "Asia/Indochina",
  "Asia/Irkutsk",
  "Asia/Istanbul",
  "Asia/Jakarta",
  "Asia/Jayapura",
  "Asia/Jerusalem",
  "Asia/Kabul",
  "Asia/Kamchatka",
  "Asia/Karachi",
  "Asia/Kashgar",
  "Asia/Kathmandu",
  "Asia/Katmandu",
  "Asia/Khandyga",
  "Asia/Khovd",
  "Asia/Kolkata",
  "Asia/Krasnoyarsk",
  "Asia/Kuala_Lumpur",
  "Asia/Kyrgyzstan",
  "Asia/Kuching",
  "Asia/Kuwait",
  "Asia/Macao",
  "Asia/Macau",
  "Asia/Magadan",
  "Asia/Makassar",
  "Asia/Malaysia",
  "Asia/Malaysia Standard",
  "Asia/Manila",
  "Asia/Muscat",
  "Asia/Myanmar",
  "Asia/Nepal",
  "Asia/Nicosia",
  "Asia/Novokuznetsk",
  "Asia/Novosibirsk",
  "Asia/Omsk",
  "Asia/Oral",
  "Asia/Pakistan Standard",
  "Asia/Philippine",
  "Asia/Phnom_Penh",
  "Asia/Pontianak",
  "Asia/Pyongyang",
  "Asia/Qatar",
  "Asia/Qyzylorda",
  "Asia/Rangoon",
  "Asia/Riyadh",
  "Asia/Saigon",
  "Asia/Sakhalin",
  "Asia/Samarkand",
  "Asia/Seoul",
  "Asia/Shanghai",
  "Asia/Singapore",
  "Asia/South Georgia and the South Sandwich Islands",
  "Asia/Sri Lanka",
  "Asia/Taipei",
  "Asia/Tajikistan",
  "Asia/Tashkent",
  "Asia/Tbilisi",
  "Asia/Tehran",
  "Asia/Tel_Aviv",
  "Asia/Thailand Standard",
  "Asia/Thimbu",
  "Asia/Thimphu",
  "Asia/Timor Leste",
  "Asia/Tokyo",
  "Asia/Turkmenistan",
  "Asia/Ujung_Pandang",
  "Asia/Ulaanbaatar",
  "Asia/Ulan_Bator",
  "Asia/Urumqi",
  "Asia/Ust-Nera",
  "Asia/Uzbekistan",
  "Asia/Vientiane",
  "Asia/Vladivostok",
  "Asia/Yakutsk",
  "Asia/Yekaterinburg",
  "Asia/Yerevan",
  "Atlantic/Azores",
  "Atlantic/Bermuda",
  "Atlantic/Canary",
  "Atlantic/Cape_Verde",
  "Atlantic/Faeroe",
  "Atlantic/Faroe",
  "Atlantic/Jan_Mayen",
  "Atlantic/Madeira",
  "Atlantic/Reykjavik",
  "Atlantic/South_Georgia",
  "Atlantic/St_Helena",
  "Atlantic/Stanley",
  "Australia/ACT",
  "Australia/Adelaide",
  "Australia/Brisbane",
  "Australia/Broken_Hill",
  "Australia/Canberra",
  "Australia/Currie",
  "Australia/Darwin",
  "Australia/Eucla",
  "Australia/Heard and McDonald Islands",
  "Australia/Hobart",
  "Australia/LHI",
  "Australia/Lindeman",
  "Australia/Lord Howe Standard",
  "Australia/Lord Howe Summer",
  "Australia/Melbourne",
  "Australia/North",
  "Australia/NSW",
  "Australia/Perth",
  "Australia/Queensland",
  "Australia/South",
  "Australia/Sydney",
  "Australia/Tasmania",
  "Australia/Victoria",
  "Australia/West",
  "Australia/Yancowinna",
  "Brazil/Acre",
  "Brazil/DeNoronha",
  "Brazil/East",
  "Brazil/West",
  "Canada/Atlantic",
  "Canada/Central",
  "Canada/Eastern",
  "Canada/East-Saskatchewan",
  "Canada/Mountain",
  "Canada/Newfoundland",
  "Canada/Pacific",
  "Canada/Saskatchewan",
  "Canada/Yukon",
  "Caribbean/Eastern Caribbean",
  "Chile/Continental",
  "Chile/EasterIsland",
  "Cuba",
  "Egypt",
  "Eire",
  "Etc/GMT",
  "Etc/GMT+0",
  "Etc/UCT",
  "Etc/Universal",
  "Etc/UTC",
  "Etc/Zulu",
  "Europe/AIX specific equivalent of Central European",
  "Europe/Amsterdam",
  "Europe/Andorra",
  "Europe/Athens",
  "Europe/Belfast",
  "Europe/Belgrade",
  "Europe/Berlin",
  "Europe/Bratislava",
  "Europe/British Summer",
  "Europe/Brussels",
  "Europe/Bucharest",
  "Europe/Budapest",
  "Europe/Busingen",
  "Europe/Chisinau",
  "Europe/Copenhagen",
  "Europe/Dublin",
  "Europe/Gibraltar",
  "Europe/Guernsey",
  "Europe/Helsinki",
  "Europe/Heure Avancée d'Europe Centrale francised name for CEST",
  "Europe/Irish Standard",
  "Europe/Isle_of_Man",
  "Europe/Istanbul",
  "Europe/Jersey",
  "Europe/Kaliningrad",
  "Europe/Kiev",
  "Europe/Lisbon",
  "Europe/Ljubljana",
  "Europe/London",
  "Europe/Luxembourg",
  "Europe/Madrid",
  "Europe/Malta",
  "Europe/Mariehamn",
  "Europe/Minsk",
  "Europe/Monaco",
  "Europe/Moscow",
  "Europe/Nicosia",
  "Europe/Oslo",
  "Europe/Paris",
  "Europe/Podgorica",
  "Europe/Prague",
  "Europe/Riga",
  "Europe/Rome",
  "Europe/Samara",
  "Europe/San_Marino",
  "Europe/Sarajevo",
  "Europe/Simferopol",
  "Europe/Skopje",
  "Europe/Sofia",
  "Europe/Stockholm",
  "Europe/Tallinn",
  "Europe/Tirane",
  "Europe/Tiraspol",
  "Europe/Uzhgorod",
  "Europe/Vaduz",
  "Europe/Vatican",
  "Europe/Vienna",
  "Europe/Vilnius",
  "Europe/Volgograd",
  "Europe/Warsaw",
  "Europe/Zagreb",
  "Europe/Zaporozhye",
  "Europe/Zurich",
  "GB",
  "GB-Eire",
  "GMT",
  "GMT+0",
  "GMT0",
  "GMT-0",
  "Greenwich",
  "Hongkong",
  "Iceland",
  "Indian/Antananarivo",
  "Indian/Chagos",
  "Indian/British Indian Ocean",
  "Indian/Christmas",
  "Indian/Cocos",
  "Indian/Comoro",
  "Indian/Indian Standard",
  "Indian/Kerguelen",
  "Indian/Mahe",
  "Indian/Maldives",
  "Indian/Mauritius",
  "Indian/Mayotte",
  "Indian/Reunion",
  "Iran",
  "Israel",
  "Jamaica",
  "Japan",
  "Kwajalein",
  "Libya",
  "Mexico/BajaNorte",
  "Mexico/BajaSur",
  "Mexico/General",
  "Navajo",
  "NZ",
  "NZ-CHAT",
  "Pacific/Apia",
  "Pacific/Auckland",
  "Pacific/Chamorro",
  "Pacific/Chatham",
  "Pacific/Chuuk",
  "Pacific/Clipperton",
  "Pacific/Cook Island",
  "Pacific/Easter Island Standard",
  "Pacific/Easter Island Summer",
  "Pacific/Efate",
  "Pacific/Enderbury",
  "Pacific/Fakaofo",
  "Pacific/Fiji",
  "Pacific/Funafuti",
  "Pacific/Galapagos",
  "Pacific/Gambier",
  "Pacific/Gilbert Island",
  "Pacific/Guadalcanal",
  "Pacific/Guam",
  "Pacific/Honolulu",
  "Pacific/Johnston",
  "Pacific/Kiritimati",
  "Pacific/Kosrae",
  "Pacific/Kwajalein",
  "Pacific/Line Islands",
  "Pacific/Majuro",
  "Pacific/Marquesas",
  "Pacific/Marshall Islands",
  "Pacific/Midway",
  "Pacific/Nauru",
  "Pacific/New Caledonia",
  "Pacific/New Zealand Daylight",
  "Pacific/New Zealand Standard",
  "Pacific/Niue",
  "Pacific/Norfolk",
  "Pacific/Noumea",
  "Pacific/Pago_Pago",
  "Pacific/Palau",
  "Pacific/Papua New Guinea",
  "Pacific/Pitcairn",
  "Pacific/Pohnpei",
  "Pacific/Ponape",
  "Pacific/Port_Moresby",
  "Pacific/Rarotonga",
  "Pacific/Saipan",
  "Pacific/Samoa",
  "Pacific/Solomon Islands",
  "Pacific/Tahiti",
  "Pacific/Tarawa",
  "Pacific/Tokelau",
  "Pacific/Tongatapu",
  "Pacific/Truk",
  "Pacific/Tuvalu",
  "Pacific/Vanuatu",
  "Pacific/Wake",
  "Pacific/Wallis",
  "Pacific/Yap",
  "Poland",
  "Portugal",
  "PRC",
  "ROC",
  "ROK",
  "Singapore",
  "Turkey",
  "UCT",
  "Universal/Universal Time Coordinated",
  "US/Alaska",
  "US/Aleutian",
  "US/Arizona",
  "US/Central",
  "US/Eastern",
  "US/East-Indiana",
  "US/Hawaii",
  "US/Indiana-Starke",
  "US/Michigan",
  "US/Mountain",
  "US/Pacific",
  "US/Samoa",
  "UTC",
  "W-SU",
  "Zulu"
*/
variable "cloud_proxy_certificate" {
  type        = string
  description = "Custom certificate for the virtual appliance."
  default     = null
}
variable "cloud_proxy_network_proxy_hostname_ip" {
  type        = string
  description = "The fully qualified domain name or IP address of the network proxy. Leave blank if no network proxy is required."
  default     = null
}
variable "cloud_proxy_network_proxy_port" {
  type        = string
  description = "The port for the network proxy. Leave blank if no network proxy is required."
  default     = null
}
variable "cloud_proxy_network_proxy_username" {
  type        = string
  description = "The username to authentication to the network proxy. Leave blank if no proxy authentication is required. "
  default     = null
  sensitive   = true
}
variable "cloud_proxy_network_proxy_password" {
  type        = string
  description = "The password to authentication to the network proxy. Leave blank if no proxy authentication is required."
  default     = null
  sensitive   = true
}
variable "cloud_proxy_network_proxy_ssl_enabled" {
  type        = string
  description = "Use SSL connection to the network proxy. One of `True` or `False`"
  default     = "False"
}
variable "cloud_proxy_network_proxy_ssl_verification" {
  type        = string
  description = "Verify the network proxy SSL certificate. One of `True` or `False`"
  default     = "False"
}
variable "cloud_proxy_ip_address" {
  type        = string
  description = "The IP address for the network interface on the virtual appliance. Leave blank if DHCP is desired."
}
variable "cloud_proxy_netmask" {
  type        = string
  description = "The netmask or prefix for the network interface on the virtual appliance. Leave blank if DHCP is desired."
}
variable "cloud_proxy_gateway" {
  type        = string
  description = "The default gateway address for the virtual appliance. Leave blank if DHCP is desired."
}
variable "cloud_proxy_dns_servers" {
  type        = string
  description = "The DNS server IP addresses (comma separated) for name resolution. Leave blank if DHCP is desired."
}
variable "cloud_proxy_ntp_servers" {
  type        = string
  description = "The NTP server fully qualified domain names or IP addresses (comma separated) for time synchronization."
}
variable "cloud_proxy_domain" {
  type        = string
  description = "The domain name for the virtual appliance. Leave blank if DHCP is desired."
}
variable "cloud_proxy_dns_search" {
  type        = string
  description = "The domain search path (comma or space separated domain names) for the virtual appliance. Leave blank if DHCP is desired."
}
variable "cloud_proxy_disk_provisioning" {
  type        = string
  description = "The disk provisioning option for the virtual appliance."
  default     = "thin"
}