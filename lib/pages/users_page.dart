import 'package:chat/models/users.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';



class UsersPage extends StatefulWidget {

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {

  RefreshController _refreshController = RefreshController(initialRefresh: false);

  final usuarios=[
    Users(online: true, email: 'cesar@test.com', nombre: 'Cesar', uid: '1'),
    Users(online: true, email: 'cesar2@test.com', nombre: 'Marcos', uid: '2'),
    Users(online: false, email: 'cesar3@test.com', nombre: 'Juan', uid: '3')
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Nombre',style: TextStyle(color: Colors.black54),),
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton( 
          onPressed: (){},         
          icon: Icon(Icons.exit_to_app,color: Colors.black54 )),          
        
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(Icons.check_circle,color: Colors.green[400],),
            //child: Icon(Icons.offline_bolt,color: Colors.red,),
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

  ListTile _usersListTile(Users usuarios) {
    return ListTile(
        title: Text( usuarios.nombre),
        subtitle: Text(usuarios.email),
        leading: CircleAvatar(
          child: Text(usuarios.nombre.substring(0,2)),
          backgroundColor: Colors.blue[100],
        ),
        trailing: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: usuarios.online ? Colors.green[300] : Colors.red,
            borderRadius: BorderRadius.circular(100)
          ),
        ),
      );
  }




  _getUsers() async {
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _refreshController.refreshCompleted();
  }

}

