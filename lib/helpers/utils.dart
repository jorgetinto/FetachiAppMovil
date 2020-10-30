import 'package:fetachiappmovil/models/userPerfil_model.dart';
import 'package:fetachiappmovil/pages/editarPerfil_page.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toast/toast.dart';


  Widget division() {
    return Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[          
              Divider(
                color: Colors.black54,
              ),
            ],
          ),
        );
  }

  Widget buildTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
          ),
          Divider(
            color: Colors.black54,
          ),
        ],
      ),
    );
  }  

  void showToast(BuildContext context, String msg) {
    Toast.show( msg, context, duration: 2, gravity: Toast.BOTTOM);
  }

  calculateAge(String strDt) {
    if (strDt != null || strDt != "null") {
      DateTime birthDate = DateTime.parse(strDt);
      DateTime currentDate = DateTime.now();
      int age = currentDate.year - birthDate.year;
      int month1 = currentDate.month;
      int month2 = birthDate.month;

      if (month2 > month1) {
        age--;
      } else if (month1 == month2) {
        int day1 = currentDate.day;
        int day2 = birthDate.day;
        if (day2 > day1) {
          age--;
        }
      }
      return age.toString();
    }else {
      return 0;
    }
  }

  Widget buildHeader(BuildContext context, AsyncSnapshot<UserPerfilModel> snapshot, bool tipoFoto){

  return Row(
    children: [
        SizedBox(width: 20.0,),

        Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[
              Container(
                  width: 80.0,
                  height: 80.0,
                  child: CircleAvatar(
                    radius: 30.0,
                    child: (tipoFoto) ? Image.asset('assets/img/FETACHI.png') 
                                      :  (snapshot.data.imagen != null)?  ClipOval(child: Container(child: Image.network(snapshot.data.imagen))): Container(height: 0, width: 0,) ,
                    backgroundColor: Colors.white,
                  ),
                  
                ),         

                Positioned(
                  left: 50.0,
                  right: 0.0,
                  bottom: 0.0, 
                  top: 50.0,
                  child: (!tipoFoto)? 
                                  MaterialButton(
                                        onPressed: () {
                                         Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => EditarPerfilPage(),
                                              settings: RouteSettings(
                                                arguments: snapshot.data,
                                              ),
                                            ),
                                          );    
                                      },
                                    color: Colors.blue,
                                    textColor: Colors.white,
                                    child: Icon(Icons.edit, size: 20.0),
                                    padding: EdgeInsets.all(5),
                                    shape: CircleBorder(),
                                  ): Container(width: 0,height: 0,)
              ),
            ]
        ),

       SizedBox(width: 10.0,),

        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
                      Text("${snapshot.data.nombres} \n${snapshot.data.apellidoPaterno}  ${snapshot.data.apellidoMaterno}", maxLines: 20, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
                      SizedBox(height: 5.0,),
                      Text("Rut: ${snapshot.data.rut}", style: TextStyle(fontSize: 13.0),),
                      SizedBox(height: 5.0,),
                      Text("Folio: ${snapshot.data.folio}", style: TextStyle(fontSize: 13.0),), 
                      SizedBox(height: 5.0,),
                       Text("Status Card: ${snapshot.data.statusCard?? "N/A"}", style: TextStyle(fontSize: 13.0),), 
                      SizedBox(height: 5.0,),
                      Row(
                        children: [
                          FaIcon(FontAwesomeIcons.map, size: 10.0, color: Colors.black54,),
                          SizedBox(height: 10.0,),
                          Text(" ${snapshot.data.direccion}, ${snapshot.data.comuna?? " "}", style: TextStyle(color: Colors.black54)),
                        ],
                      )
                    ],
        ),
      ],
    );
  }

  class ListItem {
    int value;
    String name;

    ListItem(this.value, this.name);
  }