// To parse this JSON data, do
//
//     final DropDownModel = DropDownModelFromJson(jsonString);

import 'dart:convert';

DropDownModel dropDownModelFromJson(String str) => DropDownModel.fromJson(json.decode(str));

String dropDownModelToJson(DropDownModel data) => json.encode(data.toJson());

class DropDownModel {
    DropDownModel({
        this.id,
        this.nombre,
    });

    int id;
    String nombre;

    factory DropDownModel.fromJson(Map<String, dynamic> json) => DropDownModel(
        id: json["id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };
}
