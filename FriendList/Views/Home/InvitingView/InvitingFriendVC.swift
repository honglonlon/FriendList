//
//  InvitingFriendVC.swift
//  FriendList
//
//  Created by 楊豐榮 on 2025/5/4.
//

import UIKit
import Combine
import SnapKit

class InvitingFriendVC: UIViewController {

    //MARK: Properties
    private let viewModel       = InvitingFriendViewModel()
    private let tapSubject      = PassthroughSubject<Void, Never>()
    private var cancellables    = Set<AnyCancellable>()
    
    
    //MARK: Subviews
    private let layout  = StackedFlowLayout()
    private lazy var collectionView: UICollectionView = {
        layout.viewModel = viewModel
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(InvitingFriendCell.self, forCellWithReuseIdentifier: InvitingFriendCell.reuseID)
        cv.backgroundColor = .clear
        cv.dataSource = self
        cv.delegate   = self
        return cv
    }()
    
    
    //MARK: Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    
    // MARK: - Injection
    func configure(invitingListPublisher: AnyPublisher<[Friend], Never>) {
        let input = InvitingFriendViewModel.Input(
            invitingFriends: invitingListPublisher,
            tap: tapSubject.eraseToAnyPublisher()
        )
        
        let output = viewModel.transform(input: input)
        
        output.invitingFriends
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        output.isExpanded
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.25,
                               delay: 0,
                               usingSpringWithDamping: 0.9,
                               initialSpringVelocity: 0.5,
                               options: [.curveEaseInOut]) {
                    self.layout.invalidateForStateChange()
                    self.collectionView.layoutIfNeeded()
                }
            }
            .store(in: &cancellables)
    }
    
    
    //MARK: Private Functions
    private func configureUI() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
}


//MARK: UICollectionViewDataSource
extension InvitingFriendVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.invitingFriends.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: InvitingFriendCell.reuseID, for: indexPath) as! InvitingFriendCell
        let friend = viewModel.invitingFriends[indexPath.item]
        cell.setInvitingFriend(friend: friend)
        return cell
    }
    
    func collectionView(_ cv: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        tapSubject.send()
    }
}
