// To parse this JSON data, do
//
//     final regionModel = regionModelFromJson(jsonString);

import 'dart:convert';

RegionModel regionModelFromJson(String str) => RegionModel.fromJson(json.decode(str));

String regionModelToJson(RegionModel data) => json.encode(data.toJson());

class RegionModel {
    RegionModel({
        this.codRegion,
        this.nombre,
    });

    String codRegion;
    String nombre;

    factory RegionModel.fromJson(Map<String, dynamic> json) => 
    RegionModel(
        codRegion: json["codRegion"],
        nombre: json["nombre"],
    );

    Map<String, dynamic> toJson() => {
        "codRegion": codRegion,
        "nombre": nombre,
    };

    RegionModel fromJson(Map<String, dynamic> item)  {
      return new RegionModel(
        codRegion: item["codRegion"],
        nombre: item["nombre"],
      );
    }
}
