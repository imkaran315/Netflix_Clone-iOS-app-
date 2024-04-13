//
//  HomeVC.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 14/02/24.
//

import UIKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Upcoming = 2
    case TopRated = 3
}

class HomeVC: UIViewController {
    
    let sectionTitles = [ "Trending Movies", "Trending TV", "Upcoming", "Top Rated"]
    
    private let homeFeedTable :UITableView  = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.tintColor = .white;  
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: "CollectionViewTableViewCell")
        return table
    }()
    
    private func configureNavBar(){
//        var image = UIImage(named: "netflixlogo")
//        image = image?.withRenderingMode(.alwaysOriginal)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        let TitleName = UIBarButtonItem(title: "TrailerHub", style: .done, target: self, action: nil)
        TitleName.style = .plain
        TitleName.tintColor = .white
        TitleName.isEnabled = false

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "TrailerHub", style: .done, target: self, action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .done, target: self, action: #selector(searchButtonPressed))
           
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc func searchButtonPressed(){
        let searchPage = SearchVC()
        
        navigationController?.pushViewController(searchPage, animated: false)
    }
 
    private func configureHeroHeaderView(){
        let headerView = HeroHeaderUIView(frame:CGRect(x: 0, y: 0, width: view.bounds.width, height:550))
        APICaller.shared.getTrendingMovies { results in
            switch results {
            case .success(let title):
                DispatchQueue.main.async{
                    let title = title[Int.random(in: 0...9)]
                    headerView.confirgure(with: title.poster_path ?? "", name: title.original_title ?? title.original_name ?? "")
                    
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
        homeFeedTable.tableHeaderView = headerView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(homeFeedTable)
        view.backgroundColor = .systemBlue
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavBar()
        configureHeroHeaderView()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

/// TableView delegate methods

extension HomeVC: UITableViewDelegate, UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CollectionViewTableViewCell", for: indexPath) as? CollectionViewTableViewCell else{
            return UITableViewCell()
        }
        
        cell.delegate = self
        
        
        switch indexPath.section{
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { results in
                switch results{
                case.success(let success):
//                    cell.configure(with: titles)
                    cell.configure(with: success)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTV.rawValue:
            APICaller.shared.getTrendingTV { results in
                switch results{
                case.success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { results in
                switch results{
                case.success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { results in
                switch results{
                case.success(let titles):
                    cell.configure(with: titles)
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        default:
            return UITableViewCell()
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset

        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

/// Collection View Cell previews the video
extension HomeVC: CollectionViewTableViewCellDelegate{
    func collectionViewTableViewCellDidSelect(with title: String, viewModel: TitlePreviewVM) {

        DispatchQueue.main.async{ [weak self] in
            let vc = TitlePreviewVC()
            vc.configure(with: viewModel)
            
            print("Here")
            self?.navigationController?.pushViewController(vc, animated: true)
           
        }
     }
    }
    
