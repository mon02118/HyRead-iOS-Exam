//
//  UserListViewController+ViewModel.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//


import RxCocoa

extension UserListViewController {
    class ViewModel {
            
    
        let userBookListObservable = BehaviorRelay<[UserBookInfo]>(value: [])
        
        
        func fetchUserBooklist() {
            ApiService().fetchUserBooklist { [weak self] result in
                guard let weakSelf = self else { return }
                switch result {
                case .success(let modelList): weakSelf.userBookListObservable.accept(modelList)
                case .failure(let error): DebugPrint(error.msg)
                    
                }
            }
        }
        
    }
}

