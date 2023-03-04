//
//  ImageHelper.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import UIKit.UIImage
import SDWebImage

class ImageHelper {
    func downloadUrlImage(urlString: String, completionHandle: ((UIImage)->Void)? ) {
        let url = URL(string: urlString)
        SDWebImageManager.shared.loadImage(with: url, options: [], progress: nil) { (image, data, error, cacheType, finished, url) in
            if let error = error {
                DebugPrint("image download Error \(error)")
                return
            }
            if let image = image {
                completionHandle?(image)
            }
        }
    }
    
    
    func clearCache() {
        SDImageCache.shared.clearDisk {
            DebugPrint("All cache cleared.")
        }
        
    }
}
