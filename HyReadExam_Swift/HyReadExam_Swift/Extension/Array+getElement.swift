//
//  Array+getElement.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation


extension Array {
    
    func getElement(_ index: Int) -> Element? {
        if indices.contains(index) {
            return self[index]
        } else {
            return nil
        }
    }
}
