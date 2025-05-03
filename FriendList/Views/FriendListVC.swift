//
//  FriendListVC.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/2.
//

import UIKit

class FriendListVC: UIViewController {
    
    //MARK: Properties
    
    
    //MARK: Subviews
    private let searchContainerView: UIView = {
        let containerView = UIView()
        return containerView
    }()
    
    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "想轉一筆給誰呢？"
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
//        tableView.refreshControl = refreshControl
        tableView.register(FriendTableViewCell.self, forCellReuseIdentifier: FriendTableViewCell.reuseID)
        return tableView
    }()
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    //MARK: Private Functions
    private func configureUI() {
        view.addSubviews(searchContainerView, tableView)
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
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    
}


extension FriendListVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: FriendTableViewCell.reuseID, for: indexPath) as? FriendTableViewCell else {
            return UITableViewCell()
        }
        return cell
    }
    
    
}


// MARK: - UISearchResultsUpdating
extension FriendListVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        let query = searchController.searchBar.text ?? ""
        // TODO: Filter your table view data based on `query` and reload the table.
    }
}
