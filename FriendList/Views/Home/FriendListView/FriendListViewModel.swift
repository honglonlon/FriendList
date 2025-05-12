//
//  FriendListViewModel.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/4.
//

import Foundation
import Combine

class FriendListViewModel {
    //MARK: Input
    struct Input {
        let friends: AnyPublisher<[Friend], Never>
        let keyword: AnyPublisher<String, Never>
    }

    //MARK: Output
    struct Output {
        let filteredFriends: AnyPublisher<[Friend], Never>
        let showEmptyView: AnyPublisher<Bool, Never>
    }
    
    //MARK: Properties
    @Published private(set) var filteredFriends: [Friend] = []
    @Published private(set) var showEmptyView: Bool = true
    private var cancellables = Set<AnyCancellable>()
    
    func transform(input: Input) -> Output {
        Publishers
            .CombineLatest(input.friends, input.keyword)
            .map { friends, keyword -> [Friend] in
                guard !keyword.isEmpty else { return friends }
                return friends.filter { $0.name.contains(keyword) }
            }
            .assign(to: &$filteredFriends)
        
        input.friends
            .map(\.isEmpty)
            .assign(to: &$showEmptyView)
        
        return Output(filteredFriends: $filteredFriends.eraseToAnyPublisher(),
                      showEmptyView: $showEmptyView.eraseToAnyPublisher())
    }

    
}
