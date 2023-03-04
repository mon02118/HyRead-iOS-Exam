//
//  UserListViewController.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/3.
//

import UIKit
import RxSwift
import RxCocoa

class UserListViewController: UIViewController {
    
    private let vm = ViewModel()
    private let disposeBag = DisposeBag()
    
    private let userBookInfoCollectiomView: UICollectionView = {
        let layout = UserBookInfoCollectiomViewLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(UserBookInfoCollectiomViewCell.self, forCellWithReuseIdentifier: UserBookInfoCollectiomViewCell.reuseIdentifier)
        
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindData()
    }
}


private extension UserListViewController {
    func setupUI() {
        title = "我的書櫃"
        view.addSubview(userBookInfoCollectiomView)
        NSLayoutConstraint.activate([
            userBookInfoCollectiomView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            userBookInfoCollectiomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            userBookInfoCollectiomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userBookInfoCollectiomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        
        
        ])
    }
    
    func bindData() {
        vm.fetchDbModelList()
        vm.fetchUserBooklist()
        vm.userBookListObservable
            .bind(to: userBookInfoCollectiomView.rx.items(cellIdentifier: UserBookInfoCollectiomViewCell.reuseIdentifier, cellType: UserBookInfoCollectiomViewCell.self)) { (row, model, cell) in
                cell.setInfo(model)
                cell.didUpdateUserBookInfo = {[weak self] new in
                    self?.vm.updateUserBookInfo(new: new, i: row)
                }
            }
            .disposed(by: disposeBag)
        
        userBookInfoCollectiomView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                ImageHelper().clearCache()
            })
            .disposed(by: disposeBag)
    }
}



private extension UserListViewController {
    class UserBookInfoCollectiomViewLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            let deviceSize = UIScreen.main.bounds.size
            let itemSpacing: CGFloat = 10
            let lineSpacing: CGFloat = 10
            let edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            let count: CGFloat = 3
            let width = deviceSize.width/count - edgeInsets.left/2 - edgeInsets.right/2 - itemSpacing
            let height = width*2
            let itemSize = CGSize(width: width , height: height)
            
            minimumLineSpacing = lineSpacing
            minimumInteritemSpacing = itemSpacing
            sectionInset = edgeInsets
            self.itemSize = itemSize
        }
    }
}
