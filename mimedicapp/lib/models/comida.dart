class Comida {
  final int? id;
  final String nombre;
  final String? detalles;
  final int recomendable;
  final String? createdAt;

  Comida(
      {this.id,
      required this.nombre,
      this.detalles,
      required this.recomendable,
      this.createdAt});

  factory Comida.fromJson(Map<String, dynamic> json) {
    return Comida(
      id: json['id'] as int?,
      nombre: json['nombre'] as String? ?? '',
      detalles: json['detalles'] as String?,
      recomendable: json['recomendable'] is int
          ? json['recomendable'] as int
          : int.tryParse('${json['recomendable']}') ?? 0,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'nombre': nombre,
        'detalles': detalles,
        'recomendable': recomendable,
      };
}
