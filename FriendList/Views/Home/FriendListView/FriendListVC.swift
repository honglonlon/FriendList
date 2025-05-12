//
//  FriendListVC.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/2.
//

import UIKit
import Combine

//MARK: Delegate
protocol FriendListVCDelegate: AnyObject {
  // 下拉重新整理
  func didRequestRefreshBy(friendListVC: FriendListVC)
  // 開始/結束搜索
  func didChangeSearchEditingBy(friendListVC: FriendListVC, isEditing: Bool)
}


class FriendListVC: UIViewController {
    
    //MARK: Properties
    weak var delegate: FriendListVCDelegate?
    private let viewModel       = FriendListViewModel()
    private var cancellables    = Set<AnyCancellable>()
    private var keywordSubject  = CurrentValueSubject<String, Never>("")
    
    
    private lazy var refreshControl: UIRefreshControl = {
        let rc = UIRefreshControl()
        rc.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return rc
    }()
    
    private lazy var tapGesture: UITapGestureRecognizer = {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        gesture.cancelsTouchesInView = false
        return gesture
    }()
    
    //MARK: Subviews
    private let searchContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "想轉一筆給誰呢？"
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()
    
    private let addFriendBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "icBtnAddFriends"), for: .normal)
        button.tintColor = .hotPink
        button.imageView?.contentMode = .scaleAspectFit
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.refreshControl = refreshControl
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.reuseID)
        return tableView
    }()
    
    private let emptyView: EmptyView = {
        let view = EmptyView()
        return view
    }()
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        configureUI()
    }
    
    
    // MARK: - Injection
    /// 由父層注入好友 Publisher 並啟動 ViewModel
    func configure(friendListPublisher: AnyPublisher<[Friend], Never>) {
        let input = FriendListViewModel.Input(
            friends: friendListPublisher,
            keyword: keywordSubject.eraseToAnyPublisher()
        )
        let output = viewModel.transform(input: input)
        
        // 綁定空畫面顯示
        output.showEmptyView
            .receive(on: DispatchQueue.main)
            .sink { [weak self] show in
                self?.emptyView.isHidden = !show
                self?.tableView.isHidden = show
            }
            .store(in: &cancellables)
        
        // 綁定好友資料刷新
        output.filteredFriends
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.refreshControl?.endRefreshing()
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }
    
    private func configureUI() {
        view.addGestureRecognizer(tapGesture)
        view.backgroundColor = .white
        view.addSubviews(searchContainerView, tableView, emptyView)
        searchContainerView.addSubviews(searchBar, addFriendBtn)
        
        searchContainerView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.84)
            make.height.equalTo(searchContainerView.snp.width).multipliedBy(36.0/315.0)
        }
        
        searchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(-8)
            make.top.bottom.equalToSuperview()
        }
        
        addFriendBtn.snp.makeConstraints { make in
            make.leading.equalTo(searchBar.snp.trailing).offset(3)
            make.top.bottom.trailing.equalToSuperview()
            make.height.equalTo(addFriendBtn.snp.width)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.width.equalToSuperview().multipliedBy(89.4/100)
            make.bottom.centerX.equalToSuperview()
        }
        
        emptyView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(15)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
        delegate?.didChangeSearchEditingBy(friendListVC: self, isEditing: false)
    }
    
    @objc private func handleRefresh() {
        delegate?.didRequestRefreshBy(friendListVC: self)
    }
}


// MARK: - UITableViewDataSource, UITableViewDelegate
extension FriendListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.reuseID, for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        cell.setFriend(friend: viewModel.filteredFriends[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


// MARK: - UISearchBarDelegate
extension FriendListVC: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        keywordSubject.send(searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        delegate?.didChangeSearchEditingBy(friendListVC: self, isEditing: true)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        delegate?.didChangeSearchEditingBy(friendListVC: self, isEditing: false)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
