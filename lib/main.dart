import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'package:flutter/material.dart';
import 'parte1_iso.dart';
import 'parte2_wkm.dart';
import 'parte3_alrm.dart';
import 'parte4_alrm.dart';

void main() async {    
  WidgetsFlutterBinding.ensureInitialized();
  
  //Para a Parte 3
  //await AndroidAlarmManager.initialize();

  //Para Parte 4     
  // IsolateNameServer.registerPortWithName(
  //   port.sendPort,
  //   isolateName,
  // );

  runApp(const Parte1ComIsolate());
  //runApp(const Parte2ComWorkmanager());
  // runApp(const Parte3ComAlarm());
  // runApp(const Parte4ComAlarm());
}