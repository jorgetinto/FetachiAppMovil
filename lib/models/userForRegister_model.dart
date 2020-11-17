// To parse this JSON data, do
//
//     final userForRegisterModel = userForRegisterModelFromJson(jsonString);

import 'dart:convert';

UserForRegisterModel userForRegisterModelFromJson(String str) => UserForRegisterModel.fromJson(json.decode(str));

String userForRegisterModelToJson(UserForRegisterModel data) => json.encode(data.toJson());

class UserForRegisterModel {
    UserForRegisterModel({
        this.id,
        this.userName,
        this.rut,
        this.nombres,
        this.apellidoPaterno,
        this.apellidoMaterno,
        this.fechaDeNacimiento,
        this.email,
        this.phoneNumber,
        this.direccion,
        this.idComuna,
        this.statusCard,
        this.folio,
        this.imagen,
        this.idInfoContacto,
        this.idApoderado,
        this.idGradoActual,
        this.estado,
        this.idEscuela,
        this.role,
    });

    int id;
    String userName;
    String rut;
    String nombres;
    String apellidoPaterno;
    String apellidoMaterno;
    String fechaDeNacimiento;
    String email;
    String phoneNumber;
    String direccion;
    String idComuna;
    dynamic statusCard;
    dynamic folio;
    dynamic imagen;
    dynamic idInfoContacto;
    dynamic idApoderado;
    int idGradoActual;
    bool estado;
    dynamic idEscuela;
    String role;

    factory UserForRegisterModel.fromJson(Map<String, dynamic> json) => UserForRegisterModel(
        id: json["Id"],
        userName: json["UserName"],
        rut: json["Rut"],
        nombres: json["Nombres"],
        apellidoPaterno: json["ApellidoPaterno"],
        apellidoMaterno: json["ApellidoMaterno"],
        fechaDeNacimiento: json["FechaDeNacimiento"],
        email: json["Email"],
        phoneNumber: json["PhoneNumber"],
        direccion: json["Direccion"],
        idComuna: json["IdComuna"],
        statusCard: json["StatusCard"],
        folio: json["Folio"],
        imagen: json["Imagen"],
        idInfoContacto: json["IdInfoContacto"],
        idApoderado: json["IdApoderado"],
        idGradoActual: json["IdGradoActual"],
        estado: json["Estado"],
        idEscuela: json["IdEscuela"],
        role: json["Role"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "UserName": userName,
        "Rut": rut,
        "Nombres": nombres,
        "ApellidoPaterno": apellidoPaterno,
        "ApellidoMaterno": apellidoMaterno,
        "FechaDeNacimiento": fechaDeNacimiento,
        "Email": email,
        "PhoneNumber": phoneNumber,
        "Direccion": direccion,
        "IdComuna": idComuna,
        "StatusCard": statusCard,
        "Folio": folio,
        "Imagen": imagen,
        "IdInfoContacto": idInfoContacto,
        "IdApoderado": idApoderado,
        "IdGradoActual": idGradoActual,
        "Estado": estado,
        "IdEscuela": idEscuela,
        "Role": role,
    };
}
