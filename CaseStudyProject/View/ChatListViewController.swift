// CaseStudyProject
// View/ChatListViewController.swift

//** Chat sayfası UI yönetimi, kullanıcı etkileşimlerinin iletimi için oluşturulmuştur.Doğrudan veri oluşturmaz verileri görüntüye iletir.

import UIKit
import SnapKit

final class ChatListViewController: UIViewController {

    private let tableView = UITableView()
    private let archiveButton = UIButton(type: .system)
    private let viewModel = ChatListViewModel()

    private let allButton = UIButton(type: .system)
    private let unreadButton = UIButton(type: .system)
    private let groupsButton = UIButton(type: .system)
    
    private var tableViewTopConstraint: Constraint? // Arşiv buttonu ve tableView arasındaki dinamik boşluk problemi için yaratıldı.
    private let filterStack = UIStackView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Sohbetler"
        label.font = UIFont.systemFont(ofSize: 24, weight: .semibold)
        label.textColor = .label
        label.textAlignment = .center
        return label
    }()

    private let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Kişi veya grup ara"
        tf.font = .systemFont(ofSize: 15)
        tf.backgroundColor = UIColor.white
        tf.layer.cornerRadius = 10
        tf.layer.borderColor = UIColor.systemGray4.cgColor

        tf.clearButtonMode = .whileEditing
        tf.leftViewMode = .always

        let iconView = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        iconView.tintColor = .gray
        iconView.contentMode = .scaleAspectFit
        iconView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)

        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 20))
        iconView.center = paddingView.center
        paddingView.addSubview(iconView)
      
        tf.layer.borderWidth = 0.5

        tf.leftView = paddingView
        return tf
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
        viewModel.onArchiveCountChanged?(viewModel.archivedChats.count)
    }
   /*override
    func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }*/


    private func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Sohbetler" // TODO**********************bunları uıview yap .
        //self.navigationItem.title = ""

        //view.addSubview(titleLabel)
        /*titleLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(4)
            make.centerX.equalToSuperview()
        }*/

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis.circle"),
            style: .plain,
            target: self,
            action: #selector(didTapMore)
        )

        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(didTapAdd)
        )

        view.addSubview(searchTextField)
        searchTextField.snp.makeConstraints { make in
            //make.top.equalTo(titleLabel.snp.bottom).offset(12)
            //make.leading.trailing.equalToSuperview().inset(16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(36)
        }
        searchTextField.addTarget(self, action: #selector(searchTextChanged(_:)), for: .editingChanged)

        let buttons = [allButton, unreadButton, groupsButton]
        let titles = ["Tümü", "Okunmamış", "Gruplar"]

        for (index, button) in buttons.enumerated() {
            button.setTitle(titles[index], for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 14, weight: .medium)
            button.layer.cornerRadius = 16
            button.layer.borderWidth = 0.5
            button.layer.borderColor = UIColor.systemGray4.cgColor
            button.setTitleColor(.systemGray, for: .normal)
            button.backgroundColor = .clear
            button.tag = index
            button.addTarget(self, action: #selector(filterButtonTapped(_:)), for: .touchUpInside)
        }

        filterStack.arrangedSubviews.forEach { filterStack.removeArrangedSubview($0); $0.removeFromSuperview() } // removeFromSuperview() görünümden kaldır.
        buttons.forEach { filterStack.addArrangedSubview($0) } // Güncel buttonları sırasıyla ekle.
        
        filterStack.axis = .horizontal
        filterStack.distribution = .fillEqually
        filterStack.spacing = 8
        view.addSubview(filterStack)

        filterStack.snp.makeConstraints { make in
            make.top.equalTo(searchTextField.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(32)
        }

        /*archiveButton.setTitle("Arşivlenmiş", for: .normal)
        archiveButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        archiveButton.isHidden = true
        archiveButton.addTarget(self, action: #selector(openArchivedChats), for: .touchUpInside)*/
        archiveButton.setTitle("  Arşivlenmiş", for: .normal) // ← boşluk bırakarak ikon ile metin arasında mesafe
        archiveButton.setImage(UIImage(systemName: "tray.full"), for: .normal)
        archiveButton.tintColor = .label
        archiveButton.setTitleColor(.label, for: .normal)
        archiveButton.titleLabel?.font = .boldSystemFont(ofSize: 16)
        archiveButton.contentHorizontalAlignment = .leading // ← sola hizalama
        archiveButton.imageView?.contentMode = .scaleAspectFit
        archiveButton.contentEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        archiveButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10) // ← ikonla yazı arasına boşluk
        archiveButton.addTarget(self, action: #selector(openArchivedChats), for: .touchUpInside)

        view.addSubview(archiveButton)
        archiveButton.snp.makeConstraints { make in
            make.top.equalTo(filterStack.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            self.tableViewTopConstraint = make.top.equalTo(archiveButton.snp.bottom).offset(8).constraint
            make.leading.trailing.bottom.equalToSuperview()
        }

        tableView.register(ChatCell.self, forCellReuseIdentifier: "ChatCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        
        view.bringSubviewToFront(archiveButton)
    }

    private func bindViewModel() {
        viewModel.onChatsUpdated = { [weak self] in
            DispatchQueue.main.async {
                //guard let self = self, self.tableView.window != nil else { return }
                //self.tableView.reloadData()
                guard let self = self else { return }

                        self.view.setNeedsLayout()
                        self.view.layoutIfNeeded()

                        self.tableView.reloadData()
            }
        }

        /*viewModel.onArchiveCountChanged = { [weak self] count in
            DispatchQueue.main.async {
                print("DEBUG → Arşivli sohbet sayısı: \(count)")
                self?.archiveButton.isHidden = count == 0
            }
        }*/
        viewModel.onArchiveCountChanged = { [weak self] count in
            DispatchQueue.main.async {
                guard let self = self else { return }

                let shouldShow = count > 0
                self.archiveButton.isHidden = !shouldShow

                // constraint'i güncelle
                self.tableViewTopConstraint?.deactivate()
                self.tableView.snp.remakeConstraints { make in
                    let topAnchor = shouldShow ? self.archiveButton.snp.bottom : self.filterStack.snp.bottom
                    make.top.equalTo(topAnchor).offset(8)
                    make.leading.trailing.bottom.equalToSuperview()
                }

                UIView.animate(withDuration: 0.25) {
                    self.view.layoutIfNeeded()
                }
            }
        }

        viewModel.onChatArchived = { [weak self] indexPath in
            DispatchQueue.main.async {
                self?.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }

        /*viewModel.onChatUnarchived = { [weak self] _, toIndexPath in
            DispatchQueue.main.async {
                //print("DEBUG → Arşivli sohbet sayısı: \(count)")

                self?.tableView.insertRows(at: [toIndexPath], with: .automatic)
            }
        }*/viewModel.onChatUnarchived = { [weak self] _, _ in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }

        /*viewModel.onChatUnarchived = { [weak self] _, toIndexPath in
            DispatchQueue.main.async{
                guard let self = self, self.isViewLoaded, self.view.window != nil else {
                    return
                }
                self.tableView.insertRows(at: [toIndexPath], with: .automatic)
            }
        }*/


    }

    @objc private func searchTextChanged(_ textField: UITextField) {
        viewModel.searchText = textField.text ?? ""
    }

    @objc private func didTapAdd() {
        print("➕ Yeni sohbet oluşturulacak")
    }

    @objc private func didTapMore() {
        print("⋯ Diğer ayarlar menüsü açıldı")
    }

    @objc private func filterButtonTapped(_ sender: UIButton) {
        switch sender.tag {
        case 0: viewModel.selectedFilter = .all
        case 1: viewModel.selectedFilter = .unread
        case 2: viewModel.selectedFilter = .groups
        default: break
        }
        updateFilterButtonStyles()
    }

    private func updateFilterButtonStyles() {
        let buttons = [allButton, unreadButton, groupsButton]
        for (index, button) in buttons.enumerated() {
            let isSelected = index == viewModel.selectedFilterIndex
            button.backgroundColor = isSelected ? .systemBlue : .clear
            button.setTitleColor(isSelected ? .white : .systemGray, for: .normal)
            button.layer.borderColor = isSelected ? UIColor.systemBlue.cgColor : UIColor.systemGray4.cgColor
        }
    }

    @objc private func openArchivedChats() {
        let archiveVC = ArchivedChatsViewController(viewModel: viewModel)
        navigationController?.pushViewController(archiveVC, animated: true)
    }

}

extension ChatListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.activeChats.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell", for: indexPath) as? ChatCell else {
            return UITableViewCell()
        }
        let chat = viewModel.activeChats[indexPath.row]
        cell.configure(with: chat)
        return cell
    }
}

extension ChatListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.row < viewModel.activeChats.count else { return nil }
        let chat = viewModel.activeChats[indexPath.row]

        let muteAction = ChatSwipeActionProvider.makeSwipeAction(title: "Sesi Aç", systemImage: "speaker.slash.fill", color: .systemOrange) {
            print("Susturuluyor: \(chat.name)")
        }

        let deleteAction = ChatSwipeActionProvider.makeSwipeAction(title: "Sohbeti Sil", systemImage: "trash", color: .systemRed) {
            print("Sohbet siliniyor: \(chat.name)")
        }

        let archiveAction = ChatSwipeActionProvider.makeSwipeAction(title: "Arşivle", systemImage: "archivebox", color: .systemGray) {
            self.viewModel.archiveChat(at: indexPath.row)
        }

        let config = UISwipeActionsConfiguration(actions: [archiveAction, deleteAction, muteAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {
        
        let chat = viewModel.archivedChats[indexPath.row] //activeChats[indexPath.row]
        
        let pinAction = ChatSwipeActionProvider.makeSwipeAction(title: chat.isPinned ? "Sabitlemeyi Kaldır" : "Sabitle",systemImage: "pin.fill",
                                        color: .systemGreen){}//        self.viewModel.togglePin(for: chat.id)
         // pin title duruma göre değişir 
        
        let unreadAction = ChatSwipeActionProvider.makeSwipeAction(title: "Okunmadı", systemImage: "bubble.fill", color: .systemBlue) {
            print("Okunmadı olarak işaretlendi: \(chat.name)")
        }

        let config = UISwipeActionsConfiguration(actions: [ unreadAction,pinAction])
        config.performsFirstActionWithFullSwipe = false
        return config
    }
}

