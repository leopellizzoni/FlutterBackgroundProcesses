import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const int idDoAlarme = 1234;
const String isolateExercicios = 'exercicio';

/*
ESTRUTURA DO MAIN

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  IsolateNameServer.registerPortWithName(
    portExercicios.sendPort,
    isolateExercicios,
  );

  runApp(const Parte5Exercicio());
}
*/

ReceivePort portExercicios = ReceivePort();

class Parte5Exercicio extends StatelessWidget {
  const Parte5Exercicio({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(      
      home: _AlarmHomePage(),
    );
  }
}

class _AlarmHomePage extends StatefulWidget {
  const _AlarmHomePage();

  @override
  _AlarmHomePageState createState() => _AlarmHomePageState();
}

class _AlarmHomePageState extends State<_AlarmHomePage> {
  int _counter = 0;
  String msgRetornoAPI = 'Nenhum retorno pela api ainda.';
  
  @override
  void initState() {
    super.initState();
    AndroidAlarmManager.initialize();
    
    portExercicios.listen((inf) async => await _incrementCounter(inf));
  }  

  Future<void> _incrementCounter(valor) async {
    Logger().i('${DateTime.now()} | mais uma execução | $valor');

    setState(() {      
      msgRetornoAPI = valor;
      _counter++;
    });
  }

  static SendPort? uiSendPort;

  @pragma('vm:entry-point')
  static Future<void> callback() async {
    var retorno = 'Executando mas sem retorno';

    final idCom = Random().nextInt(100) + 50; 

    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/comments/$idCom'));
    
    if (response.statusCode == 200) {
      var retornoApi = jsonDecode(response.body);      
      retorno = retornoApi['body'];
    } else {
      retorno = 'A chamada não funcionou. Código de erro: ${response.statusCode}';
    }

    uiSendPort ??= IsolateNameServer.lookupPortByName(isolateExercicios);
    uiSendPort?.send(retorno);
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.headlineSmall;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prática'),
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [        
            const SizedBox(height: 32),    
            Text(
              'Execuções: $_counter',
              style: textStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Text(
              'Retorno API: $msgRetornoAPI',
              style: textStyle,
              textAlign: TextAlign.center,
            ),                       
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () async {
                await AndroidAlarmManager.periodic(
                  const Duration(minutes: 1),
                  idDoAlarme, //ID do nosso alarme
                  callback                  
                );
              },
              child: const Text('Executar a cada 1 min'),
            ),
            ElevatedButton(
              onPressed: () async {
                await AndroidAlarmManager.cancel(idDoAlarme);
              },
              child: const Text('Cencelar execução'),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
