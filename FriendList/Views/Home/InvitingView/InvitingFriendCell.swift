//
//  InvitingFriendCell.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/4.
//

import UIKit
import SnapKit

class InvitingFriendCell: UICollectionViewCell {
    
    //MARK: Properties
    static let reuseID = "InvitingFriendCell"
    
    //MARK: Subviews
    private let shadowView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 10
        return view
    }()

    private let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        view.layer.masksToBounds = true
        return view
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "imgFriendsFemaleDefault"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lbLightGrey
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13, weight: .regular)
        label.textColor = .btnLightGrey
        label.text = "邀請你成為好友：）"
        return label
    }()
    
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        return stackView
    }()
    
    private let agreeButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: "btnFriendsAgree")
        config.background.imageContentMode = .scaleAspectFit
        let button = UIButton(configuration: config)
        return button
    }()
    
    private let deleteButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.background.image = UIImage(named: "btnFriendsDelet")
        config.background.imageContentMode = .scaleAspectFit
        let button = UIButton(configuration: config)
        return button
    }()

    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        configureUI()
    }
    
    func setInvitingFriend(friend: Friend) {
        nameLabel.text = friend.name
    }
    
    
    //MARK: Private Functions
    private func configureUI() {
        containerView.backgroundColor = .white
        
        addSubview(shadowView)
        shadowView.addSubview(containerView)
        containerView.addSubviews(avatarImageView, labelStackView, buttonStackView)
        
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(descriptionLabel)
        buttonStackView.addArrangedSubview(agreeButton)
        buttonStackView.addArrangedSubview(deleteButton)
        
        shadowView.snp.makeConstraints { make in
            make.top.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.84)
        }

        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().offset(15)
            make.bottom.equalToSuperview().inset(15)
            make.width.equalTo(avatarImageView.snp.height)
        }
        
        labelStackView.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(15)
            make.top.bottom.equalTo(avatarImageView)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(15)
            make.top.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
            make.width.equalToSuperview().multipliedBy(75.0/315.0)
        }
        
    }
    
}
