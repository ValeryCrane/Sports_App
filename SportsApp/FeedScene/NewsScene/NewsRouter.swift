//
//  NewsRouter.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 08.05.2022.
//

import Foundation
import UIKit

protocol NewsRoutingLogic: AnyObject {
    func routeToWebView(url: URL)               // Routes to webview with given URL.
}

class NewsRouter {
    weak var view: UIViewController!
}

extension NewsRouter: NewsRoutingLogic {
    func routeToWebView(url: URL) {
        let webViewController = WebViewController()
        webViewController.articleUrl = url
        webViewController.title = "Article"
        webViewController.view.backgroundColor = Colors.gray2
        view.navigationController?.pushViewController(webViewController, animated: true)
    }
    
}
