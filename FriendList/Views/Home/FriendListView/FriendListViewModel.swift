//
//  FriendListViewModel.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/4.
//

import Foundation
import Combine

class FriendListViewModel {
    //MARK: Properties
    @Published var friends: [Friend] = []
    @Published var keyword: String = ""
    @Published private(set) var filteredFriends: [Friend] = []
    @Published private(set) var showEmptyView: Bool = true
    private var cancellables = Set<AnyCancellable>()
    
    
    //MARK: Init
    init() {
        // 合併 好友清單、關鍵字 將過濾後的值指派給filteredFriends
        Publishers.CombineLatest($friends, $keyword)
            .map { friends, keyword in
                guard !keyword.isEmpty else { return friends }
                return friends.filter { $0.name.contains(keyword) }
            }
            .assign(to: &$filteredFriends)
        
        // 原始好友清單為空顯示EmptyView
        $friends
            .map(\.isEmpty)
            .assign(to: &$showEmptyView)
    }
    
    
    //MARK: Public Functions
    func setFriendListData(list: [Friend]) {
        friends = list
    }
    
}
