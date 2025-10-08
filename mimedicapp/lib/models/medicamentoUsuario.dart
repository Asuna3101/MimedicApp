class MedicamentoUsuario {
  final int? id;
  final String nombre;
  final int dosis;
  final String unidad;
  final int frecuenciaHoras;
  final DateTime fechaInicio;
  final DateTime fechaFin;

  MedicamentoUsuario({
    this.id,
    required this.nombre,
    required this.dosis,
    required this.unidad,
    required this.frecuenciaHoras,
    required this.fechaInicio,
    required this.fechaFin,
  });

  Map<String, dynamic> toJson() => {
        if (id != null) 'id': id,
        'nombre': nombre,
        'dosis': dosis,
        'unidad': unidad,
        'frecuencia_horas': frecuenciaHoras,
        'fecha_inicio': fechaInicio.toIso8601String(),
        'fecha_fin': fechaFin.toIso8601String(),
      };

  factory MedicamentoUsuario.fromJson(Map<String, dynamic> json) =>
      MedicamentoUsuario(
        id: json['id'],
        nombre: json['nombre'],
        dosis: json['dosis'],
        unidad: json['unidad'],
        frecuenciaHoras: json['frecuenciaHoras'],
        fechaInicio: DateTime.parse(json['fechaInicio']),
        fechaFin: DateTime.parse(json['fechaFin']),
      );
}
