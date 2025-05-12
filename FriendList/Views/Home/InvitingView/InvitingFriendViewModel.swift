//
//  InvitingFriendViewModel.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/4.
//

import Foundation
import Combine

class InvitingFriendViewModel {
    // MARK: - Input
    struct Input {
        let invitingFriends: AnyPublisher<[Friend], Never>
        let tap: AnyPublisher<Void, Never>
    }
    
    // MARK: - Output
    struct Output {
        let invitingFriends: AnyPublisher<[Friend], Never>
        let isExpanded: AnyPublisher<Bool, Never>
    }
    
    //MARK: Properties
    @Published private(set) var invitingFriends: [Friend] = []
    @Published private(set) var isExpanded: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    
    // MARK: - Transform
    func transform(input: Input) -> Output {
        input.invitingFriends
            .assign(to: &$invitingFriends)
    
        input.tap
            .sink { [weak self] in
                self?.isExpanded.toggle()
            }
            .store(in: &cancellables)
        
        return Output(
            invitingFriends: $invitingFriends.eraseToAnyPublisher(),
            isExpanded: $isExpanded.eraseToAnyPublisher()
        )
    }
    
}
