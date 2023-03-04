//
//  UserListViewController.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/3.
//

import UIKit

class UserListViewController: UIViewController {
    private let vm = ViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        vm.fetchUserBooklist()
        
        
        
    }


}



