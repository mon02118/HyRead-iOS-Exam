//
//  PreviewImageViewController.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/5.
//
import UIKit

class PreviewImageViewController: UIViewController {
    
    // 宣告 imageView
    private let imageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    // 用來存放圖片 URL
    var imageUrlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        // 將 imageView 加入到畫面中
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        if let imageUrlString = imageUrlString {
            ImageHelper().downloadUrlImage(urlString: imageUrlString) {[weak self] setImage in  self?.imageView.image = setImage }
        }
    }

}
