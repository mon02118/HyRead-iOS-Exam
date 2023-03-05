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
        let tipObservable = BehaviorRelay<TipType>(value: .none)
        
        private let dbInfo = UserBookInfoDB()
        private var dbModelList: [UserBookInfo] = []
        
        func fetchDbModelList() {
            tipObservable.accept(.loadingDB)
            dbModelList = SqlLiteManager.shared.getSqlLiteDataFromTable(dbInfo, orderBy: .asc("UUID"))
            let origiModelList = userBookListObservable.value
            let setModelList = origiModelList + dbModelList
            userBookListObservable.accept(setModelList)
        }
        
        func fetchUserBooklist() {
            tipObservable.accept(.loadingNetwork)
            ApiService().fetchUserBooklist { [weak self] result in
                guard let weakSelf = self else { return }
                switch result {
                case .success(let response): weakSelf.saveToDB(response)
                case .failure(let error): DebugPrint(error.msg)
                }
            }
        }
        
        func updateUserBookInfo(new: UserBookInfo, i: Int) {
            if dbModelList.isSafe(i) {
                dbModelList[i].isFavorite.toggle()
                userBookListObservable.accept(dbModelList)
            }
            SqlLiteManager.shared.updateSqlLiteData(dbInfo,
                                                    conditionDict: ["UUID": "\(new.uuid)"],
                                                    setDict: ["IS_FAVORITE": "\(new.isFavorite.sqlString)"])
        }
        
        func removeDBData() {
            SqlLiteManager.shared.deleteSqlLiteTable(dbInfo)
            dbModelList = []
            userBookListObservable.accept(dbModelList)
        }
        
        func filterFavoriteData(isFavorite: Bool) {
            let setModelList = dbModelList.filter { $0.isFavorite == isFavorite }
            userBookListObservable.accept(setModelList)
        }
        func showAllData() {
            userBookListObservable.accept(dbModelList)
        }
        
        func getUserBookInfo(i: Int) -> UserBookInfo? {
            userBookListObservable.value.getElement(i)
        }
   
    }
}

private extension UserListViewController.ViewModel {
    
    func saveToDB(_ response: [UserBookInfoResponse]) {
        let dbUUIDSet = dbModelList.map(\.uuid)
        let modelList = response
            .map { $0.toModel() }
            .filter { !dbUUIDSet.contains($0.uuid) }
        SqlLiteManager.shared.insertSqlLiteDataIntoTable(dbInfo, infos: modelList)
        
        tipObservable.accept(.loadingNetwork)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {[weak self] in
            self?.tipObservable.accept(.finish)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {[weak self] in
            self?.tipObservable.accept(.close)
        }
        if modelList.isEmpty { return }
        dbModelList += modelList
        userBookListObservable.accept(dbModelList)
       
        
        
        
    }
}


private extension UserBookInfoResponse {
    func toModel() -> UserBookInfo {
        UserBookInfo(uuid: self.uuid, coverUrl: self.coverUrl, publishDate: self.publishDate, publisher: self.publisher, author: self.author, title: self.title)
    }
}
