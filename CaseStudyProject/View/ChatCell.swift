// CaseStudyProject
// View/ChatCell.swift

//** Mock datalar için (proje içerisindeki aktif veriler) bireysel hücrelerin görünümü ChatCell'de oluşturulmuştur.

import UIKit
import SnapKit

final class ChatCell: UITableViewCell {
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 24
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .darkGray
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        label.textAlignment = .right
        return label
    }()
    
    private let muteImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "speaker.slash.fill")
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    private let pinImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "pin")
        iv.tintColor = .gray
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        return iv
    }()
    
    private let unreadBadgeLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 12, weight: .bold)
        label.textColor = .white
        label.backgroundColor = .systemBlue
        label.clipsToBounds = true
        label.layer.cornerRadius = 12
        label.isHidden = true
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
        
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        contentView.addSubview(avatarImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(messageLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(muteImageView)
        contentView.addSubview(pinImageView)
        contentView.addSubview(unreadBadgeLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.size.equalTo(48)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.trailing.equalToSuperview().offset(-12)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalTo(avatarImageView.snp.trailing).offset(12)
            make.trailing.lessThanOrEqualTo(dateLabel.snp.leading).offset(-8)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(4)
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        unreadBadgeLabel.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.trailing.equalToSuperview().inset(12)
            make.centerY.equalTo(messageLabel) 
        }
        
        pinImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.trailing.equalTo(unreadBadgeLabel.snp.leading).offset(-12)
            make.centerY.equalTo(unreadBadgeLabel)
        }
        
        muteImageView.snp.makeConstraints { make in
            make.width.height.equalTo(16)
            make.trailing.equalTo(pinImageView.snp.leading).offset(-12)
            make.centerY.equalTo(unreadBadgeLabel)
        }
    }
    
    
    func configure(with chat: Chat) {
        nameLabel.text = chat.name
        messageLabel.text = chat.lastMessage
        avatarImageView.image = UIImage(named: chat.avatarImageName)
        dateLabel.text = formatDate(chat.date)
        
        // Bold font (okunmamış)
        nameLabel.font = chat.isUnread
            ? .boldSystemFont(ofSize: 16)
            : .systemFont(ofSize: 16, weight: .medium)
        
        messageLabel.font = chat.isUnread
            ? .boldSystemFont(ofSize: 14)
            : .systemFont(ofSize: 14)

        if chat.unreadCount > 0 {
            unreadBadgeLabel.isHidden = false
            unreadBadgeLabel.text = "\(chat.unreadCount)"
        } else {
            unreadBadgeLabel.isHidden = true
        }
        
        // Mute ve Pin
        muteImageView.isHidden = !chat.isMuted
        pinImageView.isHidden = !chat.isPinned
    }
    
    private func formatDate(_ date: Date) -> String {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)

        let formattedMonth = month >= 10 ? String(format: "%02d", month) : "\(month)"
        let formattedDay = day >= 10 ? String(format: "%02d", day) : "\(day)"

        return "\(formattedMonth)/\(formattedDay)"
    }


}
