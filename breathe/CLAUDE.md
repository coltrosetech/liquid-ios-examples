# Claude Code rehberi — Breathe (Liquid Native)

Bu bir `liquid-ios` plugin'i ile üretilmiş SwiftUI nefes egzersizi app'i. Bu dosya Claude Code'a (ve sana) bu proje üzerinde nasıl çalışılacağını anlatır.

## Proje durumu

- **DNA kilidi:** Liquid Native v1.1.0 (bkz `.design/DESIGN_DNA.md`) — iOS 26 Liquid Glass dili.
- **Stack:** SwiftUI + SwiftData + iOS 26 `.glassEffect()` (iOS<26 için `.ultraThinMaterial` fallback).
- **Xcode:** **26+ gerekli** — `.glassEffect()` API Xcode 26 SDK'da tanımlı. Xcode 16.2 ile "cannot find 'glassEffect' in scope" alır.
- **iOS hedefi:** 17.0+ (26'da görsel zenginleşir, 17-25'te fallback çalışır).

## Plugin kurulu mu? Durum testi

```
/plugin marketplace add coltrosetech/claude-plugins
/plugin install liquid-ios@coltrosetech
```

## Bu projede dikkat — iOS 26 kısıtları

Eğer Claude'un ürettiği kod yeni bir `.glassEffect()` çağrısı içerecekse, onu aşağıdaki pattern içinde sarmalı:

```swift
if #available(iOS 26.0, *) {
    SomeShape().glassEffect()
} else {
    SomeShape().fill(.ultraThinMaterial)
}
```

Fallback'siz `.glassEffect()` çağrısı iOS 25 ve altında crash veya compile-error sebebi. Motion-fidelity kuralları bu fallback'i zorunlu tutar (bkz ana plugin repo `references/motion-fidelity-rules.md`).

## Plugin KURULUYKEN — önerilen akış

- **"Seans bitince 'Great job!' ekranı ekle"** → `/ios-design:feature`, Liquid Native pastel paletini kullanan prototip, sonra SwiftUI.
- **"Nefes orb'unun inhale süresi 5 saniye olsun"** → `/ios-design:tweak`, `.phaseAnimator` animasyon süresini günceller.
- **"Box breath dışında 4-7-8 paterni ekle"** → `/ios-design:feature`, yeni `BreathPattern` enum case + UI.

## Plugin KURULU DEĞİLSE

Plugin yoksa yine motion kurallarına uy:
- `.spring(response:dampingFraction:)` — `damping:` DEĞİL.
- `.glassEffect()` her zaman `#available` check içinde.
- Her UI dekorasyonu `.design/DESIGN_DNA.md`'deki renk paletini (sky → sunset gradient) kullanır.

## Yaygın komutlar (Xcode 26 ile)

```bash
# Project dosyasını üret
xcodegen generate

# Xcode 26 ile aç
open Breathe.xcodeproj
# ▶ Run (iOS 26 simulator tercihen)
```

Xcode 16 ile denersen: `Sources/Views/TodayView.swift` ve `SessionView.swift` içindeki `.glassEffect()` satırları compile etmez. Geçici çözüm: bu satırları `.fill(.ultraThinMaterial)` ile değiştirmek (fidelity düşer, DNA revize sayılır).

## İlgili linkler

- Ana plugin: https://github.com/coltrosetech/liquid-ios
- Motion-fidelity kuralları: https://github.com/coltrosetech/liquid-ios/blob/main/references/motion-fidelity-rules.md
- Diğer örnekler: [../todo](../todo) (Editorial Crisp), [../sprout](../sprout) (Playful Character)
