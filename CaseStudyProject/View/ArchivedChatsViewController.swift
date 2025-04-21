// CaseStudyProject
// View/ArchivedChatsViewController.swift

//** Arşiv sayfası UI yönetimi, kullanıcı etkileşimlerinin iletimi için oluşturulmuştur.Doğrudan veri oluşturmaz verileri görüntüye iletir.

import UIKit
import SnapKit

final class ArchivedChatsViewController: UIViewController {
        
    private let tableView = UITableView()
    private let viewModel: ChatListViewModel
        
    init(viewModel: ChatListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.title = "Arşivlenmiş"
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Düzenle", style: .plain, target: self, action: #selector(editTapped))
        navigationItem.rightBarButtonItem?.tintColor = .black

        setupUI()
        bindViewModel()
    }
    @objc private func editTapped() {
        // Görsel amaçlı, hiçbir şey yapmıyor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = .systemBackground
            appearance.shadowColor = .clear // alt çizgi yok

            let titleFont = UIFont.systemFont(ofSize: 17, weight: .medium)
            appearance.titleTextAttributes = [
                .foregroundColor: UIColor.label,
                .font: titleFont
            ]

            navigationController?.navigationBar.tintColor = .black

            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        tableView.reloadData()
    }
    
    private func setupUI() {
        view.backgroundColor = .white
        
        let headerLabel = UILabel()
            headerLabel.text = "Yeni mesajlar geldiğinde bu sohbetler arşivde kalmaya devam eder."
            headerLabel.textColor = .gray
            headerLabel.font = .systemFont(ofSize: 13)
            headerLabel.numberOfLines = 0
            headerLabel.textAlignment = .center
            view.addSubview(headerLabel)
            headerLabel.snp.makeConstraints { make in
                make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
                make.leading.trailing.equalToSuperview().inset(16)
            }
        view.addSubview(tableView)
            tableView.snp.makeConstraints { make in
                make.top.equalTo(headerLabel.snp.bottom).offset(8)
                make.leading.trailing.bottom.equalToSuperview()
            }

            tableView.register(ChatCell.self, forCellReuseIdentifier: "ChatCell")
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
    }
    
    /*private func bindViewModel() {
        viewModel.onChatsUpdated = { [weak self] in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }*/
    
    private func bindViewModel() {
        viewModel.onChatsUpdated = { [weak self] in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.tableView.reloadData()

                if self.viewModel.archivedChats.isEmpty {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }
        }

    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        viewModel.onChatsUpdated?()
    }
}

extension ArchivedChatsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.archivedChats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let chat = viewModel.archivedChats[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell else {
            return UITableViewCell()
        }
        cell.configure(with: chat)
        return cell

    }
}

extension ArchivedChatsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let chat = viewModel.archivedChats[indexPath.row]

        let unmute = ChatSwipeActionProvider.makeSwipeAction(title: "Sesi Aç", systemImage: "speaker.wave.2.fill", color: .systemOrange) {
            print("Sesi açılıyor: \(chat.name)")
        }

        let delete = ChatSwipeActionProvider.makeSwipeAction(title: "Sil", systemImage: "trash", color: .systemRed) {
            print("Sohbet siliniyor: \(chat.name)")
        }

        let unarchive = ChatSwipeActionProvider.makeSwipeAction(title: "Arşivden çıkar", systemImage: "arrow.uturn.left", color: .systemGray) {
            self.viewModel.unarchiveChat(at: indexPath.row)
        }

        let config = UISwipeActionsConfiguration(actions: [unarchive, delete, unmute])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let chat = viewModel.activeChats[indexPath.row]
        
        let pinAction = ChatSwipeActionProvider.makeSwipeAction(title: chat.isPinned ? "Sabitlemeyi Kaldır" : "Sabitle",systemImage: "pin.fill",
                                        color: .systemGreen){}//        self.viewModel.togglePin(for: chat.id)
        
        let unreadAction = ChatSwipeActionProvider.makeSwipeAction(title: "Okunmadı", systemImage: "bubble.fill", color: .systemBlue) {
            print("Okunmadı olarak işaretlendi: \(chat.name)")
        }

        

        let config = UISwipeActionsConfiguration(actions: [ unreadAction,pinAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

