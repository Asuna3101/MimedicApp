class Slot {
  final String horaInicio; // "HH:MM:SS"
  final String horaFin;
  final bool disponible;
  Slot({required this.horaInicio, required this.horaFin, required this.disponible});
  factory Slot.fromJson(Map<String, dynamic> j) => Slot(
    horaInicio: j['hora_inicio'],
    horaFin: j['hora_fin'],
    disponible: j['disponible'],
  );
}
class Availability {
  final int doctorId;
  final String fecha; // ISO
  final List<Slot> slots;
  Availability({required this.doctorId, required this.fecha, required this.slots});
  factory Availability.fromJson(Map<String, dynamic> j) => Availability(
    doctorId: j['doctor_id'],
    fecha: j['fecha'],
    slots: (j['slots'] as List).map((e)=>Slot.fromJson(e)).toList(),
  );
}
