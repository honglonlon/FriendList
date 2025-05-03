//
//  ProfileHeaderView.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/1.
//

import UIKit
import SnapKit

class ProfileHeaderView: UIView {

    //MARK: Properties
    
    //MARK: SubViews
    
    private let infoContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .whiteTwo
        return view
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fill
        stackView.spacing = 8
        return stackView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 17, weight: .medium)
        label.textColor = UIColor.black
        label.textAlignment = .left
        label.text = "紫晽"
        return label
    }()
    
    private let settingBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("設定 KOKO ID", for: .normal)
        btn.setTitleColor(.lbLightGrey, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        btn.setImage(UIImage(named: "icInfoBackDeepGray"), for: .normal)
        btn.tintColor = .lbLightGrey
        btn.semanticContentAttribute = .forceRightToLeft
        btn.contentHorizontalAlignment = .left
        return btn
    }()
    
    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "imgFriendsFemaleDefault"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = imageView.bounds.width / 2
        return imageView
    }()
    
    
    //MARK: init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: private function
    
    private func configureUI() {
        addSubviews(infoContainerView)
        infoContainerView.addSubviews(avatarImageView, nameStackView)
        
        nameStackView.addArrangedSubview(nameLabel)
        nameStackView.addArrangedSubview(settingBtn)
        
        infoContainerView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.84)
            make.height.equalToSuperview().multipliedBy(54.0/82.0)
        }
        
        nameStackView.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.trailing.greaterThanOrEqualTo(avatarImageView.snp.leading)
            make.top.greaterThanOrEqualToSuperview().offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }
        
        avatarImageView.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.width.equalTo(avatarImageView.snp.height).multipliedBy(52.0/54.0)
        }
        
    }

}
