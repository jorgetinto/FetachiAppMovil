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

        this.idComuna,
        this.comuna,
        this.idRegion,
        this.region,

        this.statusCard,
        this.folio,
        this.imagen,
        this.imagenOriginal,

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
        this.usuarioMembresia,
        this.estado,
    });

    int id;
    String rut;
    String nombres;
    String apellidoPaterno;
    String apellidoMaterno;
    String fechaDeNacimiento;
    String direccion;
    String idComuna;
    String comuna;
    String idRegion;
    String region;
    int statusCard;
    int folio;
    String imagen;
    String imagenOriginal;
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
    MembresiaModel usuarioMembresia;
    bool estado;

    factory UserPerfilModel.fromJson(Map<String, dynamic> json) => UserPerfilModel(
        id: json["id"],
        rut: json["rut"],
        nombres: json["nombres"],
        apellidoPaterno: json["apellidoPaterno"],
        apellidoMaterno: json["apellidoMaterno"],
        fechaDeNacimiento: json["fechaDeNacimiento"],
        direccion: json["direccion"],
        idComuna: json["idComuna"],
        comuna: json["comuna"],
        idRegion: json["idRegion"],
        region: json["region"],
        statusCard: json["statusCard"],
        folio: json["folio"],
        imagen: json["imagen"],
        imagenOriginal: json["imagen"],
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
        usuarioMembresia: (json["usuarioMembresia"] != null)? MembresiaModel.fromJson(json["usuarioMembresia"]): null,
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
        "idComuna": idComuna,
        "comuna": comuna,
        "idRegion": idRegion,
        "region": region,
        "statusCard": statusCard,
        "folio": folio,
        "imagen": imagen,
        "imagenOriginal": imagenOriginal,
        "PhoneNumber": fono,
        "Email": email,
        "idInfoContacto": idInfoContacto,
        "idApoderado": idApoderado,
        "idGradoActual": idGradoActual,
        "escuelas": (escuelas != null)? List<dynamic>.from(escuelas.map((x) => x.toJson())) : null,
        "grado": (grado != null)? grado.toJson(): null,
        "apoderado": (apoderado != null)? apoderado.toJson(): null,
        "pupilos": (pupilos != null)?  List<dynamic>.from(pupilos.map((x) => x.toJson())): null,
        "informacionContacto": (informacionContacto != null)? informacionContacto.toJson(): null,
        "usuarioMembresia": (usuarioMembresia != null)? usuarioMembresia.toJson(): null,
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
        this.idRegion,
        this.region,
        this.idZona,
        this.zona,
        this.idInstructor,
        this.nombreInstructor,

        this.gradoInstructor,
        this.fonoInstructor,
        this.correoInstructor,
        this.fotoInstructor,

        this.idMaestro,
        this.nombreMaestro,
        this.logo,
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

    String gradoInstructor;
    String fonoInstructor;
    String correoInstructor;
    String fotoInstructor;

    int idMaestro;
    String nombreMaestro;
    String logo;
    bool estado;

    factory Escuela.fromJson(Map<String, dynamic> json) => Escuela(
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

        gradoInstructor: json["gradoInstructor"],
        fonoInstructor: json["fonoInstructor"],
        correoInstructor: json["correoInstructor"],
        fotoInstructor: json["fotoInstructor"],

        idMaestro: json["idMaestro"],
        nombreMaestro: json["nombreMaestro"],
        logo: json["logo"],
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
        "gradoInstructor":gradoInstructor,
        "fonoInstructor":fonoInstructor,
        "correoInstructor":correoInstructor,
        "fotoInstructor": fotoInstructor,
        "idMaestro": idMaestro,
        "nombreMaestro": nombreMaestro,
        "logo": logo,
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
        this.idRegion,
        this.region,
        this.comuna,
        this.estado,
    });

    int idInfoContacto;
    String nombre;
    String apellidoPaterno;
    String apellidoMaterno;
    String email;
    String fono;
    String direccion;
    String idComuna;
    String comuna;
    String idRegion;
    String region;
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
        idRegion: json["idRegion"],
        region: json["region"],
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
        "idRegion": idRegion,
        "region": region,
        "estado": estado,
    };
}

class MembresiaModel {
    MembresiaModel({
        this.id,
        this.idUsuario,
        this.idMembresia,
        this.fechaPago,
        this.fechaPagoTxt,
        this.estado,
    });

    int id;
    int idUsuario;
    int idMembresia;
    DateTime fechaPago;
    String fechaPagoTxt;
    bool estado;

    factory MembresiaModel.fromJson(Map<String, dynamic> json) => MembresiaModel(
        id: json["id"],
        idUsuario: json["idUsuario"],
        idMembresia: json["idMembresia"],
        fechaPago: DateTime.parse(json["fechaPago"]),
        fechaPagoTxt: json["fechaPagoTxt"],
        estado: json["estado"],
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
