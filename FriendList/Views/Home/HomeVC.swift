//
//  HomeVC.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/4/28.
//

import UIKit
import SnapKit
import Combine

class HomeVC: UIViewController {
    
    //MARK: Properties
    private let viewModel               = HomeViewModel()
    private let loadFriendListSubject   = PassthroughSubject<Void, Never>()
    private let loadUserInfoSubject     = PassthroughSubject<Void, Never>()
    private let modeChangeSubject       = PassthroughSubject<FriendListMode, Never>()
    private var cancellables            = Set<AnyCancellable>()
    
    private var friendListTopToSafe: Constraint?
    private var friendListTopToPager: Constraint?
    private var invitingFriendViewExpand: Constraint?
    private var invitingFriendViewCollapse: Constraint?
    
    
    //MARK: SubViews
    private let profileHeaderView: ProfileHeaderView = {
        let headerView = ProfileHeaderView()
        return headerView
    }()
    
    private let invitingFriendVC: InvitingFriendVC = {
        let vc = InvitingFriendVC()
        return vc
    }()
    
    private let pagerView: PagerView = {
        let pagerView = PagerView()
        return pagerView
    }()
    
    private let friendListVC: FriendListVC = {
        let vc = FriendListVC()
        return vc
    }()
    

    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        friendListVC.delegate = self
        setUpNavbarItems()
        configureUI()
        
        let input = HomeViewModel.Input(loadUserInfo: loadUserInfoSubject.eraseToAnyPublisher(),
                                        loadFriendList: loadFriendListSubject.eraseToAnyPublisher(),
                                        modeChange: modeChangeSubject.eraseToAnyPublisher())
        let output = viewModel.transform(input: input)
        bind(output: output)
        friendListVC.configure(friendListPublisher: output.friendList)
        invitingFriendVC.configure(invitingListPublisher: output.invitingList)
        loadUserInfoSubject.send()
        loadFriendListSubject.send()
    }
    
    
    //MARK: Private functions
    private func bind(output: HomeViewModel.Output) {
        output.userInfo
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userInfo in
                self?.profileHeaderView.setUserInfo(info: userInfo)
            }
            .store(in: &cancellables)
        
        output.errorMessage
            .compactMap { $0 }
            .receive(on: DispatchQueue.main)
            .sink { [weak self] errorMessage in
                self?.presentErrorAlert(message: errorMessage)
            }
            .store(in: &cancellables)
        
        output.friendListMode
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mode in
                self?.updateLayout(for: mode)
            }
            .store(in: &cancellables)
    }
    
    private func setUpNavbarItems() {
        // 左邊第1個按鈕
        let barBtnWithDraw = UIBarButtonItem(
            image: UIImage(named: "icNavPinkWithdraw"),
            style: .plain,
            target: self,
            action: #selector(navbarButtonTapped)
        )
        barBtnWithDraw.tintColor = UIColor.hotPink
        
        // 左邊第2個按鈕
        let barBtnTransfer = UIBarButtonItem(
            image: UIImage(named: "icNavPinkTransfer"),
            style: .plain,
            target: self,
            action: #selector(navbarButtonTapped)
        )
        barBtnTransfer.tintColor = UIColor.hotPink
        
        navigationItem.leftBarButtonItems = [barBtnWithDraw, barBtnTransfer]
        
        // 右邊的按鈕
        let barBtnScan = UIBarButtonItem(
            image: UIImage(named: "icNavPinkScan"),
            style: .plain,
            target: self,
            action: #selector(navbarButtonTapped)
        )
        barBtnScan.tintColor = UIColor.hotPink
        navigationItem.rightBarButtonItem = barBtnScan
    }
    
    private func updateLayout(for mode: FriendListMode) {
        switch mode {
        case .noFriend, .onlyFriend:
            invitingFriendViewCollapse?.activate()
            invitingFriendViewExpand?.deactivate()
        case .friendWithInvite:
            invitingFriendViewCollapse?.deactivate()
            invitingFriendViewExpand?.activate()
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        addChild(friendListVC)
        friendListVC.didMove(toParent: self)
        view.addSubviews(profileHeaderView, invitingFriendVC.view, pagerView, friendListVC.view)
        
        profileHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.height).multipliedBy(82.0/705.0)
        }
        
        invitingFriendVC.view.snp.makeConstraints { make in
            make.top.equalTo(profileHeaderView.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            self.invitingFriendViewExpand = make.height.equalTo(150).constraint
            self.invitingFriendViewCollapse = make.height.equalTo(0).constraint
        }
        self.invitingFriendViewExpand?.deactivate()
        
        pagerView.snp.makeConstraints { make in
            make.top.equalTo(invitingFriendVC.view.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(pagerView.snp.width).multipliedBy(44.0/375.0)
        }
        
        friendListVC.view.snp.makeConstraints { make in
            self.friendListTopToSafe = make.top.equalTo(view.safeAreaLayoutGuide).constraint
            self.friendListTopToPager = make.top.equalTo(pagerView.snp.bottom).constraint
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        self.friendListTopToSafe?.deactivate()
    }
    
    private func presentErrorAlert(message: String) {
        let alert = UIAlertController(title: "錯誤", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "確定", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func navbarButtonTapped() {
        let controller = UIAlertController(title: "切換模式", message: "選擇顯示模式", preferredStyle: .actionSheet)
        let names = [FriendListMode.noFriend.rawValue, FriendListMode.onlyFriend.rawValue, FriendListMode.friendWithInvite.rawValue]
        for name in names {
           let action = UIAlertAction(title: name, style: .default) { action in
               if let mode = FriendListMode(rawValue: name) {
                   self.modeChangeSubject.send(mode)
               }
           }
           controller.addAction(action)
        }
        let cancelAction = UIAlertAction(title: "取消", style: .cancel)
        controller.addAction(cancelAction)
        present(controller, animated: true)
    }
}


extension HomeVC: FriendListVCDelegate {
    func didRequestRefreshBy(friendListVC: FriendListVC) {
        modeChangeSubject.send(viewModel.friendListMode)
    }
    
    func didChangeSearchEditingBy(friendListVC: FriendListVC, isEditing: Bool) {
        if isEditing {
            friendListTopToPager?.deactivate()
            friendListTopToSafe?.activate()
        } else {
            friendListTopToSafe?.deactivate()
            friendListTopToPager?.activate()
        }
        UIView.animate(withDuration: 0.25) {
            self.view.layoutIfNeeded()
        }
    }
    
    
}
