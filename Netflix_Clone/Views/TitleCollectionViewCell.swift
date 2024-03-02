//
//  TitleCollectionViewCell.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 02/03/24.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private let posterImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(posterImageView)
    }
    
    required init(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        posterImageView.frame = contentView.bounds
    }
    
    public func confirgure(with model: String){
        let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)")
        posterImageView.sd_setImage(with: url)
        
    }
}

