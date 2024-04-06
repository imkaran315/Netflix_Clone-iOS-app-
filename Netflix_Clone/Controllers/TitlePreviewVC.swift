//
//  TitlePreviewVC.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 07/03/24.
//

import UIKit
import WebKit

protocol TitlePreviewVCDelegate : AnyObject{
    func TitlePreviewSaveToLibrary(model: Movie)
}

class TitlePreviewVC: UIViewController {
    
    weak var delegate : TitlePreviewVCDelegate?
    
    private let webView : WKWebView = {
        let webView = WKWebView()
        webView.translatesAutoresizingMaskIntoConstraints = false
        webView.backgroundColor = .systemBackground
        webView.allowsLinkPreview = true
        return webView
    }()
    
    private let titleNameLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let overviewLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 10
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let saveButton : UIButton = {
        let button = UIButton()
        button.setTitle("Save", for: .normal)
        button.widthAnchor.constraint(equalToConstant: 130).isActive = true
        button.heightAnchor.constraint(equalToConstant: 25).isActive = true
        button.layer.cornerRadius = 6
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.titleLabel?.numberOfLines = 1
        
        button.configuration = .filled()
        button.configuration?.baseBackgroundColor = .systemRed
        
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func configureConstraints(){
        let webViewConstraints = [
            webView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        let titleNameLabelConstraints = [
            titleNameLabel.topAnchor.constraint(equalTo: webView.bottomAnchor, constant: 20),
            titleNameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            
        ]
        
        let overviewLabelConstraints = [
            overviewLabel.topAnchor.constraint(equalTo: titleNameLabel.bottomAnchor, constant: 20),
            overviewLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor ,constant: 10),
            overviewLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10)
        ]
        
        let saveButtonConstraints = [
            saveButton.topAnchor.constraint(equalTo: overviewLabel.bottomAnchor, constant: 50),
            saveButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
        ]
        
        NSLayoutConstraint.activate(webViewConstraints)
        NSLayoutConstraint.activate(titleNameLabelConstraints)
        NSLayoutConstraint.activate(overviewLabelConstraints)
        NSLayoutConstraint.activate(saveButtonConstraints)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(webView)
        view.addSubview(titleNameLabel)
        view.addSubview(overviewLabel)
        view.addSubview(saveButton)
        saveButton.addTarget(nil, action: #selector(saveButtonPressed), for: .touchUpInside)
        
        configureConstraints()
        
        navigationController?.navigationBar.tintColor = .white
        
    }
    
    @objc private func saveButtonPressed(){
//        delegate?.TitlePreviewSaveToLibrary(model: <#T##Movie#>)
    }
    
     func configure(with model : TitlePreviewVM){
        
         DispatchQueue.main.async {
             self.titleNameLabel.text = model.title
             self.overviewLabel.text = model.titleOverview ?? ""
             guard let videoId = model.Video.id.videoId else {return}
             guard let url = URL(string: "https://www.youtube.com/embed/\(videoId)") else {return}
             print(url)
             self.webView.load(URLRequest(url: url))
         }
    }

}
