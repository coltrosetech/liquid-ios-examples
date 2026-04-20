# Design DNA: Editorial Crisp (Todo App)

**DNA ID:** `editorial-crisp`
**Version:** 1.1.0
**Established:** 2026-04-20

## Karakter

Bu app **odak ve hız** hissetmeli. Kullanıcı görevi açıp, işaretleyip, kapatmalı — minimum sürtünme. Linear/Notion estetiği: net hierarchy, hairline ayraçlar, monospace timestamps. Hiçbir element gereksiz dikkat çekmez; her piksel görevin kendisine hizmet eder.

## Motion Felsefesi

- Hareket **kısa ama nefes alan** — 300ms ease-in-out, asla 400ms'yi geçmez (v1.0.0'da 200ms idi, v1.1.0'da kullanıcı geri bildirimiyle yumuşatıldı)
- Spring veya bounce **YOK** — bu DNA'da playful değiliz
- Sadece state transition'ları için animasyon (check/uncheck, sheet present)
- List row toggle: opacity + background fade, ekstra yok

## Ne Zaman Bu, Ne Zaman O

| Karar noktası | Tercih | Gerekçe |
|---|---|---|
| Sheet vs fullScreenCover | Sheet (medium detent) | Yeni görev ekleme task focus, fullScreen overkill |
| Liquid Glass kullanımı | Yok | iOS 17 min target; ayrıca DNA'ya uymaz (flat estetik) |
| Haptic | Sadece check/uncheck | Diğer her yer dekoratif olur |
| Accent color (#0066FF) | Sadece check'li state ve FAB | Asla dekoratif kullanım |

## Stack Decisions

| Karar | Seçim | Gerekçe |
|---|---|---|
| Min iOS | 17 | Todo app mass-market, geniş erişim |
| Bootstrap | vanilla-xcode | Solo dev, tek modül |
| Test framework | swift-testing | iOS 17+'da var, modern |
| Concurrency | swift6-strict | Compile-time race safety |
| State | observable-mainactor | iOS 17+ standard |
| Architecture | mvvm-observable | Todo boyutunda sweet spot |
| Persistence | swiftdata | Todo modeli için ideal |
| DI | manual-constructor | YAGNI — framework gerekmez |
| Navigation | navigation-stack-path-binding | iOS 16+ standard |

## Override'lar

- 2026-04-20 — `ios_min`: changed from `26` to `17`. Reason: Todo app mass-market kategorisi, Liquid Glass marjinal fayda sağlarken cihaz tabanı kaybı kabul edilemez.
- 2026-04-20 — `motion.transition_duration_ms`: changed from `200` to `300` (v1.0.0 → v1.1.0). Reason: Kullanıcı app genelinde daha sakin tempo istedi. Felsefe satırı "kısa ve belirleyici / asla daha uzun" → "kısa ama nefes alan / asla 400ms'yi geçmez" olarak revize edildi.

## Approximation Notes

(Henüz approximation gerektiren bir feature implement edilmedi.)
