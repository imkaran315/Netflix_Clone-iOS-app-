//
//  LibraryVC.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 14/02/24.
//

import UIKit

class LibraryVC: UIViewController {
    
    private var titles: [MovieTitle] = [MovieTitle]()
    
    let savedTable : UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: "TitleTableViewCell")
        return table
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Library"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        view.addSubview(savedTable)
        savedTable.delegate = self
        savedTable.dataSource = self
        
        fetchTitlesFromCoreData()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("Downloaded"), object: nil, queue: nil) { _ in
            self.fetchTitlesFromCoreData()
        }
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        savedTable.frame = view.bounds
    }
    
    private func fetchTitlesFromCoreData(){
        DataPersistenceManager.shared.fetchSavedTitlesIntoLibrary { [weak self] result in
            switch result{
            case(.success(let titles)):
                
                    self?.titles = titles
                    self?.savedTable.reloadData()
                
            case(.failure(let e)):
                print(e.localizedDescription)
                
            }
        }
        
    }
}
    
    
    extension LibraryVC: UITableViewDelegate, UITableViewDataSource {
        
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
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            switch editingStyle{
            case .delete:
                // remove the item from Core data
                DataPersistenceManager.shared.deleteTitleFromCoreData(model: titles[indexPath.row]) {[weak self] result in
                    switch result{
                    case(.success(())):
                        print("Deleted from Core")
                        self?.savedTable.reloadData()
                    case(.failure(let e)):
                        print(e.localizedDescription)
                    }
                    
                    // remove item from titles array
                    self?.titles.remove(at: indexPath.row)
                    
                    // remove item from tableView
                    self?.savedTable.deleteRows(at: [indexPath], with: .fade)

                    
                }
            default:
                break;
            }
        }
    }
    

