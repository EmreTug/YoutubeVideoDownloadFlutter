import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:socket_io_client/socket_io_client.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _number = 0;
  late IO.Socket socket;

  @override
  void initState() {
    super.initState();
  IO.Socket socket = IO.io('127.0.0.1:5000',
      OptionBuilder()
       .setTransports(['websocket']).build());
    socket.connect();
    socket.onConnect((_) {
     print('connect');
    });
     socket.on('connect', (data) {
      print(data+"dsdsd");
    });
 
    //When an event recieved from server, data is added to the stream
    // socket.on('event', (data) => streamSocket.addResponse);
    socket.onDisconnect((_) => print('disconnect'));
  
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: Text(_number.toString()),
        ),
    );
  }
}
