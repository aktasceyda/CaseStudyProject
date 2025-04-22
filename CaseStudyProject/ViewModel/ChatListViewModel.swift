// CaseStudyProject
// ViewModel/ChatListViewModel.swift

//** Bu projede istenilen amaç ve methodlar çok büyük veriler olmadığı için ChatList(ActiveChat), ArchivedChatList gibi alt ViewModel'lere ayırılmaya gerek duyulmadı.

import Foundation

enum ChatFilter {
    case all
    case unread
    case groups
}

final class ChatListViewModel {
        
    private(set) var allChats: [Chat] = []
    var onChatArchived: ((IndexPath) -> Void)?
    var onChatUnarchived: ((IndexPath, IndexPath) -> Void)? // eskiIndex, yeniIndex

    var archivedChats: [Chat] {
        let filtered = allChats.filter { $0.isArchived }

            return filtered.sorted {
                if $0.isPinned == $1.isPinned {
                    return $0.date > $1.date
                }
                return $0.isPinned && !$1.isPinned
            }
        }

    var activeChats: [Chat] {
        let filtered = allChats.filter { !$0.isArchived }

        let searchFiltered = filtered.filter {
            //searchText.isEmpty || $0.name.lowercased().contains(searchText.lowercased())
            searchText.isEmpty ||
                    $0.name.lowercased().contains(searchText.lowercased()) ||
                    $0.lastMessage.lowercased().contains(searchText.lowercased())
        }

        let segmentedFiltered: [Chat]
        switch selectedFilter {
        case .all:
            segmentedFiltered = searchFiltered
        case .unread:
            segmentedFiltered = searchFiltered.filter { $0.isUnread }
        case .groups:
            segmentedFiltered = searchFiltered.filter {
                $0.name.lowercased().contains("grup") || $0.name.lowercased().contains("lig")
            }
        }

        return segmentedFiltered.sorted {
            if $0.isPinned == $1.isPinned {
                return $0.date > $1.date          //date e göre sıralama yap eğer iki veri de pin'li ise
            }
            return $0.isPinned && !$1.isPinned
        }
    }/*
    var activeChats: [Chat] {
        let filtered = allChats.filter {
            !$0.isArchived &&
            (searchText.isEmpty ||
             $0.name.lowercased().contains(searchText.lowercased()) ||
             $0.lastMessage.lowercased().contains(searchText.lowercased()))
        }
        return sortChats(filtered)
    }

    var archivedChats: [Chat] {
        let filtered = allChats.filter {
            $0.isArchived &&
            (searchText.isEmpty ||
             $0.name.lowercased().contains(searchText.lowercased()) ||
             $0.lastMessage.lowercased().contains(searchText.lowercased()))
        }
        return sortChats(filtered)
    }*/


    var onArchiveCountChanged: ((Int) -> Void)?
    var onChatsUpdated: (() -> Void)?
    
    var searchText: String = "" {
        didSet {
            onChatsUpdated?()
        }
    }

    var selectedFilter: ChatFilter = .all {
        didSet {
            onChatsUpdated?()
        }
    }

    var selectedFilterIndex: Int {
        switch selectedFilter {
        case .all: return 0
        case .unread: return 1
        case .groups: return 2
        }
    }
    
    init() {
        loadMockData()
    }
    private func dateFrom(_ string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter.date(from: string) ?? Date()
    }

    func loadMockData() {
        allChats = [
            Chat(id: UUID(), name: "Milli Takım Analiz", lastMessage: "Mert Arıkan: GIF", date: dateFrom("2025-04-20 10:30"), isArchived: true, isMuted: false, isUnread: false, isPinned: true, avatarImageName: "flag", unreadCount: 0),
            Chat(id: UUID(), name: "Ahmet Tekdemir", lastMessage: "Bence de o maç biraz riskli...", date: dateFrom("2025-04-18 22:15"), isArchived: true, isMuted: true, isUnread: true, isPinned: false, avatarImageName: "person1", unreadCount: 3),
            Chat(id: UUID(), name: "Şampiyonlar Ligi", lastMessage: "Güzel bir akşam bizi bekliyor", date: dateFrom("2025-04-19 14:45"), isArchived: false, isMuted: false, isUnread: false, isPinned: true, avatarImageName: "ball", unreadCount: 0),
            Chat(id: UUID(), name: "Taktik Analiz", lastMessage: "Arda Demircan: Güzel bir ak...", date: dateFrom("2025-04-17 18:00"), isArchived: false, isMuted: true, isUnread: true, isPinned: true, avatarImageName: "chalkboard", unreadCount: 2),
            Chat(id: UUID(), name: "Aynur Akça", lastMessage: "Yazıyor...", date: Date(), isArchived: false, isMuted: false, isUnread: false, isPinned: false, avatarImageName: "person2", unreadCount: 0),
            Chat(id: UUID(), name: "Scout Ekibi", lastMessage: "Maç raporu hazırlandı.", date: dateFrom("2025-04-15 15:00"), isArchived: false, isMuted: false, isUnread: true, isPinned: false, avatarImageName: "scout", unreadCount: 1),
            Chat(id: UUID(), name: "Turnuva Planlama", lastMessage: "Final tarihi kesinleşti.", date: dateFrom("2025-03-17 18:00"), isArchived: false, isMuted: true, isUnread: false, isPinned: false, avatarImageName: "calendar", unreadCount: 0),
            Chat(id: UUID(), name: "U17 Kadrosu", lastMessage: "Oyuncu listesi güncellendi.", date: dateFrom("2025-04-19 21:00"), isArchived: true, isMuted: false, isUnread: true, isPinned: false, avatarImageName: "person3", unreadCount: 3),
            Chat(id: UUID(), name: "Basın Toplantısı", lastMessage: "Soru listesi geldi.", date: dateFrom("2025-04-18 18:00"), isArchived: false, isMuted: true, isUnread: true, isPinned: false, avatarImageName: "microphone", unreadCount: 1),
            Chat(id: UUID(), name: "Saha Görevlileri", lastMessage: "Saha çizimi tamamlandı.", date: Date(), isArchived: true, isMuted: true, isUnread: false, isPinned: false, avatarImageName: "whistle", unreadCount: 0)
            

        ]
        onArchiveCountChanged?(archivedChats.count)
        onChatsUpdated?()
        //notifyObservers()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.notifyObservers()
        }
    }

    /*func archiveChat(at index: Int) {
        var chat = activeChats[index]
        if let i = allChats.firstIndex(where: { $0.id == chat.id }) {
            allChats[i].isArchived = true
            notifyObservers()
        }
    }
    func unarchiveChat(at index: Int) {
        let chat = archivedChats[index] // Bu sadece bir referans
        if let i = allChats.firstIndex(where: { $0.id == chat.id }) {
            allChats[i].isArchived = false
            notifyObservers()
        }
    }*/
    func archiveChat(at index: Int) {
        let chat = activeChats[index]
        
        if let i = allChats.firstIndex(where: { $0.id == chat.id }) {
            allChats[i].isArchived = true
            
            let fromIndexPath = IndexPath(row: index, section: 0)
            onChatArchived?(fromIndexPath)
            notifyObservers()
            
            
        }
    }
    func unarchiveChat(at index: Int) {
        let chat = archivedChats[index]
        
        if let i = allChats.firstIndex(where: { $0.id == chat.id }) {
            allChats[i].isArchived = false
            
            let fromIndexPath = IndexPath(row: index, section: 0)
            notifyObservers()
            
            if let newIndex = activeChats.firstIndex(where: { $0.id == chat.id }) {
                let toIndexPath = IndexPath(row: newIndex, section: 0)
                onChatUnarchived?(fromIndexPath, toIndexPath)
            }
        }
    }/*
    
    func archiveChat(at index: Int) {
        let chat = activeChats[index]
        
        if let oldIndex = allChats.firstIndex(where: { $0.id == chat.id }) {
            allChats[oldIndex].isArchived = true
            notifyObservers()
            onChatArchived?(IndexPath(row: index, section: 0))
        }
    }
    func unarchiveChat(at index: Int) {
        let chat = archivedChats[index]

        if let oldIndex = allChats.firstIndex(where: { $0.id == chat.id }) {
            allChats[oldIndex].isArchived = false
            notifyObservers()

            let fromIndexPath = IndexPath(row: index, section: 0)
            let toIndexPath = IndexPath(row: activeChats.firstIndex(where: { $0.id == chat.id }) ?? 0, section: 0)
            onChatUnarchived?(fromIndexPath, toIndexPath)
        }
    }*/

    private func notifyObservers() {
        onChatsUpdated?()
        onArchiveCountChanged?(archivedChats.count)
    }
    func toggleUnread(for chatId: UUID) {
        guard let index = allChats.firstIndex(where: { $0.id == chatId }) else { return }
        allChats[index].isUnread.toggle()
        onChatsUpdated?()
    }

}

extension ChatListViewModel {

    func toggleMute(at index: Int) {
        let chat = archivedChats[index]
        if let i = allChats.firstIndex(where: { $0.id == chat.id }) {
            allChats[i].isMuted.toggle()
            onChatsUpdated?()
        }
    }

    func togglePin(at index: Int) {
        let chat = archivedChats[index]
        if let i = allChats.firstIndex(where: { $0.id == chat.id }) {
            allChats[i].isPinned.toggle()
            onChatsUpdated?()
        }
    }

    func markAsUnread(at index: Int) {
        let chat = archivedChats[index]
        if let i = allChats.firstIndex(where: { $0.id == chat.id }) {
            allChats[i].isUnread = true
            onChatsUpdated?()
        }
    }

    func deleteChat(at index: Int) {
        let chat = archivedChats[index]
        if let i = allChats.firstIndex(where: { $0.id == chat.id }) {
            allChats.remove(at: i)
            onArchiveCountChanged?(archivedChats.count)
            onChatsUpdated?()
        }
    }
}






