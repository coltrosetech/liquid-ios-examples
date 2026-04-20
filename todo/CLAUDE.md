# Claude Code rehberi — Todo (Editorial Crisp)

Bu bir `liquid-ios` plugin'i ile üretilmiş SwiftUI todo app'i. Bu dosya Claude Code'a (ve sana) bu proje üzerinde nasıl çalışılacağını anlatır.

## Proje durumu

- **DNA kilidi:** Editorial Crisp v1.1.0 (bkz `.design/DESIGN_DNA.md`) — bu proje içindeki her görsel karar bu DNA'ya uymalı.
- **Stack:** SwiftUI + SwiftData + Swift 6 strict concurrency.
- **Xcode:** 16+, iOS hedefi 17.0+.
- **Seed data:** DEBUG modunda 6 örnek task otomatik yüklenir (`Sources/TodoApp.swift` içinde `#if DEBUG`).

## Plugin kurulu mu? Durum testi

Yeni Claude Code session açtıysan, önce plugin'in aktif olup olmadığını gör:

```
/plugin marketplace add coltrosetech/claude-plugins
/plugin install liquid-ios@coltrosetech
```

Kuruluysa `/ios-design:tweak` ve `/ios-design:feature` komutları kullanılabilir. Değilse bu dosyanın alt kısmındaki "plugin'siz çalışma" bölümüne bak.

## Plugin KURULUYKEN — önerilen akış

Kurulu plugin'le Claude'a şu tarzda şeyler söyleyebilirsin:

- **"Yeni görevlere hatırlatma zamanı seç alanı ekle"** → `/ios-design:feature` aktive olur, Editorial Crisp DNA'sına sadık kalan tek bir prototip render eder, onaylarsan SwiftUI üretir.
- **"Tamamlanan görev animasyonu biraz daha hızlı olsun"** → `/ios-design:tweak` aktive olur, DNA'ya karşı diff alır, "tek seferlik mi DNA revize mi" sorar.
- **"Gruplar / etiket filtreleme ekle"** → `/ios-design:feature`, yeni view modelini DNA'dan türetir.

## Plugin KURULU DEĞİLSE

Plugin yoksa Claude yine de bu projeye yardım edebilir — ama motion-fidelity garantilerini kaybedersin.

**Kural:** Claude her değişiklikten önce `.design/DESIGN_DNA.md`'yi okumalı, motion için `.design/prototypes/editorial-crisp.html` içindeki yorum satırlarına bakmalı (CSS↔SwiftUI mapping'ler yazılı).

**Spring parametreleri için kritik gotcha:** SwiftUI API `.spring(response:dampingFraction:)` kullanıyor, `damping:` DEĞİL. Bu hatayı yapmadan önce `references/motion-fidelity-rules.md` (ana plugin repo'sunda) dokümanına git.

## Yaygın komutlar

```bash
# Project dosyasını üret (ilk kez veya Sources değişince)
xcodegen generate

# Build
xcodebuild -project TodoApp.xcodeproj -scheme TodoApp \
  -destination "platform=iOS Simulator,name=iPhone 16" \
  -configuration Debug CODE_SIGNING_ALLOWED=NO build

# Run in simulator
open TodoApp.xcodeproj   # Xcode'da ▶ Run
```

## Ne değiştirilmemeli

- `.design/DESIGN_DNA.md` — tasarım kararları kilitli, değişim `/ios-design:tweak` üzerinden olmalı.
- `bundleIdPrefix: com.liquidios.sample` — örnek olduğu için.
- Swift 6 strict concurrency (`SWIFT_STRICT_CONCURRENCY: complete`) — MVVM yapıyı zorluyor, kilitli.

## İlgili linkler

- Ana plugin: https://github.com/coltrosetech/liquid-ios
- Diğer örnekler: [../breathe](../breathe) (Liquid Native), [../sprout](../sprout) (Playful Character)
