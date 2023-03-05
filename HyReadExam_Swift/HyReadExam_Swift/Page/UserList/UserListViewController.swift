//
//  UserListViewController.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/3.
//

import RxSwift
import RxCocoa

class UserListViewController: UIViewController {
    
    private let vm = ViewModel()
    private let disposeBag = DisposeBag()
    
    private let tipLabel: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
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
        
        let addButton = UIBarButtonItem(image: UIImage(systemName: "filemenu.and.cursorarrow"), menu: getDebugMenu())
        navigationItem.rightBarButtonItem = addButton
        
        view.addSubview(userBookInfoCollectiomView)
        view.addSubview(tipLabel)
        NSLayoutConstraint.activate([
            tipLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tipLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tipLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            userBookInfoCollectiomView.topAnchor.constraint(equalTo: tipLabel.bottomAnchor),
            userBookInfoCollectiomView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            userBookInfoCollectiomView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            userBookInfoCollectiomView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
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
        userBookInfoCollectiomView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
    }
   
    
    func getDebugMenu() -> UIMenu{
        let settingMenu = UIMenu(title: "", children: [
            UIAction(title: "刪除資料庫", image: UIImage(systemName: "minus.diamond")) {[weak self] action in
                self?.vm.removeDBData()
            },
            UIAction(title: "刪除圖片快取", image: UIImage(systemName: "minus.diamond")) { _ in
                ImageHelper().clearCache()
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
    func getDetailInfoMenu(info: UserBookInfo) -> UIMenu{
        let detailMenu = UIMenu(title: "", children: [
            UIAction(title: "\(info.publishDate)", image: UIImage(systemName: "calendar.badge.clock")) {_ in },
            UIAction(title: "\(info.publisher)", image: UIImage(systemName: "house"))  {_ in },
            UIAction(title: "\(info.author)", image: UIImage(systemName: "person"))  {_ in },
            UIAction(title: "\(info.title)", image: UIImage(systemName: "highlighter"))  {_ in },
            
        ])
        return detailMenu
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
extension UserListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        guard let fitstIndex = indexPaths.first?.row,
              let model = vm.getUserBookInfo(i: fitstIndex)
        else { return nil }
        
        let config = UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: {
                let previewImageVC = PreviewImageViewController()
                previewImageVC.imageUrlString = model.coverUrl
                return previewImageVC
            },
            actionProvider:  {[weak self] _ in
            return self?.getDetailInfoMenu(info: model)
        })
        

        return config
    }
}


private extension UserListViewController {
    class UserBookInfoCollectiomViewLayout: UICollectionViewFlowLayout {
        override func prepare() {
            super.prepare()
            // 取得目前裝置的螢幕尺寸
            let deviceSize = UIScreen.main.bounds.size
            
            // 設定每個項目的水平和垂直間距
            let itemSpacing: CGFloat = 10
            let lineSpacing: CGFloat = 10
            
            // 設定section的邊緣間距
            let edgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
            // 計算每一行最多能放幾個項目，取決於裝置的寬度以及項目的固定寬度
            var count = Int((deviceSize.width)/150.0)
            
            // 如果計算出來的項目數小於3，則設置為3（最少要放3個項目）
            if count < 3 { count = 3 }
            
            // 計算每個項目的寬度和高度，考慮間距和邊緣
            let width = deviceSize.width/CGFloat(count) - edgeInsets.left/2 - edgeInsets.right/2 - itemSpacing
            let height = width*1.8
            
            // 設置項目的尺寸
            let itemSize = CGSize(width: width , height: height)
            
            // 設置水平和垂直間距以及section的邊緣間距
            minimumLineSpacing = lineSpacing
            minimumInteritemSpacing = itemSpacing
            sectionInset = edgeInsets
            
            // 設置項目的尺寸
            self.itemSize = itemSize
        }
    }
}
