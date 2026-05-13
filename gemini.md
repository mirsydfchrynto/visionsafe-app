# VisionSafe: The Hero's Eye Guardian

## 🤖 VISIONSAFE ELITE FRONTEND SUPREME AGENT (SDA V2)

### ━━━━━━━━━━━━━━━━━━
### CORE MISSION
### ━━━━━━━━━━━━━━━━━━
Make VisionSafe **visually stunning, extremely polished, and production-ready.**
- **Architecture:** GetX + Atomic Design (Atoms, Molecules, Organisms, Templates, Pages).
- **Quality Standard:** World-class UX/UI (Nintendo/Duolingo level engagement).
- **Code Health:** < 200 lines per file, zero duplication, surgical clean code.
- **Responsiveness:** Perfect on phones, tablets, foldables.

### ━━━━━━━━━━━━━━━━━━
### DESIGN IDENTITY & FEEL
### ━━━━━━━━━━━━━━━━━━
- **Theme:** Blue + White palette, Retro playful 2D style, Friendly cyber mascot.
- **Mood:** Fun, professional, futuristic but calming, safe for children.
- **Layout:** Rounded corners (high radius), soft shadows, smooth animations.

### ━━━━━━━━━━━━━━━━━━
### FRONTEND STANDARDS
### ━━━━━━━━━━━━━━━━━━
1. **Atomic Design Rigor:** Strict folder structure for reusable widgets.
2. **Animation Excellence:** Meaningful, smooth, and emotionally expressive.
3. **Performance First:** Minimize rebuilds, optimize assets, zero jank.
4. **Consistency:** Centralized design constants for padding, colors, and radius.

---

## 🛠 Project Progress & Context

### 1. Mascot & Quest UI Fixes (May 13, 2026)
- **Vizo Mascot:** Eye size increased to 90% (filling circle) for better aesthetics.
- **Quest System:** Moved "Senam Mata" to Quests as a **Special Quest**.
- **Hero Collection:** Renamed all "Sticker" references to "Koleksi Hero".
- **Flexibility:** `QuestsView` refactored to be fully scrollable and flexible.

### 2. Buddy/Dashboard Cleanup
- Removed "Senam Mata" from Home/Buddy to keep it focused on Vizo and core protection.
- Optimized spacing and visual hierarchy for a professional, clean look.

### 3. Technical Debt Resolved
- Fixed `IconData` type mismatch error in quest tiles.
- Removed unused imports and fixed protected member access in `Obx`.
- Analyzed and verified all changes with `flutter analyze` (Zero issues found).

---

## 🚀 ROADMAP (SUPREME AGENT MODE)
1. **Standardize Design System:** Centralize `AppDesign` constants (Atoms).
2. **Template Refactoring:** Create `BaseScreenTemplate` for navigation/safearea consistency.
3. **Interaction V2:** Make Vizo more reactive to user touch and environment.
4. **Haptic & Feedback:** Integrate subtle vibration/sound for a "premium" feel.

---

## 📝 Legacy Architecture & Core Rules
- **Clean Architecture:** pemisahan Presentation, Domain (Repository), dan Data (Service).
- **Backend:** Supabase (Auth, REST API).
- **Repositories:** AuthRepository, TelemetryRepository.
- **Services:** AuthService, RewardService, TelemetryService, NewsService.
