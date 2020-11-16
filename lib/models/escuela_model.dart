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
        this.idRegion,
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
    String idRegion;
    int idZona;
    int idInstructor;
    int idMaestro;
    bool estado;

    factory EscuelaModel.fromJson(Map<String, dynamic> json) => EscuelaModel(
        idEscuela: json["idEscuela"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        idComuna: json["idComuna"],
        idZona: json["idZona"],
        idRegion: json["idRegion"],
        idInstructor: json["idInstructor"],
        idMaestro: json["idMaestro"],
        estado: json["estado"],
        logo: json["logo"]??"",
        logoOriginal: json["logo"]??"",
    );

    Map<String, dynamic> toJson() => {
        "IdEscuela": idEscuela,
        "Logo": logo,
        "logoOriginal": logoOriginal,
        "Nombre": nombre,
        "Direccion": direccion,
        "IdComuna": idComuna,
        "idRegion":idRegion,
        "IdZona": idZona,
        "IdInstructor": idInstructor,
        "IdMaestro": idMaestro,
        "Estado": estado,
    };
}
