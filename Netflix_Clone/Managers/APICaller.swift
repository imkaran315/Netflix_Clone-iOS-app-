//
//  APICaller.swift
//  Netflix_Clone
//
//  Created by Karan Verma on 26/02/24.
//

import Foundation

struct constants {
    static let API_Key = "74f6ef939cb44c99fd482dce34908712"
    static let baseURL = "https://api.themoviedb.org"
}

enum APIerror: Error {
    case failedToGetData
}

class APICaller{
    static let shared = APICaller()
    
    func getTrendingMovies(completion: @escaping(Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(constants.baseURL)/3/trending/movie/day?api_key=\(constants.API_Key)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _ , error in
            if let error = error{
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data recieved")
                return
            }
            
            /// Decode results from web
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                print(error.localizedDescription)
            }
        }
        task.resume()
        
        
    }
    
    func getTrendingTV(completion: @escaping(Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(constants.baseURL)/3/trending/tv/day?api_key=\(constants.API_Key)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _ , error in
            if let error = error{
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data recieved")
                return
            }
            
            /// Decode results from web
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    func getPopularMovies(completion: @escaping(Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(constants.baseURL)/3/movie/popular?api_key=\(constants.API_Key)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _ , error in
            if let error = error{
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data recieved")
                return
            }
            
            /// Decode results from web
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    func getUpcomingMovies(completion: @escaping(Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(constants.baseURL)/3/movie/upcoming?api_key=\(constants.API_Key)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _ , error in
            if let error = error{
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data recieved")
                return
            }
            
            /// Decode results from web
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
    
    func getTopRated(completion: @escaping(Result<[Movie], Error>) -> Void){
        guard let url = URL(string: "\(constants.baseURL)/3/movie/top_rated?api_key=\(constants.API_Key)") else {return}
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _ , error in
            if let error = error{
                print("Error: \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                print("No data recieved")
                return
            }
            
            /// Decode results from web
            do{
                let results = try JSONDecoder().decode(TrendingMoviesResponse.self, from: data)
                completion(.success(results.results))
            }
            catch{
                print(error.localizedDescription)
            }
            
        }
        task.resume()
    }
}
