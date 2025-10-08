class MedicamentoResponse {
  final int id;
  final String nombre;
  final String? message;

  MedicamentoResponse({
    required this.id,
    required this.nombre,
    this.message,
  });

  factory MedicamentoResponse.fromJson(Map<String, dynamic> json) {
    return MedicamentoResponse(
      id: json['id'],
      nombre: json['nombre'],
      message: json['message'],
    );
  }
}
