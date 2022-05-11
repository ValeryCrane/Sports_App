//
//  RegistrationInteractor.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation

protocol RegistrationBusinessLogic {
    func register(name: String, email: String, password: String, height: Double, weight: Double)
}

class RegistrationInteractor {
    var presenter: RegistrationPresentationLogic!
    
    private func createRegistrationRequest(
        name: String, email: String, password: String, height: Double, weight: Double) -> URLRequest {
        let url = URL(string: "\(Settings.host)signUp")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let requestBody: [String: Any] = [
            "name": name,
            "email": email,
            "height": height,
            "weight": weight,
            "password": password
        ]
        let requestData = try? JSONSerialization.data(withJSONObject: requestBody)
        request.httpBody = requestData
        return request
    }
    
    private func saveToken(token: String) {
        UserDefaults.standard.set(token, forKey: "token")
    }
}

extension RegistrationInteractor: RegistrationBusinessLogic {
    func register(name: String, email: String, password: String, height: Double, weight: Double) {
        let request = createRegistrationRequest(
            name: name, email: email, password: password, height: height, weight: weight)
        let task = URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            if let data = data,
               let jsonObject = try? JSONSerialization.jsonObject(with: data),
               let json = jsonObject as? [String: Any],
               let token = json["token"] as? String {
                self?.saveToken(token: token)
                self?.presenter.presentSigned()
            } else {
                self?.presenter.presentError(message: "Check your internet connection!")
            }
        }
        task.resume()
    }
}


