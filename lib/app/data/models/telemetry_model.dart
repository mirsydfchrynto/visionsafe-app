import 'dart:convert';

/// Model untuk menyimpan data telemetri deteksi jarak mata.
/// Matkul: Big Data & Web Service
class TelemetryModel {
  final double distance;
  final bool isViolation;
  final DateTime timestamp;

  TelemetryModel({
    required this.distance,
    required this.isViolation,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'distance': distance,
      'isViolation': isViolation,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory TelemetryModel.fromMap(Map<dynamic, dynamic> map) {
    return TelemetryModel(
      distance: (map['distance'] as num).toDouble(),
      isViolation: map['isViolation'] as bool,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory TelemetryModel.fromJson(String source) => 
      TelemetryModel.fromMap(json.decode(source));
}
