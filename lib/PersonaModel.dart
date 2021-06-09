import 'dart:convert';

Persona clientFromJson(String str) {
  final jsonData = json.decode(str);
  return Persona.fromMap(jsonData);
}

String clientToJson(Persona data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

class Persona {
  int id;
  String nombre;
  String correo;
  String telefono;


  Persona({
    this.id,
    this.nombre,
    this.correo,
    this.telefono,
  });

  factory Persona.fromMap(Map<String, dynamic> json) => new Persona(
    id: json["id"],
    nombre: json["nombre"],
    correo: json["correo"],
    telefono: json["telefono"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "nombre": nombre,
    "correo": correo,
    "telefono": telefono,
  };
}
