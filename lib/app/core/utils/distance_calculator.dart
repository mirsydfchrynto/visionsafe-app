import 'dart:math';

/// Utility untuk kalkulasi jarak menggunakan Triangle Similarity.
/// Matkul: Computer Vision & SQA
class DistanceCalculator {
  // IPD Rata-rata manusia (6.3 cm)
  static const double realIpdCm = 6.3;
  
  // Focal Length (Asumsi standar pixel focal length kamera depan)
  // Nilai ini didapat dari kalibrasi (RealDistance * PixelIPD / RealIPD)
  static const double focalLengthPixels = 850.0;

  /// Menghitung estimasi jarak (cm) berdasarkan jarak antar mata di layar (pixels).
  /// Rumus: (Real IPD * Focal Length) / Pixel IPD
  static double calculateDistance(double pixelIpd) {
    if (pixelIpd <= 0) return 999.0; // Jarak tak terhingga jika mata tidak terdeteksi
    return (realIpdCm * focalLengthPixels) / pixelIpd;
  }

  /// Menghitung Euclidean Distance antara dua titik (Landmarks).
  static double calculatePixelIpd(Point leftEye, Point rightEye) {
    return sqrt(pow(rightEye.x - leftEye.x, 2) + pow(rightEye.y - leftEye.y, 2));
  }
}
