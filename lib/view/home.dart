import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<String> itemList = [
    'Escanear Codigos',
    'Reconocer Objetos',
    'Detectar Dinero',
    'Configuracion',
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f131e),

      body: ListView.builder(
        itemCount: itemList.length,
        itemBuilder: (context, index) {

          return GestureDetector(
            onTap: (){
/*
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const HomeDetectar()
                    )
                );
*/
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 16),
              child: SizedBox(
                child: Card(
                  color: const Color(0xff252f49),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(32),
                        child: Text(itemList[index],style: const TextStyle(
                          fontSize: 22
                        ),),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),

    );
  }
}


