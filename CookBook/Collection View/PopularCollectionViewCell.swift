//
//  PopularCollectionViewCell.swift
//  CookBook
//
//  Created by Alexander Altman on 30.11.2022.
//

import UIKit

class PopularCollectionViewCell: UICollectionViewCell {
    
    static let reuseId = "PopularCollectionViewCell"
    
    let mainImageView: UIImageView = {
      let imageView = UIImageView()
        imageView.backgroundColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(mainImageView)
        NSLayoutConstraint.activate([
            mainImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            mainImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            mainImageView.topAnchor.constraint(equalTo: topAnchor),
            mainImageView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
