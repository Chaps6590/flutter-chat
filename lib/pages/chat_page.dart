import 'dart:io';

import 'package:chat/widgets/chat_message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';



class ChatPage extends StatefulWidget {

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  
  final _textController = new TextEditingController();
  final _focusNode = new FocusNode();

  List<ChatMessage> _messages = [];

  bool _escribiendo = false;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: <Widget>[
            CircleAvatar(
              child: Text('Te',style: TextStyle(fontSize: 12),),
              backgroundColor: Colors.blue[100],
              maxRadius: 14,
              ),
              SizedBox(height: 3,),
              
              Text('Cesar Sarchi', style: TextStyle(color: Colors.black87, fontSize: 12 ),),

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
      uid: '123',
      animationController:AnimationController(vsync: this, duration: Duration(milliseconds: 400))
      );
    
    _messages.insert(0,newMessage);
    newMessage.animationController.forward();

    setState(() {
      _escribiendo = false;
    });
  }

  @override
  void dispose(){
    for(ChatMessage message in _messages){
      message.animationController.dispose();
    }  
    super.dispose();
  }

}