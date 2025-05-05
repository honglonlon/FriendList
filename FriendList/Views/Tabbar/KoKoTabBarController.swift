//
//  tabBarController.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/3.
//

import UIKit
import SnapKit

class KoKoTabBarController: UITabBarController {
    
    //MARK: Properties
    
    //MARK: Subviews
    let centerButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "icTabbarHomeOff")
        let button = UIButton(configuration: config, primaryAction: nil)
        button.tintColor = .clear
        return button
    }()
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        UITabBar.appearance().tintColor = .hotPink
        viewControllers = [createProductsVC(), createHomeNC(), createKOKOVC(), createManageVC(), createSettingVC()]
        selectedIndex = 1
        setupCenterButton()
    }
    
    
    //MARK: Private Functions
    private func createProductsVC() ->UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarProductsOff"), tag: 0)
        return vc
    }
    
    private func createHomeNC() -> UINavigationController {
        let homeVC        = HomeVC()
        homeVC.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarFriendsOn"), tag: 1)
        return UINavigationController(rootViewController: homeVC)
    }
    
    private func createKOKOVC() ->UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem()
        vc.tabBarItem.tag = 3
        
        return vc
    }
    
    private func createManageVC() ->UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarManageOff"), tag: 4)
        return vc
    }
    
    private func createSettingVC() ->UIViewController {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(title: "", image: UIImage(named: "icTabbarSettingOff"), tag: 5)
        return vc
    }
    
    private func setupCenterButton() {
        tabBar.addSubview(centerButton)
        centerButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-85.0 / 3.0)
            make.height.width.equalTo(85)
        }
        centerButton.addTarget(self, action: #selector(centerButtonTapped), for: .touchUpInside)
    }

    @objc private func centerButtonTapped() {
        selectedIndex = 2
        centerButton.isSelected = true
    }

}


extension UITabBar {
    open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 先確認 Tab Bar 的 delegate是 KoKoTabBarController
        if let tabBarController = self.delegate as? KoKoTabBarController {
            // 將傳進來的觸控點轉換到 centerButton 的座標系中
            let convertedPoint = tabBarController.centerButton.convert(point, from: self)
            // 判斷這個「轉換後的點」是否落在按鈕本身的bounds內
            if tabBarController.centerButton.bounds.contains(convertedPoint) {
                return tabBarController.centerButton
            }
        }
        // 如果不是點在那顆按鈕上走原本邏輯去找對應的按鈕
        return super.hitTest(point, with: event)
    }
}
