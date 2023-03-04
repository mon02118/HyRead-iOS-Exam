//
//  UserBookInfoCollectiomViewCell.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import UIKit

class UserBookInfoCollectiomViewCell: UICollectionViewCell {
    
    
    override func prepareForReuse() {
        bookImageView.image = UIImage(systemName: "books.vertical")
        bookImageView.contentMode = .center
    }
    
    static let reuseIdentifier = "UserBookInfoCollectiomViewCell"
    
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let bookImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(systemName: "books.vertical")
        iv.tintColor = .white
        iv.contentMode = .center
        iv.backgroundColor = .gray
        return iv
    }()
    
    private let iconImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
    
        return iv
    }()
    
    private let titleLable: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2
        lbl.font = .systemFont(ofSize: 14)
        lbl.text = "test"
        return lbl
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setInfo(_ info: UserBookInfo) {
        titleLable.text = "\(info.title)\n"
        ImageHelper().downloadUrlImage(urlString: info.coverUrl) {[weak self] setImage in
            self?.bookImageView.contentMode = .scaleAspectFit
            self?.bookImageView.image = setImage
        }
        
    }
    
}


private extension UserBookInfoCollectiomViewCell {
    func setupUI() {
        contentView.addSubview(containerView)
        containerView.addSubview(bookImageView)
        containerView.addSubview(titleLable)
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            bookImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bookImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bookImageView.heightAnchor.constraint(equalTo: bookImageView.widthAnchor, multiplier: 1.4),

            titleLable.topAnchor.constraint(equalTo: bookImageView.bottomAnchor),
            titleLable.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLable.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLable.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
}
