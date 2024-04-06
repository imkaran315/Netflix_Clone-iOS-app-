//
//  SearchResultsVC.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 06/03/24.
//

import UIKit

protocol searchResultsVCDelegate : AnyObject {
    func searchResultsVCDidTapAt(with model: TitlePreviewVM)
}



class SearchResultsVC: UIViewController {

    public var titles : [Movie] = [Movie]()
    
    weak var delegate1 : searchResultsVCDelegate?
    weak var delegate2: CollectionViewTableViewCellDelegate?
    
    public let searchResultsCollectionView : UICollectionView = {
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 9, height: 200)
        layout.minimumLineSpacing = 10
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultsCollectionView)
        
        searchResultsCollectionView.delegate = self
        searchResultsCollectionView.dataSource = self
        
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultsCollectionView.frame = view.bounds
    }
    
    private func saveTitleAt(indexPath :IndexPath){
        
        DataPersistenceManager.shared.saveTitleinLibrary(model: titles[indexPath.row]) { result in
            switch result{
            case.success():
                NotificationCenter.default.post(name: NSNotification.Name("Downloaded"), object: nil)
            case.failure(let e):
                print(e.localizedDescription)
            }
        }
    }
    
    private func playTitleAt(indexPath: IndexPath){
       let title = titles[indexPath.row]
       let titleName = title.original_title ?? title.original_name ?? ""

       APICaller.shared.getMovie(with: titleName) { [weak self] result in
           guard let self = self else { return }
           
           switch result {
           case .success(let ytTitle):
               
               let viewModel = TitlePreviewVM(Video: ytTitle, title: titleName, titleOverview: title.overview)
               self.delegate2?.collectionViewTableViewCellDidSelect(with: titleName, viewModel: viewModel)
           case .failure(let error):
                   print(error.localizedDescription + "are yaar")
               }
           }
   }
    
}

extension SearchResultsVC : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = searchResultsCollectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
                
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        let titleName = title.original_title ?? title.original_name ?? ""
        
        APICaller.shared.getMovie(with: titleName) { results in
            switch results {
            case .success(let success):
                DispatchQueue.main.async{
                    self.delegate1?.searchResultsVCDidTapAt(with: TitlePreviewVM(Video: success , title: titleName, titleOverview: title.overview ?? ""))
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    
    }
    
    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemsAt indexPaths: [IndexPath], point: CGPoint) -> UIContextMenuConfiguration? {
        
        let config = UIContextMenuConfiguration( identifier: nil, previewProvider: nil) { _ in
            
            let saveButton = UIAction(title: "Save") { _ in
                self.saveTitleAt(indexPath: indexPaths[0])
            }
            let playButton = UIAction(title: "Play"){ _ in
                self.playTitleAt(indexPath: indexPaths[0])
            }
            return UIMenu(children: [playButton, saveButton])
            
        }
        return config
    }
    
}

extension SearchResultsVC: CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidSelect(with title: String, viewModel: TitlePreviewVM) {
        print("here")

        DispatchQueue.main.async{ [weak self] in
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            

            self?.navigationController?.pushViewController(vc, animated: true)
           
        }
     }
    }
    

