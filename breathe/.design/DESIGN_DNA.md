# Design DNA: Liquid Native (Breathe)

**DNA ID:** `liquid-native`
**Version:** 1.1.0
**Established:** 2026-04-20

## Karakter

Bu app **derin nefes ve sakinlik** hissettirmeli. Kullanıcı uygulamayı açtığında parmaklarının altındaki materyalin "fiziksel" tepkisini duymalı — soluk alıp veriyormuş gibi orb yumuşakça nefes almalı, geçişler kemikten değil camdan geçiyor gibi olmalı. Liquid Glass'ın derinliği meditation hissini destekliyor.

## Motion Felsefesi

- Hareket **uzun ama kemikli değil** — spring(response: 0.7, damping: 0.8) varsayılan (v1.0.0'da 0.5 idi, v1.1.0'da meditation karakteriyle daha uyumlu olması için yumuşatıldı); nefes orb için 4s ease-in-out döngü
- Bounce/overshoot **YOK** — bu DNA'da playful değiliz; durağan bir güven gerekli
- Geçişler 500ms civarı — meditatif tempo, asla aceleci hissetmemeli
- matchedGeometryEffect tercih sebebi (continuity sakinlik verir)
- TimelineView nefes orb için (sürekli ambient animasyon)

## Ne Zaman Bu, Ne Zaman O

| Karar noktası | Tercih | Gerekçe |
|---|---|---|
| Sheet vs fullScreenCover | fullScreenCover (session başlatma) | Derin focus için sheet yeterli değil |
| Liquid Glass kullanımı | Her yerde — orb wrapper, session card, button | DNA'nın imzası |
| Haptic | Sadece nefes phase change'lerde (in/out) | Dekoratif değil, ritm yardımcısı |
| Background gradient | Dynamic — gün vaktine göre | Sabit bg meditation hissi vermez |

## Stack Decisions

| Karar | Seçim | Gerekçe |
|---|---|---|
| Min iOS | 26 | Liquid Glass DNA'nın merkezinde; premium kategori, eski cihaz endişesi minimal |
| Bootstrap | vanilla-xcode | Solo dev, tek modül |
| Test framework | swift-testing | Modern, iOS 18+ |
| Concurrency | swift6-strict | Race-free |
| State | observable-mainactor | iOS 17+ standard |
| Architecture | mvvm-observable | Bu boyut için sweet spot |
| Persistence | swiftdata | Session history modeline ideal |
| DI | manual-constructor | YAGNI — framework gerekmez |
| Navigation | navigation-stack-path-binding | iOS 16+ standard |

## Override'lar

- 2026-04-20 — `motion.primary_spring.response`: changed from `0.5` to `0.7` (v1.0.0 → v1.1.0). Reason: Kullanıcı app genelinde daha sakin hissetmesini istedi; Liquid Native'in meditatif karakterine 0.7 daha uygun. Spring response artışı = transition'lar daha yumuşak başlar/biter.

## Approximation Notes

(Henüz approximation gerektiren bir feature implement edilmedi.)
