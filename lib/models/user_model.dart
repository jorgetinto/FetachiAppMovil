// To parse this JSON data, do
//
//     final userModel = userModelFromJson(jsonString);

import 'dart:convert';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
    UserModel({
        this.token,
        this.user,
    });

    String token;
    User user;

    factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        token: json["token"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
    };
}

class User {
    User({
        this.id,
        this.userName,
        this.rut,
        this.nombres,
        this.apellidoPaterno,
        this.apellidoMaterno,
        this.fechaDeNacimiento,
        this.direccion,
        this.comuna,
        this.email,
        this.phoneNumber,
        this.folio,
        this.statusCard,
        this.imagen,
        this.idGradoActual,
        this.idApoderado,
        this.idInfoContacto,
        this.userRoles,
    });

    String id;
    String userName;
    String rut;
    String nombres;
    String apellidoPaterno;
    String apellidoMaterno;
    DateTime fechaDeNacimiento;
    dynamic direccion;
    dynamic comuna;
    String email;
    String phoneNumber;
    dynamic folio;
    dynamic statusCard;
    dynamic imagen;
    int idGradoActual;
    dynamic idApoderado;
    dynamic idInfoContacto;
    List<String> userRoles;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        userName: json["userName"],
        rut: json["rut"],
        nombres: json["nombres"],
        apellidoPaterno: json["apellidoPaterno"],
        apellidoMaterno: json["apellidoMaterno"],
        fechaDeNacimiento: DateTime.parse(json["fechaDeNacimiento"]),
        direccion: json["direccion"],
        comuna: json["comuna"],
        email: json["email"],
        phoneNumber: json["phoneNumber"],
        folio: json["folio"],
        statusCard: json["statusCard"],
        imagen: json["imagen"],
        idGradoActual: json["idGradoActual"],
        idApoderado: json["idApoderado"],
        idInfoContacto: json["idInfoContacto"],
        userRoles: List<String>.from(json["userRoles"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "userName": userName,
        "rut": rut,
        "nombres": nombres,
        "apellidoPaterno": apellidoPaterno,
        "apellidoMaterno": apellidoMaterno,
        "fechaDeNacimiento": fechaDeNacimiento.toIso8601String(),
        "direccion": direccion,
        "comuna": comuna,
        "email": email,
        "phoneNumber": phoneNumber,
        "folio": folio,
        "statusCard": statusCard,
        "imagen": imagen,
        "idGradoActual": idGradoActual,
        "idApoderado": idApoderado,
        "idInfoContacto": idInfoContacto,
        "userRoles": List<dynamic>.from(userRoles.map((x) => x)),
    };
}
