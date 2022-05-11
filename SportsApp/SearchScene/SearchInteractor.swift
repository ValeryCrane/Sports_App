//
//  SearchInteractor.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 07.05.2022.
//

import Foundation

protocol SearchBusinessLogic {
    func findPeople(query: String)
}

class SearchInteractor {
    var presenter: SearchPresentationLogic!
    
    private func createSearchRequest(query: String) -> URLRequest {
        let urlString = "\(Settings.host)search?query=\(query)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        return request
    }
    
    private func requestSearch(query: String) {
        let request = createSearchRequest(query: query)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data,
               let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let json = jsonObject as? [String: Any],
               let jsonResults = json["results"] as? [[String: Any]] {
                let searchResults = jsonResults.compactMap({ SearchResult(fromJson: $0) })
                self?.presenter.presentSearchResults(searchResults)
            } else {
                self?.presenter.presentError(message: "Check your internet connection!")
            }
        }
        task.resume()
    }
}

extension SearchInteractor: SearchBusinessLogic {
    func findPeople(query: String) {
        requestSearch(query: query)
    }
}


