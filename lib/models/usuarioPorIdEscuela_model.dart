// To parse this JSON data, do
//
//     final usuarioPorIdEscuelaModel = usuarioPorIdEscuelaModelFromJson(jsonString);

import 'dart:convert';

UsuarioPorIdEscuelaModel usuarioPorIdEscuelaModelFromJson(String str) => UsuarioPorIdEscuelaModel.fromJson(json.decode(str));

String usuarioPorIdEscuelaModelToJson(UsuarioPorIdEscuelaModel data) => json.encode(data.toJson());

class UsuarioPorIdEscuelaModel {
    UsuarioPorIdEscuelaModel({
        this.id,
        this.nombres,
        this.comuna,
        this.statusCard,
        this.folio,
        this.imagen,
        this.gradoActual,
        this.escuela,
        this.estado,
    });

    int id;
    String nombres;
    dynamic comuna;
    dynamic statusCard;
    int folio;
    dynamic imagen;
    dynamic gradoActual;
    String escuela;
    bool estado;

    factory UsuarioPorIdEscuelaModel.fromJson(Map<String, dynamic> json) => UsuarioPorIdEscuelaModel(
        id: json["id"],
        nombres: json["nombres"],
        comuna: json["comuna"],
        statusCard: json["statusCard"],
        folio: json["folio"],
        imagen: json["imagen"],
        gradoActual: json["gradoActual"],
        escuela: json["escuela"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombres": nombres,
        "comuna": comuna,
        "statusCard": statusCard,
        "folio": folio,
        "imagen": imagen,
        "gradoActual": gradoActual,
        "escuela": escuela,
        "estado": estado,
    };
}
