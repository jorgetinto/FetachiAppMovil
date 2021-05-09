// To parse this JSON data, do
//
//     final versionModel = versionModelFromJson(jsonString);

import 'dart:convert';

VersionModel versionModelFromJson(String str) => VersionModel.fromJson(json.decode(str));

String versionModelToJson(VersionModel data) => json.encode(data.toJson());

class VersionModel {
    VersionModel({
        this.id,
        this.version,
        this.fechaCreacion,
        this.descripcion,
        this.estado,
    });

    int id;
    String version;
    DateTime fechaCreacion;
    String descripcion;
    bool estado;

    factory VersionModel.fromJson(Map<String, dynamic> json) => VersionModel(
        id: json["id"],
        version: json["version"],
        fechaCreacion: DateTime.parse(json["fechaCreacion"]),
        descripcion: json["descripcion"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "version": version,
        "fechaCreacion": fechaCreacion.toIso8601String(),
        "descripcion": descripcion,
        "estado": estado,
    };
}
