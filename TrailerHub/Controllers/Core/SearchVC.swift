//
//  SearchVC.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 14/02/24.
//

import UIKit

class SearchVC: UIViewController {
    
    
    
    private let searchVC : UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsVC())
        controller.searchBar.placeholder = "Search for a Movie/TV Show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.searchController = searchVC
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchVC.searchResultsUpdater = self
    }
}


extension SearchVC : UISearchResultsUpdating, searchResultsVCDelegate {
    func searchResultsVCDidTapAt(with model: TitlePreviewVM) {
        DispatchQueue.main.async{
            let vc = TitlePreviewVC()
            vc.configure(with: model)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
    
        guard let query = searchController.searchBar.text?.trimmingCharacters(in: .whitespaces),
              !query.isEmpty,
              query.count >= 3,
              let resultController = searchController.searchResultsController as? SearchResultsVC  else {return}
            
        resultController.delegate1 = self
        resultController.delegate2 = self
       
        
        APICaller.shared.getSearchResults(with: query) { results in
            DispatchQueue.main.async(){
                
                switch results {
                    
                case.success(let title):
                    resultController.titles = title
                    resultController.searchResultsCollectionView.reloadData()
                    
                case.failure(let e):
                    print(e.localizedDescription)
                    
                    
                }
            }
        }
                
    }
}

extension SearchVC : CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidSelect(with title: String, viewModel: TitlePreviewVM) {

        DispatchQueue.main.async{ [weak self] in
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            
            print("Here")
            self?.navigationController?.pushViewController(vc, animated: true)
           
        }
     }
    
    
}
