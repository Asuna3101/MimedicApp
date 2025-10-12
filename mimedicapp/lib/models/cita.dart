class Cita {
  final int? id;
  final String clinica;
  final String especialidad;
  final String doctor;
  final DateTime fecha;

  Cita({
    this.id,
    required this.clinica,
    required this.especialidad,
    required this.doctor,
    required this.fecha,
  });

  factory Cita.fromJson(Map<String, dynamic> json) {
    return Cita(
      id: json['id'],
      clinica: json['clinica'] ?? '',
      especialidad: json['especialidad'] ?? '',
      doctor: json['doctor'] ?? '',
      fecha: DateTime.parse(json['fecha'])
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'centro_salud': clinica,
      'especialidad': especialidad,
      'doctor': doctor,
      'fecha': fecha.toIso8601String(),
    };
  }
}
