# CaseStudyProject - iOS Sohbet Uygulaması

Bu proje, iOS için 'Swift + SnapKit' kullanılarak geliştirilen bir sohbet prototipidir. 
Uygulama, MVVM (Model-View-ViewModel) mimarisi temel alınarak yapılandırılmıştır. 
Sohbet listesi, arşivleme, etkileşimler sonucu liste güncelleme ve kullanıcı etkileşimleri gibi işlevler örneklenmiştir.


---

## Notlar
- Swipe aksiyonlarından arşiv hariç diğerleri işlevsizdir, demo akışı amaçlı yerleştirilmiştir.
- Proje genelinde MVVM mimarisi ile proje kapsamında istenilen özellikler ön planda tutulmuştur. Arayüz tasarım ve bileşenlerinin genel yapıları uygulanmıştır.Örneğin, icon imageların işlevsel uygunluğu göze alınalarak bu projede kullanılmıştır.
- Okunmayan messajlar koyu renkte yazılmıştır.
- Okunmayan mesaj sayısı listelenmiştir.
- Sessiz,başa tutturukan(pin),okunmamış mesaj sayısı gibi iconlar filtreleme dahilinde chat alanına yansıtılmıştır.
- Mock verilerden gelen mesajların tarihlerine göre, başa tutturulan(isPinned = true) verilerin önceliği korunarak bir sıralama yapılmıştır.

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
│    └── ChatListViewModel.swift            // Tüm iş mantığı ve filtreleme
│
│──Resources/
│    └── Assets
│
│──AppDelegate.swift
│──SceneDelegate.swift
│──Info.plist

    
