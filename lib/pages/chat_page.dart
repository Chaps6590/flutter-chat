import 'dart:io';

import 'package:chat/models/mensajes_response.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as Console;



class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  late ChatService chatService;
  late SocketService socketService;
  late AuthServices authServices;

  List<ChatMessage> _messages = [];

  bool _escribiendo = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    this.chatService   = Provider.of<ChatService>(context,listen: false);
    this.socketService = Provider.of<SocketService>(context,listen: false);
    this.authServices = Provider.of<AuthServices>(context,listen: false);

    this.socketService.socket.on('msg', _escucharMensaje);

    _cargarHistorial( this.chatService.usuarioPara.uid );

  }

  void _cargarHistorial( String usuarioID ) async{

    List<Mensaje> chat = await this.chatService.getChat(usuarioID);

    final history = chat.map((m) => new ChatMessage(
      texto: m.mensaje, 
      uid: m.de, 
      animationController: new AnimationController(vsync: this,duration: Duration(milliseconds: 0))..forward())
    );

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje( dynamic payload ){
    Console.log('$payload');

    ChatMessage message = new ChatMessage(
      texto: payload['mensaje'], 
      uid: payload['de'], 
      animationController: AnimationController(vsync: this, duration: Duration(milliseconds: 300))
      );

      setState(() {
        _messages.insert(0, message);
      });

      message.animationController.forward();

  }
  
  @override
  Widget build(BuildContext context) {
    

    final usuarioPara = this.chatService.usuarioPara;
    

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text(usuarioPara.nombre.substring(0,2),style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              ),
              SizedBox(height: 3,),
              
              Text(usuarioPara.nombre, style: TextStyle(color: Colors.black87, fontSize: 12 ),),

          ],
        ),
        centerTitle: true,
        elevation: 4,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Flexible(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: _messages.length,
                itemBuilder: ( _ , i ) => _messages[i],
                reverse: true,
                )
                ),
            Divider(height: 1),

            Container(
              color: Colors.white,
              
              child: _inputChat(),
            )


          ],),
      ),
  );
}

  Widget _inputChat(){


    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handSubmit,
                onChanged: (String texto){
                  setState(() {
                    if(texto.trim().length > 0){
                      _escribiendo = true;                      
                    }else
                      _escribiendo =false;
                  });
                },
                decoration: InputDecoration.collapsed(
                  hintText: 'Enviar Mensaje'),                
                focusNode: _focusNode,
              )
            ),
            
            Container(
              margin: EdgeInsets.symmetric( horizontal: 4.0),
              child: Platform.isIOS
              ? CupertinoButton(
                child: Text('Enviar'), 
                onPressed: _escribiendo 
                                ? () => _handSubmit( _textController.text.trim() )
                                : null ,
                )
              : 
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.0),
                  child: IconTheme(
                    data: IconThemeData(color: Colors.blue[400]),
                    child: IconButton(
                      highlightColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      icon: Icon( Icons.send,),
                      onPressed: _escribiendo 
                                ? () => _handSubmit( _textController.text.trim() )
                                : null ,
                      ),
                  ),
                  ),                
            ),  
            
          
          ],
        ),
      )
    );
  }

  _handSubmit(String texto){

    if(texto.length == 0) return;

    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = new ChatMessage(
      texto: texto, 
      uid: authServices.users.uid,
      animationController:AnimationController(vsync: this, duration: Duration(milliseconds: 400))
      );
    
    _messages.insert(0,newMessage);
    newMessage.animationController.forward();

    setState(() {
      _escribiendo = false;
    });
    
    this.socketService.emit('msg', {
      'de': this.authServices.users.uid,
      'para': this.chatService.usuarioPara.uid,
      'mensaje': texto
    });

  }

  @override
  void dispose(){
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }  

    this.socketService.socket.off('msg');

    super.dispose();
  }

}