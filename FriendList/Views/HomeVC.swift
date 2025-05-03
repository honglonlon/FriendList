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
    private let viewModel = HomeViewModel()
    private var anyCancellables: Set<AnyCancellable> = []

    //MARK: SubViews
    
    private let profileHeaderView: ProfileHeaderView = {
        let headerView = ProfileHeaderView()
        return headerView
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
        setUpNavbarItems()
        configureUI()
        definesPresentationContext = true
    }
    
    //MARK: Private func
    
    private func setUpNavbarItems() {
        // 左邊第1個按鈕
        let barBtnWithDraw = UIBarButtonItem(
            image: UIImage(named: "icNavPinkWithdraw"), // 替換成你的圖片名稱
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
    
    private func configureUI() {
        
        view.backgroundColor = .white
        
        addChild(friendListVC)
        view.addSubviews(profileHeaderView, pagerView, friendListVC.view)
        
        profileHeaderView.snp.makeConstraints { make in
            make.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(view.snp.height).multipliedBy(82.0/705.0)
        }
        
        pagerView.snp.makeConstraints { make in
            //TODO: 之後中間改插入一個inviteView
            make.top.equalTo(profileHeaderView.snp.bottom)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(pagerView.snp.width).multipliedBy(44.0/375.0)
        }
        
        friendListVC.view.snp.makeConstraints { make in
            make.top.equalTo(pagerView.snp.bottom)
            make.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    
    }
    
    
    @objc private func navbarButtonTapped() {
        print("navbarButtonTapped")
    }
}
