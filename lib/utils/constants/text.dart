class AppTexts {
  AppTexts._();

  static const String appName = 'AIS Visualizer';
  static const String visualization = 'Visualization';
  static const String collision = 'Collision';
  static const String selectRegion = 'Select region';
  static const String filter = 'Filter';
  static const String lgConnection = 'LG Connection';
  static const String lgServices = 'LG Services';
  static const String about = 'About';

  static const List<String> navBarItems = [
    visualization,
    collision,
    selectRegion,
    filter,
    lgConnection,
    lgServices,
    about,
  ];
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

  static const String lgServicesDescription =
      'This service is responsible for sending commands to Liquid Galaxy rig if you are connected to it.';
  static const String shutdown = 'Shutdown';
  static const String reboot = 'Reboot';
  static const String relaunch = 'Relaunch';
  static const String clearKML = 'Clear KML';

  static const String notConnectedError =
      'You are not connected to LG. Please connect and try again.';
  static const String error = 'Error!';
  static const String ok = 'Ok';
  static const String executeServiceSuccess =
      'Service command executed successfully';
  static const String success = 'Success!';
  static const String executeServiceFailed =
      'Failed to execute service command, check the connection or your authentication';

  static const String navigationDetails = 'Navigation Details';
  static const String vesselCharacteristics = 'Vessel Characteristics';
  static const String physicalDimensions = 'Physical Dimensions';
  static const String positioningDetails = 'Positioning Details';
  static const String routeTracker = 'AIS Route Tracker Timeline';
  static const String routePrediction = 'Fan Chart Route Prediction';

}
