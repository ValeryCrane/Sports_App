//
//  NewsPresenter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

protocol NewsPresentationLogic {
    func presentNews(_ news: [NewsCellModel])
    func presentImage(_ image: UIImage, forId id: UUID)
    func presentEnd()
    func presentError(message: String)
}

class NewsPresenter {
    weak var view: NewsDisplayLogic!
    private var news = [NewsCellModel]()
    private var fetchedAll = false
}

extension NewsPresenter: NewsPresentationLogic {
    
    func presentNews(_ news: [NewsCellModel]) {
        self.news.append(contentsOf: news)
        DispatchQueue.main.async { [weak self] in
            if let news = self?.news {
                self?.view.displayNews(news)
            }
        }
    }

    func presentImage(_ image: UIImage, forId id: UUID) {
        for i in 0 ..< news.count {
            if news[i].id == id {
                news[i].image = image
            }
        }
        DispatchQueue.main.async { [weak self] in
            if let news = self?.news {
                self?.view.displayNews(news)
            }
        }
    }

    func presentEnd() {
        if !fetchedAll {
            fetchedAll = true
            DispatchQueue.main.async { [weak self] in
                self?.view.setLoadingFooterEnabled(false)
            }
        }
    }

    func presentError(message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view.displayErrorAlert(message: message)
        }
    }
    
}

