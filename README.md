# liquid-ios-examples

[**liquid-ios**](https://github.com/coltrosetech/liquid-ios) plugin'i ile üretilmiş üç iOS demo uygulaması. Her biri farklı bir **Design DNA** kullanır, her biri gerçek SwiftUI kodu — prototip değil.

Plugin'in iddiası basit: _"HTML prototipte onayladığın hareket, Swift tarafında da aynen yaşasın."_ Bu repo o iddianın kanıtı. Üç app, üç farklı tasarım dili, üç kez kanıtlanmış motion-fidelity eşleşmesi.

---

## Uygulamalar

| App | DNA | Özet | Xcode |
|---|---|---|---|
| [**todo**](./todo) | Editorial Crisp | Günlük görev listesi — minimal, Helvetica-benzeri tipografi, ajandavari sade çizgiler | 16+ |
| [**breathe**](./breathe) | Liquid Native | 5 dakikalık nefes egzersizi — `.glassEffect()`, radyal gradient orb, phaseAnimator | **26+** (iOS 26) |
| [**sprout**](./sprout) | Playful Character | Bitki bakım takibi — emoji karakterler, spring animasyonlar, SwiftData + Charts | 16+ |

---

## Hızlı başlangıç

Her app bağımsız bir Xcode projesidir, `project.yml` üzerinden [XcodeGen](https://github.com/yonaskolb/XcodeGen) ile üretilir.

```bash
# XcodeGen yoksa
brew install xcodegen

# Örneğin sprout'u çalıştır
cd sprout
xcodegen generate
open Sprout.xcodeproj
# Xcode → ▶ Run (iPhone 16 / iOS 18+ simulator)
```

DEBUG modunda her app kendi seed verisini otomatik yükler — `⌘R` sonrası dolu bir ekran görürsün.

---

## Neden üç farklı DNA?

Plugin'in kalbindeki fikir: iOS için "tek doğru tasarım dili" yok. Bir **takvim asistanı** ile bir **meditasyon uygulaması** aynı görsel dili konuşmamalı. Plugin her proje başlangıcında 3 HTML prototip üretir, sen birini onaylarsın, sonra tüm SwiftUI üretimi o DNA'ya bağlı kalır.

Bu repo'daki üç app, o üç varsayılan DNA'nın her birinin nasıl üretime dönüştüğünü gösteriyor:

- **Editorial Crisp** → ajanda, görev, okuma uygulamaları
- **Liquid Native** → meditasyon, sağlık, konsantrasyon araçları
- **Playful Character** → alışkanlık, hobi, çocuk uygulamaları

---

## `.design/` dizini nedir?

Her app'in kökünde bir `.design/` klasörü var. İçinde:

- `DESIGN_DNA.md` — kilitli tasarım felsefesi (renk palet, tipografi, motion karakteri)
- `design-system.json` — token'lar (makine tarafından okunabilir)
- `prototypes/` — SwiftUI'yi üreten HTML prototipler (motion yorumları dahil)

Bu klasör bilerek commit'lenmiştir — çünkü plugin'in sonraki çalıştırmalarında aynı DNA üretime devam eder. Kilitleme ilkesini kaybetmeyelim diye.

---

## Lisans

MIT — istediğin gibi fork'la, kendi tasarım dilini yaz.

---

## Plugin'i de kullanmak istersen

1. [coltrosetech/liquid-ios](https://github.com/coltrosetech/liquid-ios) repo'sunu klonla.
2. `INSTALL.md` adımlarıyla Claude Code'a kur.
3. Claude Code'a "SwiftUI todo app başlatalım, editorial crisp DNA ile" gibi bir şey yaz.
4. 3 HTML prototip gelir, birini seçersin, sonrası otomatik.

Plugin v0.1.1'de. Sorularını Issues'a yaz.
