//
//  ImageAssets.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import UIKit


enum ImageAssets: String {
    
    case heartUnFill
    case heartFill
    case bookPlaceholder
    
    var image: UIImage? {
        switch self {
        case .heartFill: return  UIImage(named: "icon_heart_fill")
        case .heartUnFill: return  UIImage(named: "icon_heart")
        case .bookPlaceholder: return  UIImage(systemName: "books.vertical")
        }
    }
}
