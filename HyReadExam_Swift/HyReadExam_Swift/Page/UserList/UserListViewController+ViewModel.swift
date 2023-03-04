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
        
        private let dbInfo = UserBookInfoDB()
        private var dbModelList: [UserBookInfo] = []
        
        func fetchDbModelList() {
            dbModelList = SqlLiteManager.shared.getSqlLiteDataFromTable(dbInfo, orderBy: .asc("UUID"))
            let origiModelList = userBookListObservable.value
            let setModelList = origiModelList + dbModelList
            userBookListObservable.accept(setModelList)
        }
        
        func fetchUserBooklist() {
            ApiService().fetchUserBooklist { [weak self] result in
                guard let weakSelf = self else { return }
                switch result {
                case .success(let response): weakSelf.saveToDB(response)
                case .failure(let error): DebugPrint(error.msg)
                }
            }
        }
        
        func updateUserBookInfo(new: UserBookInfo) {
            SqlLiteManager.shared.updateSqlLiteData(dbInfo,
                                                    conditionDict: ["UUID": "\(new.uuid)"],
                                                    setDict: ["IS_FAVORITE": "\(new.isFavorite.sqlString)"])
        }
        
        
    }
}

private extension UserListViewController.ViewModel {
    
    func saveToDB(_ response: [UserBookInfoResponse]) {
        let dbUUIDSet = dbModelList.map(\.uuid)
        let modelList = response.map { $0.toModel() }
            .filter { !dbUUIDSet.contains($0.uuid) }
        SqlLiteManager.shared.insertSqlLiteDataIntoTable(dbInfo, infos: modelList)
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
