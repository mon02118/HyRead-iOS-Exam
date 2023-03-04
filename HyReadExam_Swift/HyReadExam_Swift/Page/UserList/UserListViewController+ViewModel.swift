//
//  UserListViewController+ViewModel.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation

extension UserListViewController {
    class ViewModel {
                
        func fetchUserBooklist() {
            ApiService().fetchUserBooklist { result in
                switch result {
                case .success(let modelList): print(modelList)
                case .failure(let error): print(error.msg)
                    
                }
            }
        }
        
    }
}

