# 👁️ VISIONSAFE (EYEGUARDIAN)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-blue?style=for-the-badge&logo=flutter)](https://flutter.dev)
[![MediaPipe](https://img.shields.io/badge/AI-MediaPipe_Face_Mesh-red?style=for-the-badge&logo=google)](https://developers.google.com/mediapipe)
[![Supabase](https://img.shields.io/badge/Backend-Supabase-green?style=for-the-badge&logo=supabase)](https://supabase.com)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

> **Mitigating Myopia with Real-time AI.** Sebuah sistem mitigasi risiko mata minus berbasis Computer Vision yang berjalan di latar belakang (Background Service) untuk menjaga kesehatan mata pengguna.

---

## 🚀 The Innovation
VISIONSAFE menggunakan **MediaPipe Face Mesh** untuk mendeteksi jarak antara mata dan layar secara real-time. Jika jarak terdeteksi terlalu dekat (<30cm), sistem akan memberikan intervensi visual berupa efek blur pada layar (Surgical Overlay Control) untuk memaksa pengguna menjaga jarak aman.

---

## ✨ Key Features
- **Real-time Face Distance Detection:** Mengukur koordinat Z mata secara presisi menggunakan AI di sisi perangkat (Edge AI).
- **Intelligent Visual Intervention:** Memberikan feedback berupa *Gaussian Blur* transparan yang menutupi layar saat jarak mata tidak aman.
- **Smart Background Service:** Tetap berjalan dan memonitor aktivitas meskipun pengguna sedang menggunakan aplikasi lain atau bermain game.
- **Eye Health Reports:** Statistik penggunaan harian dan durasi paparan layar yang dipantau melalui integrasi Supabase.

---

## 🛠️ Tech Stack
- **Framework:** Flutter (Android Native Interop).
- **AI Core:** Google MediaPipe Face Mesh.
- **System Control:** Android Foreground Service & Overlay Window Permissions.
- **Database:** Supabase (User Analytics & Settings).

---

## 📸 Screenshots
| Background Detection | Visual Blur Intervention |
| :---: | :---: |
| ![Detection](./screenshots/detection.jpg) | ![Blur](./screenshots/blur.jpg) |

*(Catatan: Pastikan gambar tersedia di folder /screenshots)*

---

## 🚦 Getting Started
1. Clone repo ini.
2. Jalankan `flutter pub get`.
3. Pastikan memberikan izin "Appear on Top" (Overlay) dan Kamera pada perangkat Android.
4. Klik "Start Protection" untuk mengaktifkan asisten pelindung mata.

---

## 👨‍💻 Author
**M. Irsyad Fachryanto** - *Software Engineer & AI Researcher*
- LinkedIn: [muhammadirsyadf](https://www.linkedin.com/in/muhammadirsyadf/)
- Portfolio: [irsyad-architect.surge.sh](https://irsyad-architect.surge.sh)
