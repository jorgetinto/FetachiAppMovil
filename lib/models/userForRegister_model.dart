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
    int statusCard;
    int folio;
    String imagen;
    int idInfoContacto;
    int idApoderado;
    int idGradoActual;
    bool estado;
    int idEscuela;
    String role;

    factory UserForRegisterModel.fromJson(Map<String, dynamic> json) => UserForRegisterModel(
        id: json["id"],
        userName: json["userName"]??"",
        rut: json["rut"]??"",
        nombres: json["nombres"]??"",
        apellidoPaterno: json["apellidoPaterno"]??"",
        apellidoMaterno: json["apellidoMaterno"]??"",
        fechaDeNacimiento: json["fechaDeNacimiento"]??"",
        email: json["email"]??"",
        phoneNumber: json["phoneNumber"]??"",
        direccion: json["direccion"]??"",
        idComuna: json["idComuna"]??"",
        statusCard: json["statusCard"]??0,
        folio: json["folio"]??"",
        imagen: json["imagen"]??"",
        idInfoContacto: json["idInfoContacto"],
        idApoderado: json["idApoderado"],
        idGradoActual: json["idGradoActual"],
        estado: json["estado"],
        idEscuela: json["idEscuela"],
        role: json["role"],
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
