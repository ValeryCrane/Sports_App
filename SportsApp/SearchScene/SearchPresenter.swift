//
//  SearchPresenter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 07.05.2022.
//

import Foundation

protocol SearchPresentationLogic {
    func presentSearchResults(_ searchResults: [SearchResult])
    func presentError(message: String)
}

class SearchPresenter {
    weak var view: SearchDisplayLogic!
}

extension SearchPresenter: SearchPresentationLogic {
    func presentSearchResults(_ searchResults: [SearchResult]) {
        DispatchQueue.main.async { [weak view] in
            view?.displaySearchResults(searchResults)
        }
    }
    
    func presentError(message: String) {
        DispatchQueue.main.async { [weak view] in
            view?.displayErrorAlert(message: message)
        }
    }
    
    
}
