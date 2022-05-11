//
//  WebViewController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 10.05.2022.
//

import Foundation
import UIKit
import WebKit

// WebView opening url, passed to it.
class WebViewController: UIViewController {
    public var articleUrl: URL?
     
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let webView = WKWebView()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            webView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            webView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            webView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        // Loading page.
        if let articleUrl = self.articleUrl {
            webView.load(URLRequest(url: articleUrl))
        }
    }
}
