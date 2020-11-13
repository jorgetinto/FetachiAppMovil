// To parse this JSON data, do
//
//     final zonaModel = zonaModelFromJson(jsonString);

import 'dart:convert';

ZonaModel zonaModelFromJson(String str) => ZonaModel.fromJson(json.decode(str));

String zonaModelToJson(ZonaModel data) => json.encode(data.toJson());

class ZonaModel {
    ZonaModel({
        this.idZona,
        this.nombre,
        this.estado,
    });

    int idZona;
    String nombre;
    bool estado;

    factory ZonaModel.fromJson(Map<String, dynamic> json) => ZonaModel(
        idZona: json["idZona"],
        nombre: json["nombre"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "idZona": idZona,
        "nombre": nombre,
        "estado": estado,
    };
}
