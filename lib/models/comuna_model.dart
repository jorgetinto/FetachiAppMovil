// To parse this JSON data, do
//
//     final comunaModel = comunaModelFromJson(jsonString);

import 'dart:convert';

ComunaModel comunaModelFromJson(String str) => ComunaModel.fromJson(json.decode(str));

String comunaModelToJson(ComunaModel data) => json.encode(data.toJson());

class ComunaModel {
    ComunaModel({
        this.codComuna,
        this.nombre,
        this.codProvincia,
    });

    String codComuna;
    String nombre;
    String codProvincia;

    factory ComunaModel.fromJson(Map<String, dynamic> json) => ComunaModel(
        codComuna: json["codComuna"],
        nombre: json["nombre"],
        codProvincia: json["codProvincia"],
    );

    Map<String, dynamic> toJson() => {
        "codComuna": codComuna,
        "nombre": nombre,
        "codProvincia": codProvincia,
    };
}
