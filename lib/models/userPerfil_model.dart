// To parse this JSON data, do
//
//     final userPerfilModel = userPerfilModelFromJson(jsonString);

import 'dart:convert';

UserPerfilModel userPerfilModelFromJson(String str) => UserPerfilModel.fromJson(json.decode(str));

String userPerfilModelToJson(UserPerfilModel data) => json.encode(data.toJson());

class UserPerfilModel {
    UserPerfilModel({
        this.id,
        this.rut,
        this.nombres,
        this.apellidoPaterno,
        this.apellidoMaterno,
        this.fechaDeNacimiento,
        this.direccion,
        this.comuna,
        this.statusCard,
        this.folio,
        this.imagen,

        this.fono,
        this.email,

        this.idInfoContacto,
        this.idApoderado,
        this.idGradoActual,
        this.escuelas,
        this.grado,
        this.apoderado,
        this.pupilos,
        this.informacionContacto,
        this.estado,
    });

    int id;
    String rut;
    String nombres;
    String apellidoPaterno;
    String apellidoMaterno;
    String fechaDeNacimiento;
    String direccion;
    String comuna;
    int statusCard;
    int folio;
    String imagen;

    String fono;
    String email;

    int idInfoContacto;
    int idApoderado;
    int idGradoActual;
    List<Escuela> escuelas;
    Grado grado;
    Apoderado apoderado;
    List<Apoderado> pupilos;
    InformacionContacto informacionContacto;
    bool estado;

    factory UserPerfilModel.fromJson(Map<String, dynamic> json) => UserPerfilModel(
        id: json["id"],
        rut: json["rut"],
        nombres: json["nombres"],
        apellidoPaterno: json["apellidoPaterno"],
        apellidoMaterno: json["apellidoMaterno"],
        fechaDeNacimiento: json["fechaDeNacimiento"],
        direccion: json["direccion"],
        comuna: json["comuna"],
        statusCard: json["statusCard"],
        folio: json["folio"],
        imagen: json["imagen"],

        fono: json["fono"],
        email: json["email"],

        idInfoContacto: json["idInfoContacto"],
        idApoderado: json["idApoderado"],
        idGradoActual: json["idGradoActual"],
        escuelas: (json["escuelas"] != null)? List<Escuela>.from(json["escuelas"].map((x) => Escuela.fromJson(x))): null,
        grado: (json["grado"] != null)? Grado.fromJson(json["grado"]) : null,
        apoderado: (json["apoderado"] != null)? Apoderado.fromJson(json["apoderado"]): null,
        pupilos: (json["pupilos"] != null)? List<Apoderado>.from(json["pupilos"].map((x) => Apoderado.fromJson(x))): null,
        informacionContacto: (json["informacionContacto"] != null)? InformacionContacto.fromJson(json["informacionContacto"]): null,
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "rut": rut,
        "nombres": nombres,
        "apellidoPaterno": apellidoPaterno,
        "apellidoMaterno": apellidoMaterno,
        "fechaDeNacimiento": fechaDeNacimiento,
        "direccion": direccion,
        "comuna": comuna,
        "statusCard": statusCard,
        "folio": folio,
        "imagen": imagen,

        "fono": fono,
        "email": email,


        "idInfoContacto": idInfoContacto,
        "idApoderado": idApoderado,
        "idGradoActual": idGradoActual,
        "escuelas": List<dynamic>.from(escuelas.map((x) => x.toJson())),
        "grado": grado.toJson(),
        "apoderado": apoderado.toJson(),
        "pupilos": List<dynamic>.from(pupilos.map((x) => x.toJson())),
        "informacionContacto": informacionContacto.toJson(),
        "estado": estado,
    };
}

class Apoderado {
    Apoderado({
        this.id,
        this.rut,
        this.nombres,
        this.apellidoPaterno,
        this.apellidoMaterno,
        this.fechaDeNacimiento,
        this.direccion,
        this.comuna,
        this.statusCard,
        this.folio,
        this.imagen,
        this.idGradoActual,
        this.escuelas,
        this.grado,

        this.fono,
        this.email,
        this.escuela,
    });

    int id;
    String rut;
    String nombres;
    String apellidoPaterno;
    String apellidoMaterno;
    dynamic fechaDeNacimiento;
    String direccion;
    String comuna;
    dynamic statusCard;
    int folio;
    dynamic imagen;
    dynamic idGradoActual;
    dynamic escuelas;
    dynamic grado;

    String fono;
    String email;
    String escuela;

    factory Apoderado.fromJson(Map<String, dynamic> json) => Apoderado(
        id: json["id"],
        rut: json["rut"],
        nombres: json["nombres"],
        apellidoPaterno: json["apellidoPaterno"],
        apellidoMaterno: json["apellidoMaterno"],
        fechaDeNacimiento: json["fechaDeNacimiento"],
        direccion: json["direccion"],
        comuna: json["comuna"],
        statusCard: json["statusCard"],
        folio: json["folio"],
        imagen: json["imagen"],
        idGradoActual: json["idGradoActual"],
        escuelas: json["escuelas"],
        grado: json["grado"],

       fono: json["fono"],
       email: json["email"],
       escuela: json["escuela"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "rut": rut,
        "nombres": nombres,
        "apellidoPaterno": apellidoPaterno,
        "apellidoMaterno": apellidoMaterno,
        "fechaDeNacimiento": fechaDeNacimiento,
        "direccion": direccion,
        "comuna": comuna,
        "statusCard": statusCard,
        "folio": folio,
        "imagen": imagen,
        "idGradoActual": idGradoActual,
        "escuelas": escuelas,
        "grado": grado,

        "fono": fono,
        "email": email,
        "escuela": escuela,
    };
}

class Escuela {
    Escuela({
        this.idEscuela,
        this.nombre,
        this.direccion,
        this.idComuna,
        this.comuna,
        this.idZona,
        this.zona,
        this.idInstructor,
        this.nombreInstructor,
        this.idMaestro,
        this.nombreMaestro,
        this.estado,
    });

    int idEscuela;
    String nombre;
    String direccion;
    String idComuna;
    String comuna;
    int idZona;
    String zona;
    int idInstructor;
    String nombreInstructor;
    int idMaestro;
    String nombreMaestro;
    bool estado;

    factory Escuela.fromJson(Map<String, dynamic> json) => Escuela(
        idEscuela: json["idEscuela"],
        nombre: json["nombre"],
        direccion: json["direccion"],
        idComuna: json["idComuna"],
        comuna: json["comuna"],
        idZona: json["idZona"],
        zona: json["zona"],
        idInstructor: json["idInstructor"],
        nombreInstructor: json["nombreInstructor"],
        idMaestro: json["idMaestro"],
        nombreMaestro: json["nombreMaestro"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "idEscuela": idEscuela,
        "nombre": nombre,
        "direccion": direccion,
        "idComuna": idComuna,
        "comuna": comuna,
        "idZona": idZona,
        "zona": zona,
        "idInstructor": idInstructor,
        "nombreInstructor": nombreInstructor,
        "idMaestro": idMaestro,
        "nombreMaestro": nombreMaestro,
        "estado": estado,
    };
}

class Grado {
    Grado({
        this.idGrado,
        this.nombre,
        this.numGup,
        this.numDan,
    });

    int idGrado;
    String nombre;
    int numGup;
    dynamic numDan;

    factory Grado.fromJson(Map<String, dynamic> json) => Grado(
        idGrado: json["idGrado"],
        nombre: json["nombre"],
        numGup: json["numGup"],
        numDan: json["numDan"],
    );

    Map<String, dynamic> toJson() => {
        "idGrado": idGrado,
        "nombre": nombre,
        "numGup": numGup,
        "numDan": numDan,
    };
}

class InformacionContacto {
    InformacionContacto({
        this.idInfoContacto,
        this.nombre,
        this.apellidoPaterno,
        this.apellidoMaterno,
        this.email,
        this.fono,
        this.direccion,
        this.idComuna,
        this.comuna,
        this.estado,
    });

    int idInfoContacto;
    String nombre;
    String apellidoPaterno;
    String apellidoMaterno;
    String email;
    String fono;
    dynamic direccion;
    String idComuna;
    String comuna;
    bool estado;

    factory InformacionContacto.fromJson(Map<String, dynamic> json) => InformacionContacto(
        idInfoContacto: json["idInfoContacto"],
        nombre: json["nombre"],
        apellidoPaterno: json["apellidoPaterno"],
        apellidoMaterno: json["apellidoMaterno"],
        email: json["email"],
        fono: json["fono"],
        direccion: json["direccion"],
        idComuna: json["idComuna"],
        comuna: json["comuna"],
        estado: json["estado"],
    );

    Map<String, dynamic> toJson() => {
        "idInfoContacto": idInfoContacto,
        "nombre": nombre,
        "apellidoPaterno": apellidoPaterno,
        "apellidoMaterno": apellidoMaterno,
        "email": email,
        "fono": fono,
        "direccion": direccion,
        "idComuna": idComuna,
        "comuna": comuna,
        "estado": estado,
    };
}
