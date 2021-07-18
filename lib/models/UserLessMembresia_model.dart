// To parse this JSON data, do
//
//     final userLessMembresiaModel = userLessMembresiaModelFromJson(jsonString);

import 'dart:convert';

UserLessMembresiaModel userLessMembresiaModelFromJson(String str) => UserLessMembresiaModel.fromJson(json.decode(str));

String userLessMembresiaModelToJson(UserLessMembresiaModel data) => json.encode(data.toJson());

class UserLessMembresiaModel {
    UserLessMembresiaModel({
        this.idUser,
        this.nombre,
        this.idEscuela,
        this.escuela,
        this.idGrado,
        this.grado,
        this.folio,
        this.fechaMembresia,
        this.estadoMembresia,
        this.idMembresia
    });

    int idUser;
    String nombre;
    int idEscuela;
    String escuela;
    int idGrado;
    String grado;
    int folio;
    DateTime fechaMembresia;
    bool estadoMembresia;
    int idMembresia;

    factory UserLessMembresiaModel.fromJson(Map<String, dynamic> json) => UserLessMembresiaModel(
        idUser: json["idUser"],
        nombre: json["nombre"],
        idEscuela: json["idEscuela"],
        escuela: json["escuela"],
        idGrado: json["idGrado"],
        grado: json["grado"],
        folio: json["folio"],
        fechaMembresia:  json["fechaMembresia"] != null ?  DateTime.parse(json["fechaMembresia"]): null, 
        estadoMembresia: json["estadoMembresia"],
        idMembresia : json["idMembresia"]
    );

    Map<String, dynamic> toJson() => {
        "idUser": idUser,
        "nombre": nombre,
        "idEscuela": idEscuela,
        "escuela": escuela,
        "idGrado": idGrado,
        "grado": grado,
        "folio": folio,
        "fechaMembresia": fechaMembresia.toIso8601String(),
        "estadoMembresia": estadoMembresia,
        "idMembresia": idMembresia
    };
}
