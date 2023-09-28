import 'package:flutter/material.dart';

class Btn_Blue extends StatelessWidget {
  
  final String  text;
  final Function onPressed;


  const Btn_Blue({
  Key? key, 
  required this.text, 
  required this.onPressed
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
          style: ElevatedButton.styleFrom(
              primary: Colors.blue, // Color de fondo azul
              elevation: 2.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // Ajusta el valor para hacerlo más o menos redondeado
              ),      // Elevación de 2
            ),
          onPressed: ()=>this.onPressed(), // Llama a la función onPressed si no es nula
                    
          child: Container(
            width: double.infinity,
            height: 50,
            child: Center(
              child: Text(this.text,style: TextStyle(color: Colors.white, fontSize: 17),
            ),
            ),
          )
        );
  }
}