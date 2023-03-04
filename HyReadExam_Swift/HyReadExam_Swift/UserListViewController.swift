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
    
    private let tipLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.text = "TEST"
        lbl.backgroundColor = .gray
        return lbl
    }()
    
    private var tipHeight: NSLayoutConstraint?
    
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
        fetchData()
    }
}


private extension UserListViewController {
    func setupUI() {
        title = "我的書櫃"
        let addButton = UIBarButtonItem(image: UIImage(systemName: "filemenu.and.cursorarrow"), menu: getMenu())
        
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(userBookInfoCollectiomView)
        view.addSubview(tipLabel)
        NSLayoutConstraint.activate([
            tipLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tipLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userBookInfoCollectiomView.topAnchor.constraint(equalTo: tipLabel.bottomAnchor),
            userBookInfoCollectiomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            userBookInfoCollectiomView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            userBookInfoCollectiomView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        
        tipHeight = tipLabel.heightAnchor.constraint(equalToConstant: 0)
        tipHeight?.isActive = true
        
    }
    
    func bindData() {
        
      
        vm.tipObservable
            .do(onNext: { [weak self] state in
                UIView.animate(withDuration: 1) {
                    self?.tipHeight?.constant = state.heightValue
                    self?.tipLabel.backgroundColor = state.bgColor
                    self?.view.layoutIfNeeded()
                }
            })
            .map { $0.msg}
            .bind(to: tipLabel.rx.text)
            .disposed(by: disposeBag)
                
        vm.userBookListObservable
            .bind(to: userBookInfoCollectiomView.rx.items(cellIdentifier: UserBookInfoCollectiomViewCell.reuseIdentifier, cellType: UserBookInfoCollectiomViewCell.self)) { (row, model, cell) in
                cell.setInfo(model)
                cell.didUpdateUserBookInfo = {[weak self] new in
                    self?.vm.updateUserBookInfo(new: new, i: row)
                }
            }
            .disposed(by: disposeBag)
        
        
    }
    
    func getMenu() -> UIMenu{
        let settingMenu = UIMenu(title: "", children: [
            UIAction(title: "刪除資料庫", image: UIImage(systemName: "minus.diamond")) {[weak self] action in
                self?.vm.removeDBData()
            },
            UIAction(title: "重新抓取資料", image: UIImage(systemName: "arrow.counterclockwise.icloud")) { [weak self] action in
                self?.vm.fetchUserBooklist()
            },
            UIAction(title: "只顯示收藏資料", image: UIImage(systemName: "line.3.horizontal.decrease.circle")) { [weak self] action in
                self?.vm.filterFavoriteData(isFavorite: true)
            },
            UIAction(title: "只顯示沒收藏資料", image: UIImage(systemName: "line.3.horizontal.decrease.circle")) { [weak self] action in
                self?.vm.filterFavoriteData(isFavorite: false)
            },
            UIAction(title: "顯示全部資料", image: UIImage(systemName: "line.3.horizontal.decrease.circle")) { [weak self] action in
                self?.vm.showAllData()
            }
        ])
        return settingMenu
    }
    func fetchData() {
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {[weak self] in
            self?.vm.fetchDbModelList()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {[weak self] in
            self?.vm.fetchUserBooklist()
        }
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
