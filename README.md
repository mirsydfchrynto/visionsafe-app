<div align="center">
  <h1>🛡️ VisionSafe (EyeGuardian) 🛡️</h1>
  <h3>Sistem Mitigasi Risiko Miopia Berbasis Real-Time Computer Vision (MediaPipe Face Mesh)</h3>
  
  [![Flutter Status](https://img.shields.io/badge/Flutter-3.x-blue.svg)](https://flutter.dev)
  [![Android Native](https://img.shields.io/badge/Android-Kotlin-green.svg)](https://developer.android.com/kotlin)
  [![MediaPipe](https://img.shields.io/badge/AI_Engine-MediaPipe_FaceMesh-orange.svg)](https://developers.google.com/mediapipe)
  [![Status](https://img.shields.io/badge/Status-Production_Ready-success.svg)](#)
</div>

---

## 📌 Pendahuluan
**VisionSafe** adalah aplikasi *Background-First* yang berjalan di atas OS Android (versi 24+) untuk mencegah anak-anak menatap layar (*screen time*) terlalu dekat. Berbeda dengan aplikasi kesehatan pada umumnya yang hanya bergantung pada *timer* atau sensor proksimitas fisik, VisionSafe memanfaatkan algoritma **Computer Vision Edge AI** secara lokal (*On-Device*) untuk menghitung jarak pengguna ke layar ponsel secara matematis dan *real-time*.

## 🏗️ Arsitektur Sistem Berkinerja Tinggi (High-Performance Architecture)

Tantangan utama dari proyek ini adalah: *"Bagaimana memproses AI tanpa menguras baterai ponsel dan tanpa aplikasi terlihat di layar?"*

Solusi arsitektur yang digunakan adalah pola **Invisible AI / Background-First**, yang terdiri dari 3 lapisan:

1. **Dashboard UI Layer (Flutter / GetX):**
   * Bertindak sebagai "Remote Control" dan antarmuka analitik. Meminta perizinan sistem (*Permissions*) dengan anggun dan menyimpan pengaturan pengguna.
2. **Native Foreground Engine (Kotlin):**
   * *Service* murni Android yang diisolasi agar tidak dimatikan oleh sistem (OS) saat pengguna sedang bermain *game* atau membuka YouTube.
3. **Edge Vision Pipeline (MediaPipe Face Mesh):**
   * Mendeteksi 468 titik *landmark* wajah setiap **1.5 detik (Frame Sampling)** untuk menghemat daya baterai secara ekstrem. Menggunakan prinsip geometri **Triangle Similarity** dengan mengekstrak jarak antar titik mata (*Interpupillary Distance* dalam bentuk piksel) untuk mengestimasi jarak sentimeter dengan sangat presisi, lalu memicu **Blur Overlay (System Alert Window)** sebagai bentuk intervensi negatif/hukuman visual yang aman jika layar terlalu dekat (< 30 cm).

## 🚀 Fitur Unggulan
- **Akurasi AI:** Tidak tertipu oleh kondisi miring (*Roll, Pitch, Yaw*) karena Face Mesh memahami geometri wajah 3D.
- **Hemat Daya (Battery Throttling):** Kecepatan pemindaian yang sengaja diturunkan (*0.6 FPS*), memastikan *Thermal Throttling* (HP panas) tidak terjadi.
- **Non-Bypassable Intervention:** Intervensi (*Blur*) menimpa semua aplikasi lain (menggunakan `TYPE_APPLICATION_OVERLAY`) yang memaksa pengguna mengubah postur mereka untuk terus menggunakan *smartphone*.

---
*Proyek ini secara eksklusif didesain dan diarsiteki oleh **Irsyad (The Architect)** sebagai **Capstone Project / Mahakarya Kesehatan Digital**, diwujudkan dan diverifikasi penuh oleh The Supreme Developer Agent (SDA).*
