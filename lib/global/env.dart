

import 'dart:io';

class ENV {
  
  static String apiUrl = Platform.isAndroid 
  ? 'http://192.168.0.14:8080/api'
  : 'http://localhost:8080/api';

  static String socketUrl = Platform.isAndroid 
  ? 'http://10.0.2.2:8080'
  : 'http://localhost:8080';

  

}