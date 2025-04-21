// CaseStudyProject
// Model/Chat.swift

//** Her bir mock data için oluşturulacak veri modelinin bileşenleri.

import Foundation

struct Chat {
    let id: UUID
    let name: String
    let lastMessage: String
    let date: Date
    var isArchived: Bool
    var isMuted: Bool
    var isUnread: Bool
    var isPinned: Bool
    let avatarImageName: String
    var unreadCount: Int   
}


