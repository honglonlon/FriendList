//
//  UIView+Ext.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/4/28.
//

import Foundation
import UIKit

extension UIView {
    
    /// 直接回傳螢幕寬度
    var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }
    
    /// 直接回傳螢幕高度
    var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
    
    /// 一次加入多個subview
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
    
    
}
