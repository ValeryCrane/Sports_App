//
//  NewsInteractor.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

protocol NewsBusinessLogic {
    func fetchNews(lastArticleIndex: Int)
}

class NewsInteractor {
    var presenter: NewsPresentationLogic!
    private static let host = "https://newsapi.org/v2/everything"
    private static let query = "cycling"
    private static let apiKey = "494c2b4add8e4846a98d090605ac4df5"
    private static let pageSize = 20
    private static let totalResults = 100
    
    private func createNewsRequest(lastArticleIndex: Int) -> URLRequest? {
        guard lastArticleIndex + Self.pageSize <= Self.totalResults else { return nil }
        let urlString = "\(Self.host)?q=\(Self.query)&apiKey=\(Self.apiKey)&pageSize=\(Self.pageSize)" +
            "&page=\(lastArticleIndex / Self.pageSize + 1)"
        let url = URL(string: urlString)!
        var request = URLRequest(url: url)
        request.setValue(UserDefaults.standard.string(forKey: "token") ?? "", forHTTPHeaderField: "token")
        request.httpMethod = "GET"
        return request
    }
    
    private func requestImage(imageUrl url: URL, forId id: UUID) {
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            if let data = data,
               let image = UIImage(data: data) {
                self?.presenter.presentImage(image, forId: id)
            }
        }
        task.resume()
    }
    
    private func requestNews(lastArticleIndex: Int) {
        guard let request = createNewsRequest(lastArticleIndex: lastArticleIndex) else {
            presenter.presentEnd()
            return
        }
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data,
               let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let json = jsonObject as? [String: Any],
               let jsonNews = json["articles"] as? [[String: Any]] {
                let news: [NewsCellModel] = jsonNews.compactMap({ jsonArticle in
                    if let title = jsonArticle["title"] as? String,
                       let urlString = jsonArticle["url"] as? String,
                       let url = URL(string: urlString),
                       let imageUrlString = jsonArticle["urlToImage"] as? String,
                       let imageUrl = URL(string: imageUrlString) {
                        return NewsCellModel(title: title, url: url, imageUrl: imageUrl, image: nil)
                    } else {
                        return nil
                    }
                })
                self?.presenter.presentNews(news)
                for article in news {
                    self?.requestImage(imageUrl: article.imageUrl, forId: article.id)
                }
            } else {
                self?.presenter.presentError(message: "Check your internet connection!")
            }
        }
        task.resume()
    }
}

extension NewsInteractor: NewsBusinessLogic {
    func fetchNews(lastArticleIndex: Int) {
        requestNews(lastArticleIndex: lastArticleIndex)
    }
}
