// To parse this JSON data, do
//
//     final escuelaModel = escuelaModelFromJson(jsonString);

import 'dart:convert';

EscuelaModel escuelaModelFromJson(String str) => EscuelaModel.fromJson(json.decode(str));

String escuelaModelToJson(EscuelaModel data) => json.encode(data.toJson());

class EscuelaModel {
    EscuelaModel({
        this.idEscuela,
        this.logo,
        this.logoOriginal,
        this.nombre,
        this.direccion,
        this.idComuna,
        this.idZona,
        this.idInstructor,
        this.idMaestro,
        this.estado,
    });

    int idEscuela;
    String logo;
    String logoOriginal;
    String nombre;
    String direccion;
    String idComuna;
    int idZona;
    int idInstructor;
    int idMaestro;
    bool estado;

    factory EscuelaModel.fromJson(Map<String, dynamic> json) => EscuelaModel(
        idEscuela: json["IdEscuela"],
        logo: json["Logo"],
        logoOriginal: json["Logo"],
        nombre: json["Nombre"],
        direccion: json["Direccion"],
        idComuna: json["IdComuna"],
        idZona: json["IdZona"],
        idInstructor: json["IdInstructor"],
        idMaestro: json["IdMaestro"],
        estado: json["Estado"],
    );

    Map<String, dynamic> toJson() => {
        "IdEscuela": idEscuela,
        "Logo": logo,
        "logoOriginal": logoOriginal,
        "Nombre": nombre,
        "Direccion": direccion,
        "IdComuna": idComuna,
        "IdZona": idZona,
        "IdInstructor": idInstructor,
        "IdMaestro": idMaestro,
        "Estado": estado,
    };
}
