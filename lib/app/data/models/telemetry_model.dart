import 'dart:convert';
import '../../core/utils/uuid_generator.dart';

/// Model untuk menyimpan data telemetri deteksi jarak mata.
/// Matkul: Big Data & Web Service
class TelemetryModel {
  final String id;
  final double distance;
  final bool isViolation;
  final bool isBlinking;
  final DateTime timestamp;

  TelemetryModel({
    String? id,
    required this.distance,
    required this.isViolation,
    required this.isBlinking,
    required this.timestamp,
  }) : id = id ?? UuidGenerator.generateV4();

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'distance': distance,
      'isViolation': isViolation,
      'isBlinking': isBlinking,
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  factory TelemetryModel.fromMap(Map<dynamic, dynamic> map) {
    return TelemetryModel(
      id: map['id'] as String?,
      distance: (map['distance'] as num).toDouble(),
      isViolation: map['isViolation'] as bool,
      isBlinking: map['isBlinking'] ?? false,
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory TelemetryModel.fromJson(String source) => 
      TelemetryModel.fromMap(json.decode(source));
}
