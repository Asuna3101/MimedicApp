class Usuario {
  final int idUsuario;
  final String nombre;
  final DateTime fechaNacimiento;
  final String celular;
  final String correo;
  final String contrasena;

  Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.fechaNacimiento,
    required this.celular,
    required this.correo,
    required this.contrasena,
  });

// Método toString para representar la clase como un String
  @override
  String toString() {
    return 'Usuario{idUsuario: $idUsuario, nombre: $nombre, fechaNacimiento: $fechaNacimiento, celular: $celular, correo: $correo, contrasena: $contrasena}';
  }

// Método para convertir la instancia a un Map (JSON)
  Map<String, dynamic> toJson() {
    return {
      'idUsuario': idUsuario,
      'nombre': nombre,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'celular': celular,
      'correo': correo,
      'contrasena': contrasena,
    };
  }

// Método para crear una instancia de Usuario a partir de un Map
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['idUsuario'],
      nombre: json['nombre'],
      fechaNacimiento: DateTime.parse(json['fechaNacimiento']),
      celular: json['celular'],
      correo: json['correo'],
      contrasena: json['contrasena'],
    );
  }
}
