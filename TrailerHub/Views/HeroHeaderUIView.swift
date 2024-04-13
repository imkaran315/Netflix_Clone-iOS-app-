//
//  HeroHeaderUIView.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 23/02/24.
//

import UIKit

class HeroHeaderUIView: UIView {
    
    
    private let heroImageView: UIImageView = {
        let imageview = UIImageView()
        imageview.contentMode = .scaleAspectFill
        imageview.clipsToBounds = true
        return imageview
    }()
    
    /// Setting up Play Button
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("Play", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /// Setting up Save Button
    private let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        button.translatesAutoresizingMaskIntoConstraints = false
        
      
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    
    
    /// Function for adding gradient layer on hero header
    private func addGradient(){
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }
    
    // Constraints for layout of PlayButton
    private func applyConstraints(){
        
        let heroImageViewConstraints = [
            heroImageView.topAnchor.constraint(equalTo: topAnchor, constant: 0)
        ]
        
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
            playButton.widthAnchor.constraint(equalToConstant: 100)
        ]
        
        let saveButtonConstraints = [
            saveButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            saveButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -100),
            saveButton.widthAnchor.constraint(equalToConstant: 110)
        ]
        
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: playButton.bottomAnchor, constant: 15),
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ]
        NSLayoutConstraint.activate(heroImageViewConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(saveButtonConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
    }
    
    public func confirgure(with model: String, name: String?){
        let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)")
        heroImageView.sd_setImage(with: url)
        nameLabel.text = name ?? ""
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(playButton)
        addSubview(saveButton)
        addSubview(nameLabel)
       
        applyConstraints()
        
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
    }
     
    required init?(coder: NSCoder) {
        fatalError()
    }
}
