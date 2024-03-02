//
//  UpcomingVC.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 14/02/24.
//

import UIKit

class UpcomingVC: UIViewController {
    
    private let table 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        
    }
}
