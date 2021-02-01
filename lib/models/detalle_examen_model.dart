// To parse this JSON data, do
//
//     final detalleExamenModel = detalleExamenModelFromJson(jsonString);

import 'dart:convert';

DetalleExamenModel detalleExamenModelFromJson(String str) => DetalleExamenModel.fromJson(json.decode(str));

String detalleExamenModelToJson(DetalleExamenModel data) => json.encode(data.toJson());

class DetalleExamenModel {
    DetalleExamenModel({
        this.idDetalle,
        this.idEstudiante,
        this.nombreEstudiante,
        this.idExamen,
        this.nombreExamen,
        this.asistencia,
        this.tarea,
        this.notaExamen,
        this.notaFinal,
        this.observaciones,
        this.fecha,
        this.idInstructor,
        this.nombreInstructor,
        this.idExaminador,
        this.nombreExaminador,
        this.idGradoActual,
        this.nombreGradoActual,
        this.idGradoAscenso,
        this.nombreGradoAscenso,
        this.estado,
    });

    int idDetalle;
    int idEstudiante;
    String nombreEstudiante;
    int idExamen;
    String nombreExamen;
    double asistencia;
    double tarea;
    double notaExamen;
    double notaFinal;
    String observaciones;
    DateTime fecha;
    int idInstructor;
    String nombreInstructor;
    int idExaminador;
    String nombreExaminador;
    int idGradoActual;
    String nombreGradoActual;
    int idGradoAscenso;
    String nombreGradoAscenso;
    bool estado;

    factory DetalleExamenModel.fromJson(Map<String, dynamic> json) => DetalleExamenModel(
        idDetalle: json["idDetalle"],
        idEstudiante: json["idEstudiante"],
        nombreEstudiante: json["nombreEstudiante"],
        idExamen: json["idExamen"],
        nombreExamen: json["nombreExamen"],
        asistencia: json["asistencia"],
        tarea: json["tarea"],
        notaExamen: json["notaExamen"],
        notaFinal: json["notaFinal"],
        observaciones: json["observaciones"],
        fecha: DateTime.parse(json["fecha"]),
        idInstructor: json["idInstructor"],
        nombreInstructor: json["nombreInstructor"],
        idExaminador: json["idExaminador"],
        nombreExaminador: json["nombreExaminador"],
        idGradoActual: json["idGradoActual"],
        nombreGradoActual: json["nombreGradoActual"],
        idGradoAscenso: json["idGradoAscenso"],
        nombreGradoAscenso: json["nombreGradoAscenso"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "idDetalle": idDetalle,
        "idEstudiante": idEstudiante,
        "nombreEstudiante": nombreEstudiante,
        "idExamen": idExamen,
        "nombreExamen": nombreExamen,
        "asistencia": asistencia,
        "tarea": tarea,
        "notaExamen": notaExamen,
        "notaFinal": notaFinal,
        "observaciones": observaciones,
        "fecha": fecha.toIso8601String(),
        "idInstructor": idInstructor,
        "nombreInstructor": nombreInstructor,
        "idExaminador": idExaminador,
        "nombreExaminador": nombreExaminador,
        "idGradoActual": idGradoActual,
        "nombreGradoActual": nombreGradoActual,
        "idGradoAscenso": idGradoAscenso,
        "nombreGradoAscenso": nombreGradoAscenso,
        "estado": estado,
    };
}
