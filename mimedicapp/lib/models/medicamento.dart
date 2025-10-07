class Medicamento {
  final int id;
  final String nombre;
  final int dosis;
  final String unidad;
  final int frecuenciaHoras;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  Medicamento({
    required this.id,
    required this.nombre,
    required this.dosis,
    required this.unidad,
    required this.frecuenciaHoras,
    required this.fechaInicio,
    required this.fechaFin,
  });

  // Conversión a JSON (útil para almacenamiento local)
  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'dosis': dosis,
        'unidad': unidad,
        'frecuenciaHoras': frecuenciaHoras,
        'fechaInicio': fechaInicio.toIso8601String(),
        'fechaFin': fechaFin.toIso8601String(),
      };

  // Constructor desde JSON
  factory Medicamento.fromJson(Map<String, dynamic> json) => Medicamento(
        id: json['id'],
        nombre: json['nombre'],
        dosis: json['dosis'],
        unidad: json['unidad'],
        frecuenciaHoras: json['frecuenciaHoras'],
        fechaInicio: DateTime.parse(json['fechaInicio']),
        fechaFin: DateTime.parse(json['fechaFin']),
      );
}
