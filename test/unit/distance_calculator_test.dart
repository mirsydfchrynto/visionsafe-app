import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:visionsafe/app/core/utils/distance_calculator.dart';

void main() {
  group('DistanceCalculator Tests', () {
    test('Kalkulasi jarak harus akurat berdasarkan rumus Triangle Similarity', () {
      // Skenario: Jika Pixel IPD adalah 172.2 pixels
      // (6.3 * 820) / 172.2 = 30.0 cm
      const double mockPixelIpd = 172.2;
      final distance = DistanceCalculator.calculateDistance(mockPixelIpd);
      
      expect(distance, closeTo(30.0, 0.1));
    });

    test('Jarak harus meningkat jika Pixel IPD mengecil (Hukum Perspektif)', () {
      const double largeIpd = 200.0;
      const double smallIpd = 100.0;
      
      final nearDistance = DistanceCalculator.calculateDistance(largeIpd);
      final farDistance = DistanceCalculator.calculateDistance(smallIpd);
      
      expect(farDistance, greaterThan(nearDistance));
    });

    test('Harus menangani Pixel IPD nol atau negatif secara elegan', () {
      expect(DistanceCalculator.calculateDistance(0), 999.0);
      expect(DistanceCalculator.calculateDistance(-10), 999.0);
    });

    test('Kalkulasi Pixel IPD (Euclidean) harus benar', () {
      const p1 = Point(0, 0);
      const p2 = Point(3, 4); // Pythagoras 3,4,5
      
      final pixelIpd = DistanceCalculator.calculatePixelIpd(p1, p2);
      expect(pixelIpd, 5.0);
    });
  });
}
