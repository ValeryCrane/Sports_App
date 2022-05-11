//
//  SignInInteractor.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation

protocol SignInBusinessLogic {
    func signIn(email: String, password: String)
}

class SignInInteractor {
    var presenter: SignInPresentationLogic!
    
    private func createSignInRequest(email: String, password: String) -> URLRequest {
        let url = URL(string: "\(Settings.host)signIn")!
        var request = URLRequest(url: url)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let requestBody: [String: Any] = [
            "email": email,
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

extension SignInInteractor: SignInBusinessLogic {
    func signIn(email: String, password: String) {
        let request = createSignInRequest(email: email, password: password)
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
