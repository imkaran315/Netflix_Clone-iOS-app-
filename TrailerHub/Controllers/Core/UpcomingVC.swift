//
//  UpcomingVC.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 14/02/24.
//

import UIKit

class UpcomingVC: UIViewController {
    
    private var titles: [Movie] = [Movie]()
    
    private let upcomingTable : UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
        return table
    }()
    
    private func fetchMovies(){
        APICaller.shared.getUpcomingMovies { [weak self] results in
            switch results{
            case .success(let title):
                self?.titles = title
                DispatchQueue.main.async{
                    self?.upcomingTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        
        fetchMovies()
        
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    
}

extension UpcomingVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        /// creating  a cell of type UpcomingTableView Cell
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TitleTableViewCell", for: indexPath) as? TitleTableViewCell else
        {
            return UITableViewCell()
        }
        
        /// modeling the cell as per custom ViewModel named TitleViewModel
        let title = titles[indexPath.row].original_title ?? titles[indexPath.row].original_name ?? "Unknown Title"
        cell.configure(with: TitleVM(titleName: title , posterURL: titles[indexPath.row].poster_path) )
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = titles[indexPath.row]
        
        let titleName = title.original_title ?? title.original_name ?? ""
        
        APICaller.shared.getMovie(with: titleName) { results in
            switch results {
            case .success(let success):
                DispatchQueue.main.async{
                    let vc = TitlePreviewVC()
                    vc.configure(with: TitlePreviewVM(Video: success, title: titleName, titleOverview: title.overview ?? ""))
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let e):
                print(e.localizedDescription)
            }
        }
    }
}
