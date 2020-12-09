// To parse this JSON data, do
//
//     final escuelaPorIdInstructorModel = escuelaPorIdInstructorModelFromJson(jsonString);

import 'dart:convert';

EscuelaPorIdInstructorModel escuelaPorIdInstructorModelFromJson(String str) => EscuelaPorIdInstructorModel.fromJson(json.decode(str));

String escuelaPorIdInstructorModelToJson(EscuelaPorIdInstructorModel data) => json.encode(data.toJson());

class EscuelaPorIdInstructorModel {
    EscuelaPorIdInstructorModel({
        this.idEscuela,
        this.nombre,
        this.direccion,
        this.idComuna,
        this.comuna,
        this.idRegion,
        this.region,
        this.idZona,
        this.zona,
        this.idInstructor,
        this.nombreInstructor,
        this.idMaestro,
        this.nombreMaestro,
        this.logo,
        this.cantidadUsuarios,
        this.estado,
    });

    int idEscuela;
    String nombre;
    String direccion;
    String idComuna;
    String comuna;
    String idRegion;
    String region;
    int idZona;
    String zona;
    int idInstructor;
    String nombreInstructor;
    int idMaestro;
    String nombreMaestro;
    String logo;
    int cantidadUsuarios;
    bool estado;

    factory EscuelaPorIdInstructorModel.fromJson(Map<String, dynamic> json) => EscuelaPorIdInstructorModel(
        idEscuela: json["idEscuela"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        idComuna: json["idComuna"],
        comuna: json["comuna"],
        idRegion: json["idRegion"],
        region: json["region"],
        idZona: json["idZona"],
        zona: json["zona"],
        idInstructor: json["idInstructor"],
        nombreInstructor: json["nombreInstructor"],
        idMaestro: json["idMaestro"],
        nombreMaestro: json["nombreMaestro"],
        logo: json["logo"],
        cantidadUsuarios: json["cantidadUsuarios"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "idEscuela": idEscuela,
        "nombre": nombre,
        "direccion": direccion,
        "idComuna": idComuna,
        "comuna": comuna,
        "idRegion": idRegion,
        "region": region,
        "idZona": idZona,
        "zona": zona,
        "idInstructor": idInstructor,
        "nombreInstructor": nombreInstructor,
        "idMaestro": idMaestro,
        "nombreMaestro": nombreMaestro,
        "logo": logo,
        "cantidadUsuarios":cantidadUsuarios,
        "estado": estado,
    };

    EscuelaPorIdInstructorModel.copy(EscuelaPorIdInstructorModel other)
      : this.idEscuela = other.idEscuela,
        this.nombre = other.nombre,
        this.direccion = other.direccion,
        this.idComuna = other.idComuna,
        this.comuna = other.comuna,
        this.idRegion = other.idRegion,
        this.region = other.region,
        this.idZona = other.idZona,
        this.zona = other.zona,
        this.idInstructor = other.idInstructor,
        this.nombreInstructor = other.nombreInstructor,
        this.idMaestro = other.idMaestro,
        this.nombreMaestro = other.nombreMaestro,
        this.logo = other.logo,
        this.estado = other.estado;
}
