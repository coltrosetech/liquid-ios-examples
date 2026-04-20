# Claude Code rehberi — Sprout (Playful Character)

Bu bir `liquid-ios` plugin'i ile üretilmiş SwiftUI bitki bakım takip app'i. Bu dosya Claude Code'a (ve sana) bu proje üzerinde nasıl çalışılacağını anlatır.

## Proje durumu

- **DNA kilidi:** Playful Character v1.0.0 (bkz `.design/DESIGN_DNA.md`) — overshoot spring'ler, emoji karakterler, canlı renkler.
- **Stack:** SwiftUI + SwiftData + Swift Charts.
- **Xcode:** 16+, iOS hedefi 17.0+.
- **Seed data:** DEBUG modunda 4 bitki (Mona, Felix, Spike, Pothos) otomatik yüklenir.

## Plugin kurulu mu? Durum testi

```
/plugin marketplace add coltrosetech/claude-plugins
/plugin install liquid-ios@coltrosetech
```

## Bu projede dikkat

**Spring parametresi:** Playful Character DNA'sı `spring(response: 0.4, dampingFraction: 0.6)` kullanır — ufak overshoot ister. SwiftUI API `dampingFraction:` bekliyor (`damping:` DEĞİL). Bu proje bu hatanın keşfedildiği ilk vakaydı (bkz `references/motion-fidelity-rules.md`).

**Emoji karakter felsefesi:** Her bitki bir emoji ile temsil edilir (🌱🪴🌵🌿). Yeni feature'lar bu karakterleri hatırlatıcı, celebration, boş durum gibi yerlerde kullanmalı. Plain icon'a düşürmek DNA sapması.

## Plugin KURULUYKEN — önerilen akış

- **"Bir bitki çok susadığında kalp kırığı animasyonu ekle"** → `/ios-design:feature`, Playful Character overshoot'u ile celebration-ters animasyon.
- **"Watering history grafiği haftalık yerine aylık görünsün"** → `/ios-design:tweak`, `PlantDetailView`'daki Charts configuration.
- **"Bitki ekleme sheet'i daha hızlı hissettirsin"** → `/ios-design:tweak`, sheet presentation animation + spring tune.

## Plugin KURULU DEĞİLSE

`.design/DESIGN_DNA.md` + `.design/prototypes/playful-character.html` referans olmalı. Özellikle:
- Spring API: `.spring(response: 0.4, dampingFraction: 0.6)` — bu tam değeri değiştirirsen DNA sapması.
- Corner radius: 16pt (kartlar), 12pt (buttons).
- Color palette: vivid green + orange accent, neutral background.
- Motion HTML prototipte `<!-- swiftui: ... -->` yorumlarıyla dokümante.

## Yaygın komutlar

```bash
xcodegen generate

xcodebuild -project Sprout.xcodeproj -scheme Sprout \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  -configuration Debug CODE_SIGNING_ALLOWED=NO build

open Sprout.xcodeproj
```

## Gerçek Simulator doğrulama

Bu proje, plugin'in ilk uçtan-uca derlenip gerçek iPhone 16 simulatoründe çalışan örneği. Screenshot + motion GIF [`docs/`](./docs/) dizininde. Kendi değişikliklerinden sonra aynı şeyi tekrar yap:

```bash
xcrun simctl io booted screenshot out.png
xcrun simctl io booted recordVideo out.mov
```

## İlgili linkler

- Ana plugin: https://github.com/coltrosetech/liquid-ios
- Diğer örnekler: [../todo](../todo) (Editorial Crisp), [../breathe](../breathe) (Liquid Native)
