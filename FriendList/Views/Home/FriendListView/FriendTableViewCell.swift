//
//  FriendTableViewCell.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/2.
//

import UIKit
import SnapKit

class FriendTableViewCell: UITableViewCell {
    
    //MARK: Properties
    static let reuseID = "FriendTableViewCell"
    //是否為送出邀請
    var showsInviting: Bool = false {
        didSet { updateButtonLayout() }
    }

    private var transferTrailingToInviting: Constraint?
    private var transferTrailingToMore:     Constraint?
    private var invitingTrailingConstraint: Constraint?
    private var moreTrailingConstraint:     Constraint?
    
    //MARK: Subviews
    private let starImageView : UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "icFriendsStar"))
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "imgFriendsFemaleDefault"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lbLightGrey
        return label
    }()
    
    private let transferBtn: UIButton = {
        var title = AttributedString("轉帳")
        title.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = title
        config.baseForegroundColor = .hotPink
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8)
        
        let btn = UIButton(configuration: config, primaryAction: nil)
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.hotPink.cgColor
        btn.layer.masksToBounds = true
        
        return btn
    }()
    
    private let invitingBtn: UIButton = {
        var title = AttributedString("邀請中")
        title.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        
        var config = UIButton.Configuration.filled()
        config.attributedTitle = title
        config.baseForegroundColor = .btnLightGrey
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 8, bottom: 3, trailing: 8)
        
        let btn = UIButton(configuration: config, primaryAction: nil)
        btn.layer.cornerRadius = 2
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.btnLightGrey.cgColor
        btn.layer.masksToBounds = true
        
        return btn
    }()
    
    private let moreBtn: UIButton = {
        var config = UIButton.Configuration.filled()
        config.baseForegroundColor = .btnLightGrey
        config.baseBackgroundColor = .clear
        config.contentInsets = NSDirectionalEdgeInsets(top: 3, leading: 10, bottom: 3, trailing: 10)
        config.image = UIImage(named: "icFriendsMore")
        let btn = UIButton(configuration: config)
        
        return btn
    }()
    
    private let separatorView: UIView = {
        var view = UIView()
        view.backgroundColor = .seperatorGrey
        return view
    }()

    //MARK: init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        nameLabel.text = "黃靖僑"
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatarImageView.layer.cornerRadius = avatarImageView.bounds.width / 2
    }
    
    func setFriend(friend: Friend) {
        nameLabel.text = friend.name
        if friend.isTop == "0" {
            starImageView.isHidden = true
        } else {
            starImageView.isHidden = false
        }
        if friend.status == .inviteSent {
            showsInviting = true
        } else {
            showsInviting = false
        }
    }
    
    //MARK: Private Functions
    private func configureUI() {
        addSubviews(starImageView, avatarImageView, nameLabel, transferBtn, invitingBtn, moreBtn, separatorView)
        
        starImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(14.0/335.0)
            make.height.equalTo(starImageView.snp.width)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalTo(starImageView.snp.trailing).offset(6)
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(40.0/335.0)
            make.height.equalTo(avatarImageView.snp.width)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(15)
            make.centerY.equalToSuperview()
        }
        
        invitingBtn.snp.makeConstraints { make in
            self.invitingTrailingConstraint = make.trailing.equalToSuperview().constraint
            make.centerY.equalToSuperview()
        }

        transferBtn.snp.makeConstraints { make in
            // 邀請中模式
            self.transferTrailingToInviting = make.trailing.equalTo(invitingBtn.snp.leading).offset(-10).constraint
            // 更多模式
            self.transferTrailingToMore = make.trailing.equalTo(moreBtn.snp.leading).offset(-10).constraint
            make.centerY.equalToSuperview()
        }

        moreBtn.snp.makeConstraints { make in
            self.moreTrailingConstraint = make.trailing.equalToSuperview().constraint
            make.centerY.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints { make in
            make.leading.equalTo(nameLabel)
            make.trailing.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
            make.height.equalTo(1)
        }
        
        updateButtonLayout()
    }

    private func updateButtonLayout() {
        if showsInviting {
            invitingBtn.isHidden    = false
            moreBtn.isHidden        = true

            transferTrailingToInviting?.activate()
            transferTrailingToMore?.deactivate()
            invitingTrailingConstraint?.activate()
            moreTrailingConstraint?.deactivate()
        } else {
            invitingBtn.isHidden    = true
            moreBtn.isHidden        = false

            transferTrailingToInviting?.deactivate()
            transferTrailingToMore?.activate()
            invitingTrailingConstraint?.deactivate()
            moreTrailingConstraint?.activate()
        }
    }
}
