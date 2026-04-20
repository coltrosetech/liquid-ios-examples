# Design DNA: Playful Character (Sprout)

**DNA ID:** `playful-character`
**Version:** 1.0.0
**Established:** 2026-04-20

## Karakter

Bu app **bitkiyle duygusal bağ** kurmalı — kullanıcı uygulamayı açtığında bitkilerinin "kişiliklerini" hissetmeli. Sulama bir görev değil, küçük bir kutlama anı olmalı. Her bitki ismi + emoji ile karakterleşir; thirst gösterimi acımasız değil sevimli ("🥺" thirsty); sulama sonrası bitki yanıt verir (bounce, sprout grow). Arc/Duolingo enerjisi — overshoot, warm gradients, micro-celebrations.

## Motion Felsefesi

- Spring(response: 0.4, damping: 0.6) — küçük overshoot ile, mekanik değil canlı hissetmeli
- Plant emoji'leri sürekli yumuşak wiggle (4s döngü) — TimelineView/phaseAnimator
- Sulama tetiklenince bitki bounce (.symbolEffect(.bounce)) + thirst bar yumuşak doluş geri sayım
- Drop counter tap → pop animasyonu (gamification yansıması)
- Linear veya ease-in-out **zorunda değilsen kullanma** — bu DNA'da spring varsayılan
- Haptic: sulama + streak + plant happy event'lerinde

## Ne Zaman Bu, Ne Zaman O

| Karar noktası | Tercih | Gerekçe |
|---|---|---|
| Sheet vs fullScreenCover | Sheet (medium detent) — add plant | Hızlı task, fullScreen overkill |
| Color palette usage | Yeşil = healthy, turuncu/kırmızı = thirsty, sarı/mavi = accent | Emotional state mapping |
| Plant emoji selection | User chooses from a curated list at add time | Karakter bağı için isim + görsel ikilisi şart |
| Haptic | Sulama anında medium impact + soft tick on every drop | Tactile reward |
| Sound | Opsiyonel — settings'ten kapatılabilir | Bazı kullanıcılar sessiz tercih eder |

## Stack Decisions

| Karar | Seçim | Gerekçe |
|---|---|---|
| Min iOS | 17 | Mass-market lifestyle, geniş cihaz tabanı; Liquid Glass marjinal fayda |
| Bootstrap | vanilla-xcode | Solo dev, küçük scope |
| Test framework | swift-testing | iOS 17+ var, modern |
| Concurrency | swift6-strict | Race-free |
| State | observable-mainactor | iOS 17+ standard |
| Architecture | mvvm-observable | Bu boyut için sweet spot |
| Persistence | swiftdata | Plant collection modeline ideal |
| DI | manual-constructor | YAGNI |
| Navigation | navigation-stack-path-binding | iOS 16+ standard |

## Override'lar

- 2026-04-20 — `ios_min`: changed from `26` to `17`. Reason: Mass-market lifestyle app, Liquid Glass marjinal fayda (Playful Character'ın imzası glass değil bounce + warm color), cihaz tabanı kaybı kabul edilemez.

## Approximation Notes

(Henüz approximation gerektiren bir feature implement edilmedi.)
