import 'package:chat/models/users.dart';
import 'package:chat/services/auth_services.dart';
import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/services/users_services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



class UsersPage extends StatefulWidget {

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  final usuariosServices = new UsersServices();

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<Users> usuarios =[]; 

  @override
  void initState() {
    this._getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    final authServices = Provider.of<AuthServices>(context);
    final socketService = Provider.of<SocketService>( context );
    
 

    final usuario = authServices.users;

    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre , style: TextStyle(color: Colors.black54),),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton( 
          onPressed: (){
            //socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthServices.deleteToken();            
          },         
          icon: Icon(Icons.exit_to_app,color: Colors.black54 )),          
        
        actions: <Widget>[
          Container(
            
            margin: EdgeInsets.only(right: 10),
 
            child: (socketService.serverStatus == ServerStatus.Online)  
                  ? Icon(Icons.check_circle,color: Colors.green[400],)
                  : Icon(Icons.offline_bolt,color: Colors.red,),
                  
            
          )
        ],
       
        ),        
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _getUsers,
        header: WaterDropHeader(
          complete: Icon(Icons.check,color: Colors.blue[400]),
          waterDropColor:Colors.blue,

        ),
        child: _listViewUsers(),
        ),
  );
}

  ListView _listViewUsers() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i)=> _usersListTile(usuarios[i]), 
      separatorBuilder: (_, i)=>Divider(),
      itemCount: usuarios.length);
  }

  ListTile _usersListTile(Users usuario) {
    return ListTile(
        title: Text( usuario.nombre),
        subtitle: Text(usuario.email),
        leading: CircleAvatar(
          child: Text(usuario.nombre.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuario.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
        onTap: () {
          final chatService = Provider.of<ChatService>(context, listen: false); 
          chatService.usuarioPara = usuario;
          Navigator.pushNamed(context, 'chat');
          },
      );
  }




  _getUsers() async {
    
    

    this.usuarios = await usuariosServices.getUsuarios();

    setState(() {
      
    });

    
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

}

