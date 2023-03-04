//
//  UserBookInfoCollectiomViewCell.swift
//  HyReadExam_Swift
//
//  Created by AddA on 2023/3/4.
//

import UIKit

protocol UserBookInfoCollectiomViewCellDelegate: AnyObject {
    func didUpdateUserBookInfo(new: UserBookInfo)
}


class UserBookInfoCollectiomViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "UserBookInfoCollectiomViewCell"
    
    override func prepareForReuse() {
        bookImageView.image = ImageAssets.bookPlaceholder.image
        bookImageView.contentMode = .center
        titleLable.text = ""
        favoriteButton.isSelected = false
        userBookInfo = nil
    }
    
    private var userBookInfo: UserBookInfo?
    
    weak var delegate: UserBookInfoCollectiomViewCellDelegate?
    
    private let containerView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let bookImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = ImageAssets.bookPlaceholder.image
        iv.tintColor = .white
        iv.contentMode = .center
        iv.backgroundColor = .gray
        iv.layer.cornerRadius = 4.4
        return iv
    }()
    
    private lazy var favoriteButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(ImageAssets.heartUnFill.image, for: .normal)
        btn.setImage(ImageAssets.heartFill.image, for: .selected)
        btn.addTarget(self, action: #selector(didTapFavoriteBtn), for: .touchUpInside)
        return btn
    }()
    
    private let titleLable: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        lbl.numberOfLines = 2
        lbl.font = .systemFont(ofSize: 14)
        return lbl
    }()
    
    
    private let gradientView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 4.4
        return v
    }()
        
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    override func draw(_ rect: CGRect) {
        gradientView.applyGradient(colors: [.black.withAlphaComponent(0.5), .clear])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setInfo(_ info: UserBookInfo) {
        self.userBookInfo = info
        titleLable.text = "\(info.title)\n"
        favoriteButton.isSelected = info.isFavorite
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
        containerView.addSubview(favoriteButton)
        
        bookImageView.addSubview(gradientView)
        
        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            bookImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            bookImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            bookImageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            bookImageView.heightAnchor.constraint(equalTo: bookImageView.widthAnchor, multiplier: 1.4),
            
            gradientView.topAnchor.constraint(equalTo: bookImageView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: bookImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: bookImageView.trailingAnchor),
            gradientView.heightAnchor.constraint(equalToConstant: 55),
            
            
            favoriteButton.topAnchor.constraint(equalTo: bookImageView.topAnchor),
            favoriteButton.trailingAnchor.constraint(equalTo: bookImageView.trailingAnchor),
            favoriteButton.widthAnchor.constraint(equalToConstant: 50),
            favoriteButton.heightAnchor.constraint(equalToConstant: 50),
            
            titleLable.topAnchor.constraint(equalTo: bookImageView.bottomAnchor),
            titleLable.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            titleLable.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            titleLable.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
        ])
    }
    
    @objc
    func didTapFavoriteBtn(sender: UIButton) {
        favoriteButton.isSelected.toggle()
        userBookInfo?.isFavorite = favoriteButton.isSelected
        if let info = userBookInfo {
            delegate?.didUpdateUserBookInfo(new: info)
        }
    }
}
