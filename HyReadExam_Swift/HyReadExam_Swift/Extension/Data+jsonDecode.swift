//
//  Data+jsonDecode.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import Foundation

extension Data {
    func jsonDecoder<T: Decodable>(type: T.Type) -> T? {
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(T.self, from: self)
            return model
        }
        catch{
            return nil
        }
    }
}
