//
//  InvitingFriendViewModel.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/4.
//

import Foundation
import Combine

class InvitingFriendViewModel {
    //MARK: Properties
    @Published private(set) var invitingFriend: [Friend] = []
    @Published private(set) var isExpanded: Bool = false
    // 點擊卡片
    let tapSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    
    //MARK: Init
    init() {
        tapSubject
            .sink { [weak self] in
                self?.isExpanded.toggle()
            }
            .store(in: &cancellables)
    }
    
    
    //MARK: Public Function
    func setInvitingFriends(_ friends: [Friend]) {
        self.invitingFriend = friends
    }
    
    
}
