class EjercicioUsuario {
  final int? id;
  final String? nombre;
  final String? notas;
  final String? horario;
  final int? duracionMin;

  EjercicioUsuario({
    this.id,
    this.nombre,
    this.notas,
    this.horario,
    this.duracionMin,
  });

  factory EjercicioUsuario.fromJson(Map<String, dynamic> json) {
    return EjercicioUsuario(
      id: json['id'] as int?,
      nombre: json['nombre'] as String?,
      notas: json['notas'] as String?,
      horario: json['horario'] as String?,  // <<--- CAMBIAR AQUÍ
      duracionMin: json['duracion_min'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (nombre != null) 'nombre': nombre,
      if (notas != null) 'notas': notas,
      if (horario != null) 'horario': horario,   // <<--- CAMBIAR AQUÍ
      if (duracionMin != null) 'duracion_min': duracionMin,
    };
  }
}