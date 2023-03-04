//
//  UserListViewController+TipType.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import UIKit.UIColor

extension UserListViewController {
    enum TipType {
        case none
        case loadingDB
        case loadingNetwork
        case finish
        case close
        var msg: String {
            switch self {
            case .none: return "準備中.."
            case .loadingDB: return "資料庫讀取中.."
            case .loadingNetwork: return "網路資料抓取中.."
            case .finish: return "書籍準備好了！"
            case .close: return ""
            }
        }
        var heightValue: CGFloat {
            switch self {
            case .none, .loadingDB, .loadingNetwork, .finish: return 30.0
            case .close: return 0
            }
        }
        var bgColor: UIColor {
            switch self {
            case .none: return .white
            case .loadingDB: return .yellow.withAlphaComponent(0.5)
            case .loadingNetwork: return .blue.withAlphaComponent(0.5)
            case .finish: return .green.withAlphaComponent(0.5)
            case .close: return .clear
            }
        }
    }
}
