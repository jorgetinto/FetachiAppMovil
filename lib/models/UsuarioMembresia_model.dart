// To parse this JSON data, do
//
//     final usuarioMembresiaModel = usuarioMembresiaModelFromJson(jsonString);

import 'dart:convert';

UsuarioMembresiaModel usuarioMembresiaModelFromJson(String str) => UsuarioMembresiaModel.fromJson(json.decode(str));

String usuarioMembresiaModelToJson(UsuarioMembresiaModel data) => json.encode(data.toJson());

class UsuarioMembresiaModel {
    UsuarioMembresiaModel({
        this.id,
        this.idUsuario,
        this.idMembresia,
        this.fechaPago,
        this.fechaPagoTxt,
        this.estado,
        this.nombreUsuario,
        this.nombreEscuela
    });

    int id;
    int idUsuario;
    int idMembresia;
    DateTime fechaPago;
    String fechaPagoTxt;
    bool estado;
    String nombreUsuario;
    String nombreEscuela;

    factory UsuarioMembresiaModel.fromJson(Map<String, dynamic> json) => UsuarioMembresiaModel(
        id: json["id"],
        idUsuario: json["idUsuario"],
        idMembresia: json["idMembresia"],
        fechaPago: DateTime.parse(json["fechaPago"]),
        fechaPagoTxt: json["fechaPagoTxt"],
        estado: json["estado"],
        nombreUsuario: json["nombreUsuario"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idUsuario": idUsuario,
        "idMembresia": idMembresia,
        "fechaPago": fechaPago.toIso8601String(),
        "fechaPagoTxt": fechaPagoTxt,
        "estado": estado,
    };
}
