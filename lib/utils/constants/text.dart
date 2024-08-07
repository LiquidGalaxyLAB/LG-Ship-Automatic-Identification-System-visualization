class AppTexts {
  AppTexts._();

  static const String appName = 'AIS Visualizer';
  static const String visualization = 'Visualization';
  static const String collision = 'Collision';
  static const String selectRegion = 'Select region';
  static const String filter = 'Filter';
  static const String lgConnection = 'LG Connection';
  static const String lgServices = 'LG Services';
  static const String aisCrendentials = 'Credentials';
  static const String about = 'About';

  static const List<String> navBarItems = [
    visualization,
    collision,
    selectRegion,
    filter,
    lgConnection,
    lgServices,
    aisCrendentials,
    about,
  ];
  static const String filterTitle = 'Filter Live Vessels by Ship Type';
  static const String connected = 'Connected';
  static const String disconnected = 'Disconnected';
  static const String aboutAIS = 'About AIS Visualizer';
  static const String aboutDescription =
      'AIS Visualizer utilizes open data provided by the Norwegian Coastal Administration to deliver an intuitive visualization experience.';
  static const String keyFeatures = 'Key Features:';
  static const List<String> features = [
    'Track Ships Live',
    'Check Past Routes',
    'Get Ship Details',
    'Move Through Time',
    'See Future Paths',
    'Collision Risk Management Strategy',
    'Change What Region You See'
  ];
  static const String getStarted = 'Get Started Now!';

  static const String credentialsTitle =
      'Enter your BarentsWatch OpenAIS credentials';

  static const String ip = 'Master Machine IP Address';
  static const String ipHint = 'xxx.xxx.xxx.xxx';
  static const String ipError = 'Please enter IP Address';
  static const String port = 'Master Machine Port Number';
  static const String portHint = '22';
  static const String portError = 'Please enter Port Number';
  static const String username = 'Master Machine Username';
  static const String usernameHint = 'lg';
  static const String usernameError = 'Please enter Username';
  static const String password = 'Master Machine Password';
  static const String passwordHint = 'lg';
  static const String passwordError = 'Please enter Password';
  static const String screenNumber = 'Total Machines in LG Rig';
  static const String screenNumberHint = '3';
  static const String screenNumberError =
      'Please enter Total Machines in LG Rig';
  static const String connect = 'Connect';
  static const String connectionLG = 'Liquid Galaxy Rig Connection Manager';
  static const String connectedSuccessfully = 'Connected to LG Successfully';
  static const String connectionFailed = 'Failed to Connect to LG';

  static const String drawRegion = 'Select Region by Drawing on the Map';
  static const String collisionRisk = 'Collision Risk Strategy';

  static const String clientId = 'Client ID';
  static const String clientIdHint = 'admin@example.com:adm';
  static const String clientSecret = 'Client Secret';
  static const String clientSecretHint = '1i28ajduw9';
  static const String clientIdError =
      'Please enter Client ID and Client Secret';
  static const String clientSecretError = 'Please enter Client Secret';
  static const String getTokens = 'Get Token';
  static const String connectedAisSuccessfully =
      'Token fetched successfully, you are now connected to OpenAIS data!\n Wait for Vessels...';
  static const String connectionAisFailed = 'Failed to fetch token';
  static const String connectionAisFailedExplanation =
      'Make sure you have entered the correct credentials and you have a stable internet connection, then try again.';

  static const String lgServicesDescription =
      'This service is responsible for sending commands to Liquid Galaxy rig if you are connected to it.';
  static const String shutdown = 'Shutdown';
  static const String reboot = 'Reboot';
  static const String relaunch = 'Relaunch';
  static const String clearKML = 'Clear KML';
  static const String setRefresh = 'Set Refresh';
  static const String resetRefresh = 'Reset Refresh';

  static const String notConnectedError =
      'You are not connected to LG. Please connect and try again.';
  static const String error = 'Error!';
  static const String ok = 'Ok';
  static const String cancel = 'Cancel';
  static const String confirmation = 'Confirmation';
  static const String confirmationMessage = 'Are you sure you want to execute?';
  static const String executeServiceSuccess =
      'Service command executed successfully';
  static const String success = 'Success!';
  static const String executeServiceFailed =
      'Failed to execute service command, check the connection or your authentication';

  static const String name = 'Name';
  static const String mmsi = 'MMSI';
  static const String signalReceived = 'Signal Received At';

  static const String navigationDetails = 'Navigation Details';
  static const String vesselCharacteristics = 'Vessel Characteristics';
  static const String physicalDimensions = 'Physical Dimensions';
  static const String positioningDetails = 'Positioning Details';
  static const String routeTracker = 'AIS Route Tracker Timeline';
  static const String routePrediction = 'Fan Chart Route Prediction';

  static const String speedOverGround = 'Speed Over Ground';
  static const String courseOverGround = 'Course Over Ground';
  static const String navigationalStatus = 'Navigational Status';
  static const String rateOfTurn = 'Rate of Turn';
  static const String heading = 'True Heading';
  static const String lastKnownPosition = 'Last known position';

  static const String shipType = 'Ship Type';
  static const String callSign = 'Call Sign';
  static const String destination = 'Destination';
  static const String estimatedArrival = 'Estimated Time of Arrival (ETA)';
  static const String imoNumber = 'IMO Number';
  static const String draught = 'Draught';

  static const String dimensionA = 'Dimension A';
  static const String dimensionB = 'Dimension B';
  static const String dimensionC = 'Dimension C';
  static const String dimensionD = 'Dimension D';
  static const String shipLength = 'Ship Length';
  static const String shipWidth = 'Ship Width';

  static const String positionFixingDeviceType = 'Position Fixing Device Type';
  static const String reportClass = 'Report Class';

  static const String showVesselroute = 'Show the vessel route on the map';
  static const String showVesselChart = 'Show the vessel fan chart on the map';
  static const String dateRange = 'Select Date Range';
  static const String chooseDate = 'Choose start and end date';
  static const String showVesselRoute = 'Show track on the map';
  static const String showPredictionRoute = 'Show fan chart on the map';
  static const String timeToPredict = 'Set Prediction Duration';

  static const String simulate = 'Route Simulation Media Player';

  static const String waitTrackResponse =
      'Waiting for OpenAIS response. Please wait...';
  static const String dialogueTrackResponse = 'Fetching Tarck Data';

  static const List<String> filterItems = [
    '0 - Not available (default)',
    '1-19 - Reserved for future use',
    '20 - Wing in ground (WIG), all ships of this type',
    '21 - Wing in ground (WIG), Hazardous category A',
    '22 - Wing in ground (WIG), Hazardous category B', 
    '23 - Wing in ground (WIG), Hazardous category C',
    '24 - Wing in ground (WIG), Hazardous category D',
    '25 - Wing in ground (WIG), Reserved for future use',
    '26 - Wing in ground (WIG), Reserved for future use',
    '27 - Wing in ground (WIG), Reserved for future use',
    '28 - Wing in ground (WIG), Reserved for future use',
    '29 - Wing in ground (WIG), Reserved for future use',
    '30 - Fishing',
    '31 - Towing',
    '32 - Towing: length exceeds 200m or breadth exceeds 25m',
    '33 - Dredging or underwater ops',
    '34 - Diving ops',
    '35 - Military ops',
    '36 - Sailing',
    '37 - Pleasure Craft',
    '38 - Reserved',
    '39 - Reserved',
    '40 - High speed craft (HSC), all ships of this type',
    '41 - High speed craft (HSC), Hazardous category A',
    '42 - High speed craft (HSC), Hazardous category B',
    '43 - High speed craft (HSC), Hazardous category C',
    '44 - High speed craft (HSC), Hazardous category D',
    '45 - High speed craft (HSC), Reserved for future use',
    '46 - High speed craft (HSC), Reserved for future use',
    '47 - High speed craft (HSC), Reserved for future use',
    '48 - High speed craft (HSC), Reserved for future use',
    '49 - High speed craft (HSC), No additional information',
    '50 - Pilot Vessel',
    '51 - Search and Rescue vessel',
    '52 - Tug',
    '53 - Port Tender',
    '54 - Anti-pollution equipment',
    '55 - Law Enforcement',
    '56 - Spare - Local Vessel',
    '57 - Spare - Local Vessel',
    '58 - Medical Transport',
    '59 - Noncombatant ship according to RR Resolution No. 18',
    '60 - Passenger, all ships of this type',
    '61 - Passenger, Hazardous category A',
    '62 - Passenger, Hazardous category B',
    '63 - Passenger, Hazardous category C',
    '64 - Passenger, Hazardous category D',
    '65 - Passenger, Reserved for future use',
    '66 - Passenger, Reserved for future use',
    '67 - Passenger, Reserved for future use',
    '68 - Passenger, Reserved for future use',
    '69 - Passenger, No additional information',
    '70 - Cargo, all ships of this type',
    '71 - Cargo, Hazardous category A',
    '72 - Cargo, Hazardous category B',
    '73 - Cargo, Hazardous category C',
    '74 - Cargo, Hazardous category D',
    '75 - Cargo, Reserved for future use',
    '76 - Cargo, Reserved for future use',
    '77 - Cargo, Reserved for future use',
    '78 - Cargo, Reserved for future use',
    '79 - Cargo, No additional information',
    '80 - Tanker, all ships of this type',
    '81 - Tanker, Hazardous category A',
    '82 - Tanker, Hazardous category B',
    '83 - Tanker, Hazardous category C',
    '84 - Tanker, Hazardous category D',
    '85 - Tanker, Reserved for future use',
    '86 - Tanker, Reserved for future use',
    '87 - Tanker, Reserved for future use',
    '88 - Tanker, Reserved for future use',
    '89 - Tanker, No additional information',
    '90 - Other Type, all ships of this type',
    '91 - Other Type, Hazardous category A',
    '92 - Other Type, Hazardous category B',
    '93 - Other Type, Hazardous category C',
    '94 - Other Type, Hazardous category D',
    '95 - Other Type, Reserved for future use',
    '96 - Other Type, Reserved for future use',
    '97 - Other Type, Reserved for future use',
    '98 - Other Type, Reserved for future use',
    '99 - Other Type, no additional information',
  ];
}
