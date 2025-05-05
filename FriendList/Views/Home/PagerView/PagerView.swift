//
//  PagerView.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/1.
//

import UIKit
import SnapKit

class PagerView: UIView {

    //MARK: Properties
    private var indicatorCenterX: Constraint?
    
    //MARK: SubViews
    private let tabContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteTwo
        return view
    }()
    
    private let tabStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .leading
        stackView.spacing = 30
        return stackView
    }()
    
    private let friendTabBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("好友", for: .normal)
        btn.setTitleColor(.lbLightGrey, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        return btn
    }()
    
    private let chatTabBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("聊天", for: .normal)
        btn.setTitleColor(.lbLightGrey, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        return btn
    }()
    
    private let tabIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = .hotPink
        view.layer.masksToBounds = true
        return view
    }()
    
    private let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .veryLightGrey
        return view
    }()

    //MARK: Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
        friendTabBtn.addTarget(self, action: #selector(didTapTab(_:)), for: .touchUpInside)
        chatTabBtn.addTarget(self, action: #selector(didTapTab(_:)), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Life Cycle
    
    override func layoutSubviews() {
        tabIndicator.layer.cornerRadius = tabIndicator.bounds.height / 2
    }
    
    
    //MARK: Private functions
    
    func configureUI() {
        addSubviews(tabContainerView)
        tabContainerView.addSubviews(tabStackView, tabIndicator, seperatorView)
        
        tabStackView.addArrangedSubview(friendTabBtn)
        tabStackView.addArrangedSubview(chatTabBtn)
        
        tabContainerView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(tabContainerView.snp.width).multipliedBy(44.0/375.0)
        }
        
        tabStackView.snp.makeConstraints { make in
            make.leading.equalTo(tabContainerView).inset(screenWidth * 0.08)
            make.bottom.equalToSuperview().inset(4)
        }
        
        tabIndicator.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            indicatorCenterX = make.centerX.equalTo(friendTabBtn).constraint
            make.width.equalTo(friendTabBtn.snp.width).multipliedBy(0.6)
            make.height.equalTo(4)
        }
        
        seperatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(tabContainerView)
            make.height.equalTo(1)
        }

    }
    
    @objc private func didTapTab(_ sender: UIButton) {
        let targetButton: UIButton = (sender == friendTabBtn) ? friendTabBtn : chatTabBtn
        
        tabIndicator.snp.remakeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalTo(targetButton)
            make.width.equalTo(targetButton.snp.width).multipliedBy(0.6)
            make.height.equalTo(4)
        }
        
        UIView.animate(withDuration: 0.25) {
            self.layoutIfNeeded()
        }
    }
}
