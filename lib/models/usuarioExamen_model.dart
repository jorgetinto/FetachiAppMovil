// To parse this JSON data, do
//
//     final usuarioExamenModel = usuarioExamenModelFromJson(jsonString);

import 'dart:convert';

UsuarioExamenModel usuarioExamenModelFromJson(String str) => UsuarioExamenModel.fromJson(json.decode(str));

String usuarioExamenModelToJson(UsuarioExamenModel data) => json.encode(data.toJson());

class UsuarioExamenModel {
    UsuarioExamenModel({
        this.id,
        this.idExamen,
        this.nombres,
        this.comuna,
        this.statusCard,
        this.folio,
        this.imagen,
        this.gradoActual,
        this.fono,
        this.email,
        this.escuela,
        this.perfil,
        this.estado,
    });

    int id;
    int idExamen;
    String nombres;
    String comuna;
    int statusCard;
    int folio;
    String imagen;
    String gradoActual;
    String fono;
    String email;
    String escuela;
    String perfil;
    bool estado;

    factory UsuarioExamenModel.fromJson(Map<String, dynamic> json) => UsuarioExamenModel(
        id: json["id"],
        idExamen: json["idExamen"],
        nombres: json["nombres"],
        comuna: json["comuna"],
        statusCard: json["statusCard"],
        folio: json["folio"],
        imagen: json["imagen"],
        gradoActual: json["gradoActual"],
        fono: json["fono"],
        email: json["email"],
        escuela: json["escuela"],
        perfil: json["perfil"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idExamen": idExamen,
        "nombres": nombres,
        "comuna": comuna,
        "statusCard": statusCard,
        "folio": folio,
        "imagen": imagen,
        "gradoActual": gradoActual,
        "fono": fono,
        "email": email,
        "escuela": escuela,
        "perfil": perfil,
        "estado": estado,
    };
}
