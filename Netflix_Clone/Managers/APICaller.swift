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
    static let YT_API_Key = "AIzaSyCOLNboNeUiSaEAHqzFv-0lAGP-YxUMBUg"
    static let YT_baseURL = "https://youtube.googleapis.com/youtube/v3/search?q="
    
   // "AIzaSyCOPUj5qLTc7a-aJyR2CpyncL1aV5QFZU4"
}

enum APIerror: Error {
    case failedToGetData
}

class APICaller{
    static let shared = APICaller()
    
        private func fetchData(from url: URL, completion: @escaping (Result<[Movie], Error>) -> Void){
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
    
    
        func getTrendingMovies(completion: @escaping(Result<[Movie], Error>) -> Void){
            guard let url = URL(string: "\(constants.baseURL)/3/trending/movie/day?api_key=\(constants.API_Key)") else {return}
            fetchData(from: url, completion: completion)
            }
    
        func getTrendingTV(completion: @escaping (Result<[Movie], Error>) -> Void) {
            guard let url = URL(string: "\(constants.baseURL)/3/trending/tv/day?api_key=\(constants.API_Key)") else { return }
            fetchData(from: url, completion: completion)
        }

        func getPopularMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
            guard let url = URL(string: "\(constants.baseURL)/3/movie/popular?api_key=\(constants.API_Key)") else { return }
            fetchData(from: url, completion: completion)
        }

        func getUpcomingMovies(completion: @escaping (Result<[Movie], Error>) -> Void) {
            guard let url = URL(string: "\(constants.baseURL)/3/movie/upcoming?api_key=\(constants.API_Key)") else { return }
            fetchData(from: url, completion: completion)
        }

        func getTopRated(completion: @escaping (Result<[Movie], Error>) -> Void) {
            guard let url = URL(string: "\(constants.baseURL)/3/movie/top_rated?api_key=\(constants.API_Key)") else { return }
            fetchData(from: url, completion: completion)
        }

        func getSearchResults(with query: String, completion: @escaping (Result<[Movie], Error>) -> Void) {
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            guard let url = URL(string: "\(constants.baseURL)/3/search/movie?query=\(encodedQuery)&api_key=\(constants.API_Key)") else { return }
            fetchData(from: url, completion: completion)
        }

    // getMovie from Youtube api
        func getMovie(with query: String, completion: @escaping (Result<VideoElement, Error>) -> Void) {
            let query = query + "official trailer "
            guard let encodedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed) else { return }
            
            guard let url = URL(string: "\(constants.YT_baseURL)\(encodedQuery)&key=\(constants.YT_API_Key)&type=video") else { return }

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
                    let results = try JSONDecoder().decode(YTResponse.self, from: data)
                    completion(.success(results.items[0]))
                }
                catch{
                    print(error.localizedDescription + "decode mh hua")
                }
            }
            task.resume()
        }
}
