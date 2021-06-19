// To parse this JSON data, do
//
//     final membresiaModel = membresiaModelFromJson(jsonString);

import 'dart:convert';

MembresiaModel membresiaModelFromJson(String str) => MembresiaModel.fromJson(json.decode(str));

String membresiaModelToJson(MembresiaModel data) => json.encode(data.toJson());

class MembresiaModel {
    MembresiaModel({
        this.id,
        this.nombre,
        this.monto,
        this.estado,
    });

    int id;
    String nombre;
    int monto;
    bool estado;

    factory MembresiaModel.fromJson(Map<String, dynamic> json) => MembresiaModel(
        id: json["id"],
        nombre: json["nombre"],
        monto: json["monto"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "monto": monto,
        "estado": estado,
    };
}
