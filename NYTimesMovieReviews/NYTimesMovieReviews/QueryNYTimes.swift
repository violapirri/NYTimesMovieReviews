//
//  QueryNYTimes.swift
//  NYTimesMovies
//
//  Created by Viola Pirri on 9/25/17.
//  Copyright © 2017 Viola Pirri. All rights reserved.
//

import Foundation

class QueryNYTimes {
    typealias JSONDictionary = [String: Any]
    typealias QueryResult = ([Movies]?, String) -> ()
    var movies: [Movies] = []
    var errorMessage = ""
    
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    func getSearchResults(completion: @escaping QueryResult) {
        
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string: "https://api.nytimes.com/svc/movies/v2/reviews/search.json") {
            urlComponents.query = "api-key=68b0070d4910436cb1b211e4305f310d&critics-pick=Y"
            
            guard let url = urlComponents.url else { return }
            
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                defer { self.dataTask = nil }
                if let error = error {
                    self.errorMessage += "Data error: " + error.localizedDescription + "\n"
                } else if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    self.updateSearchResults(data)
                    DispatchQueue.main.async {
                        completion(self.movies, self.errorMessage)
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    fileprivate func updateSearchResults(_ data: Data) {
        var response: JSONDictionary?
        movies.removeAll()
        
        do {
            response = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
        } catch let parseError as NSError {
            errorMessage += "JSONSerialization error: \(parseError.localizedDescription)\n"
            return
        }
        
        guard let array = response!["results"] as? [Any] else {
            errorMessage += "Dictionary does not contain results key\n"
            return
        }
        var index = 0
        
        for movieDictionary in array {
            if let movieDictionary = movieDictionary as? JSONDictionary, let title = movieDictionary["display_title"] as? String, let media = movieDictionary["multimedia"] as? [String: Any], let link = movieDictionary["link"] as? [String: Any] {
                
                if let pic = media["src"] as? String, let reviewLink = link["url"] as? String {
                    movies.append(Movies(title: title, media: pic, reviewLink: reviewLink))
                }
                index += 1
            } else {
                errorMessage += "Problem parsing movieDictionary\n"
            }
        }
    }
    
}
