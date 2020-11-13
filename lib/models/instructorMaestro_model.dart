// To parse this JSON data, do
//
//     final instructorMaestroModel = instructorMaestroModelFromJson(jsonString);

import 'dart:convert';

InstructorMaestroModel instructorMaestroModelFromJson(String str) => InstructorMaestroModel.fromJson(json.decode(str));

String instructorMaestroModelToJson(InstructorMaestroModel data) => json.encode(data.toJson());

class InstructorMaestroModel {
    InstructorMaestroModel({
        this.id,
        this.nombre,
    });

    int id;
    String nombre;

    factory InstructorMaestroModel.fromJson(Map<String, dynamic> json) => InstructorMaestroModel(
        id: json["id"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
    };
}
