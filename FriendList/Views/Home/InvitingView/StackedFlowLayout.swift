//
//  StackedFlowLayout.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/4.
//

import UIKit

class StackedFlowLayout: UICollectionViewFlowLayout {
    
    // MARK: - Config
    private let cardHeight: CGFloat       = 70          // 展開後高度
    private let collapsedOffset: CGFloat  = 10          // 收合層間距
    private let scaleDelta: CGFloat       = 0.04        // 每層縮放量
    private let expandedSpacing: CGFloat  = 10          // 展開行距
    
    weak var viewModel: InvitingFriendViewModel?
    
    // MARK: - Lifecycle
    override func prepare() {
        super.prepare()
        scrollDirection      = .vertical
        minimumLineSpacing   = 0
        itemSize             = CGSize(width: collectionView!.bounds.width, height: cardHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        guard let attrs     = super.layoutAttributesForElements(in: rect),
              let viewModel = viewModel else { return nil }
        
        let cardCount  = viewModel.invitingFriends.count
        
        for attr in attrs {
            let idx = attr.indexPath.item
            
            if viewModel.isExpanded {
                // 展開狀態
                attr.frame.origin.y = CGFloat(idx) * (cardHeight + expandedSpacing)
                attr.transform      = .identity
                attr.zIndex         = cardCount - idx
            } else {
                // 收合狀態
                attr.frame.origin.y = CGFloat(idx) * collapsedOffset
                let scale = 1.0 - CGFloat(idx) * scaleDelta
                attr.transform      = CGAffineTransform(scaleX: scale, y: scale)
                attr.zIndex         = cardCount - idx
            }
        }
        return attrs
    }
    
    // 收合時 contentSize 只需到最底張卡
    override var collectionViewContentSize: CGSize {
        guard let viewModel = viewModel else { return .zero }
        if !viewModel.isExpanded {
            let h = cardHeight + CGFloat(viewModel.invitingFriends.count - 1) * collapsedOffset
            return .init(width: collectionView!.bounds.width, height: h)
        }
        return super.collectionViewContentSize
    }
    
    func invalidateForStateChange() {
        invalidateLayout()
    }
}
