// To parse this JSON data, do
//
//     final examenModel = examenModelFromJson(jsonString);

import 'dart:convert';

ExamenModel examenModelFromJson(String str) => ExamenModel.fromJson(json.decode(str));

String examenModelToJson(ExamenModel data) => json.encode(data.toJson());

class ExamenModel {
    ExamenModel({
        this.idExamen,
        this.fecha,
        this.nombre,
        this.direcion,
        this.idComuna,
        this.nombreComuna,
        this.idMaestro,
        this.nombreMaestro,
        this.idZona,
        this.nombreZona,
        this.estado,
    });

    int idExamen;
    DateTime fecha;
    String nombre;
    String direcion;
    String idComuna;
    String nombreComuna;
    int idMaestro;
    String nombreMaestro;
    int idZona;
    String nombreZona;
    bool estado;

    factory ExamenModel.fromJson(Map<String, dynamic> json) => ExamenModel(
        idExamen: json["idExamen"],
        fecha: DateTime.parse(json["fecha"]),
        nombre: json["nombre"],
        direcion: json["direcion"],
        idComuna: json["idComuna"],
        nombreComuna: json["nombreComuna"],
        idMaestro: json["idMaestro"],
        nombreMaestro: json["nombreMaestro"],
        idZona: json["idZona"],
        nombreZona: json["nombreZona"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "idExamen": idExamen,
        "fecha": fecha.toIso8601String(),
        "nombre": nombre,
        "direcion": direcion,
        "idComuna": idComuna,
        "nombreComuna": nombreComuna,
        "idMaestro": idMaestro,
        "nombreMaestro": nombreMaestro,
        "idZona": idZona,
        "nombreZona": nombreZona,
        "estado": estado,
    };
}
