//
//  FinishRecordInteractor.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation

protocol FinishRecordBusinessLogic {
    func saveRide(name: String, description: String)
}

class FinishRecordInteractor {
    var presenter: FinishRecordPresentationLogic!
    private let sportWorker: SportWorkerLogic
    
    init(worker: SportWorkerLogic) {
        sportWorker = worker
    }
    
    private func createAddRideRequest(
        token: String, name: String, description: String,
        sport: String, statistics: [String: Any], route: [Any]) -> URLRequest {
        let url = URL(string: "\(Settings.host)addRide")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "token")
        request.httpMethod = "POST"
        let requestBody: [String: Any] = [
            "name": name,
            "description": description,
            "sport": sport,
            "statistics": statistics,
            "route": route
        ]
        let requestData = try? JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = requestData
        return request
    }
    
    private func saveToken(token: String) {
        UserDefaults.standard.set(token, forKey: "token")
    }
}

extension FinishRecordInteractor: FinishRecordBusinessLogic {
    func saveRide(name: String, description: String) {
        guard let token = UserDefaults.standard.string(forKey: "token") else {
            presenter.presentError(message: "You aren't authorized!")
            return
        }
        let request = createAddRideRequest(
            token: token,
            name: name,
            description: description,
            sport: sportWorker.getSportKind().getName().lowercased(),
            statistics: sportWorker.getJsonParameters(),
            route: sportWorker.getJsonRoute()
        )
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let _ = data {
                self?.sportWorker.stop()
                self?.sportWorker.clear()
                self?.presenter.restartRecord()
            } else {
                self?.presenter.presentError(message: "Check your internet connection!")
            }
        }
        task.resume()
    }
}
