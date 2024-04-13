//
//  DataPersistenceManager.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 15/03/24.
//

import Foundation
import UIKit
import CoreData

enum DataPersistenceError : Error{
    case failedToGetData
    case failedToRetrieveData
    case failedToDeleteData
}

struct DataPersistenceManager {
    
    static let shared  = DataPersistenceManager()
   
    func saveTitleinLibrary(model : Movie, completion: @escaping (Result<Void,Error>) -> Void){
        guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let item = MovieTitle(context: context)
        
        item.id = Int64(model.id)
        item.original_name = model.original_name
        item.original_title = model.original_title
        item.overview = model.overview
        item.poster_path = model.poster_path
        item.media_type = model.media_type
        item.vote_count = Int64(model.vote_count)
        item.vote_average = model.vote_average
        item.release_date = model.release_date
        
        do{
            try context.save()
            completion(.success(()))
        }
        catch{
            completion(.failure(DataPersistenceError.failedToGetData))
        }
    }
    
    func fetchSavedTitlesIntoLibrary(completion: @escaping (Result<[MovieTitle], Error>) -> Void){
        guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request : NSFetchRequest<MovieTitle>
        
        request = MovieTitle.fetchRequest()
        
        do{
           let titles =  try context.fetch(request)
            completion(.success(titles))
        }
        catch{
            completion(.failure(DataPersistenceError.failedToRetrieveData))
        }
    }
    
    func deleteTitleFromCoreData(model : MovieTitle, completion : @escaping (Result<Void, Error>) -> Void){
        guard let appDelegate =  UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let context = appDelegate.persistentContainer.viewContext
        
        context.delete(model)
        
        do{
            try context.save()
            completion(.success(()))
        }
        catch
        {
            completion(.failure(DataPersistenceError.failedToDeleteData))
        }
    }
    
}
