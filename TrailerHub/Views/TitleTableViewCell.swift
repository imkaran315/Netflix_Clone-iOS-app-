//
//  UpcomingTableViewCell.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 03/03/24.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"
    
    private let posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 3
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let titleNameLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.showsExpansionTextWhenTruncated = true
        label.numberOfLines = 2
        
        return label
    }()
    
    private let playButton : UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 25))
        button.setImage(image, for: .normal)
        button.tintColor = .secondarySystemFill
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func applyConstraints(){
        let posterImageConstraints = [
            posterImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            posterImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            posterImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            posterImage.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let titleNameLabelConstraints = [
            titleNameLabel.leadingAnchor.constraint(equalTo: posterImage.trailingAnchor, constant: 15),
            titleNameLabel.trailingAnchor.constraint(equalTo: playButton.leadingAnchor),
            titleNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        
        let playButtonConstraints = [
            playButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            playButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(posterImageConstraints)
        NSLayoutConstraint.activate(titleNameLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
        
    }
    
    public func configure( with model : TitleVM){
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL ?? " ")") else {return }
        posterImage.sd_setImage(with: url)
        
        titleNameLabel.text = model.titleName
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .black
        contentView.addSubview(posterImage)
        contentView.addSubview(titleNameLabel)
        contentView.addSubview(playButton)
        
        applyConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
