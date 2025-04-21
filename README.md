# CaseStudyProject - iOS Sohbet Uygulaması

Bu proje, iOS için 'Swift + SnapKit' kullanılarak geliştirilen bir sohbet prototipidir. 
Uygulama, MVVM (Model-View-ViewModel) mimarisi temel alınarak yapılandırılmıştır. 
Sohbet listesi, arşivleme, etkileşimler sonucu liste güncelleme ve kullanıcı etkileşimleri gibi işlevler örneklenmiştir.

---

## ✨ Özellikler

- 🔍 Arama çubuğu ile kişi veya grup filtreleme
- 🗂 "Tümü", "Okunmamış", "Gruplar" sekmeleri ile filtreleme
- 📌 Sabitlenmiş sohbetler
- 🔕 Sessize alınmış sohbetler
- 📬 Okunmamış mesaj rozetleri
- 🗃 Arşivlenmiş sohbetlere geçiş ve arşivden çıkarma
- 👆 Swipe aksiyonları ile arşivle, sil, ses aç
- 🧱 MVVM mimarisi
- 🎨 SnapKit ile dinamik ve duyarlı layout tasarımı

---

Notlar
-Swipe aksiyonlarından arşiv hariç diğerleri işlevsizdir, demo akışı amaçlı yerleştirilmiştir.
-Proje genelinde MVVM mimarisi ile proje kapsamında istenilen özellikler ön planda tutulmuştur. Arayüz tasarım ve bileşenlerinin genel yapıları uygulanmıştır.
Örneğin, icon imageların işlevsel uygunluğu göze alınalarak bu projede kullanılmıştır.

## Proje Yapısı

```plaintext
CaseStudyProject/
│
├── Model/
│   └── Chat.swift                         // Chat veri modeli
│
├── View/
│   ├── ChatListViewController.swift       // Ana sohbet listesi
│   ├── ArchivedChatsViewController.swift  // Arşivlenmiş sohbetler ekranı
│   └── ChatCell.swift                     // Her sohbet hücresinin görünümü
│   │── Utils/
│       └── ChatSwipeActionProvider.swift      // Swipe aksiyon butonlarını sağlayan yardımcı
│
├── ViewModel/
    └── ChatListViewModel.swift            // Tüm iş mantığı ve filtreleme



    
