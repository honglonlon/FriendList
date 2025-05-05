//
//  EmptyView.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/3.
//

import UIKit
import SnapKit

class EmptyView: UIView {

    //MARK: Properties
    
    
    //MARK: Subviews
    private let bannerImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "imgFriendsEmpty"))
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "就從加好友開始吧：）"
        label.font = .systemFont(ofSize: 25, weight: .medium)
        label.textColor = .lbLightGrey
        label.textAlignment = .center
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "與好友們一起用 KOKO 聊起來！\n還能互相收付款、發紅包喔：）"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .btnLightGrey
        label.textAlignment = .center
        return label
    }()
    
    private let addFriendButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.title = "加好友"
        config.titleAlignment = .center
        config.image = UIImage(named: "icAddFriendWhite")
        config.imagePlacement = .trailing
        config.imagePadding = 0
        config.cornerStyle = .capsule
        config.baseBackgroundColor = .clear

        let btn = UIButton(configuration: config)
        btn.tintColor = .white
        btn.contentHorizontalAlignment = .fill

        let gradient = CAGradientLayer()
        gradient.name = "addFriendGradient"
        gradient.colors = [UIColor.frogGreen.cgColor,
                           UIColor.booger.cgColor]
        gradient.startPoint = CGPoint(x: 0, y: 0.5)
        gradient.endPoint   = CGPoint(x: 1, y: 0.5)
        btn.layer.insertSublayer(gradient, at: 0)

        return btn
    }()
    
    private let kokoIDButton: UIButton = {
        let full = "幫助好友更快找到你？ 設定 KOKO ID"
        let attr = NSMutableAttributedString(string: full)

        attr.addAttribute(.foregroundColor,
                          value: UIColor.btnLightGrey,
                          range: NSRange(location: 0, length: full.count))

        
        if let range = full.range(of: "設定 KOKO ID") {
            let nsRange = NSRange(range, in: full)
            attr.addAttributes([
                .foregroundColor : UIColor.hotPink,
                .underlineStyle  : NSUnderlineStyle.single.rawValue
            ], range: nsRange)
        }

        let btn = UIButton(type: .system)
        btn.setAttributedTitle(attr, for: .normal)
        btn.contentHorizontalAlignment = .center
        btn.titleLabel?.numberOfLines = 1
        return btn
    }()
    
    
    //MARK: init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: Life Cycle
    override func layoutSubviews() {
        super.layoutSubviews()
        configureUI()
        layoutIfNeeded()
        updateAddFriendInsets()
        
        if let gradient = addFriendButton.layer.sublayers?
                            .first(where: { $0.name == "addFriendGradient" }) as? CAGradientLayer {
            gradient.frame = addFriendButton.bounds
            gradient.cornerRadius = addFriendButton.bounds.height / 2
        }
    }
    
    
    //MARK: Private Functions
    private func configureUI() {
        addSubviews(bannerImageView, titleLabel, descriptionLabel, addFriendButton, kokoIDButton)
        
        bannerImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(bounds.height * 30.0/445.0)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(245.0/375.0)
            make.height.equalTo(bannerImageView.snp.width).multipliedBy(172.0/245.0)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(bannerImageView.snp.bottom).offset(bounds.height * 41.0/445.0)
            make.leading.trailing.centerX.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(bounds.height * 10.0/445.0)
            make.leading.trailing.centerX.equalToSuperview()
        }
        
        addFriendButton.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(bounds.height * 25.0/445.0)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(192.0/375.0)
            make.height.equalTo(addFriendButton.snp.width).multipliedBy(40.0/192.0)
        }
        
        kokoIDButton.snp.makeConstraints { make in
            make.top.equalTo(addFriendButton.snp.bottom).offset(bounds.height * 37.0/445.0)
            make.centerX.equalToSuperview()
        }
    }
    
    private func updateAddFriendInsets() {
        guard addFriendButton.bounds.width > 0 else { return }
        let leading = addFriendButton.bounds.width * 0.38
        if var config = addFriendButton.configuration {
            config.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: leading, bottom: 0, trailing: 10)
            addFriendButton.configuration = config
        }
    }
    

}
