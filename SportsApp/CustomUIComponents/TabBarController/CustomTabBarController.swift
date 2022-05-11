//
//  CustomTabBarController.swift
//  SportsApp
//
//  Created by Валерий Журавлев on 17.04.2022.
//

import Foundation
import UIKit

// TabBarController with custom appearance.
class CustomTabBarController: UIViewController {
    let customTabBar = CustomTabBar()
    
    var selectedIndex: Int = 0 {
        didSet {
            showViewController(withIndex: selectedIndex)
        }
    }
    
    
    var viewControllers: [UIViewController]? {
        didSet {
            configureCustomTabBar()
            layoutViewControllers()
            selectedIndex = 0
        }
    }
    
    // MARK: - ViewController's life cycle.
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    // MARK: - Configuration fucntions.
    // Configures TabBar.
    private func configureCustomTabBar() {
        customTabBar.layer.shadowColor = UIColor.black.cgColor
        customTabBar.layer.shadowOffset = .zero
        customTabBar.layer.shadowRadius = 8
        customTabBar.layer.shadowOpacity = 0.1
        
        customTabBar.delegate = self
        customTabBar.configure(with: viewControllers, selectedIndex: selectedIndex)
        view.addSubview(customTabBar)
        customTabBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            customTabBar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            customTabBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            customTabBar.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func showViewController(withIndex index: Int) {
        guard let viewControllers = viewControllers else { return }
        for i in 0 ..< viewControllers.count {
            viewControllers[i].view.isHidden = (i != index)
        }
    }
    
    private func layoutViewControllers() {
        guard let viewControllers = viewControllers else { return }
        for viewController in viewControllers {
            addChild(viewController)
            view.addSubview(viewController.view)
            viewController.didMove(toParent: self)
            viewController.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                viewController.view.topAnchor.constraint(equalTo: view.topAnchor),
                viewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                viewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                viewController.view.bottomAnchor.constraint(equalTo: customTabBar.topAnchor)
            ])
            viewController.view.isHidden = true
        }
        view.bringSubviewToFront(customTabBar)
    }
    
    
}

// MARK: - CustomTabBarDelegate implementation.
extension CustomTabBarController: CustomTabBarDelegate {
    func selected(index: Int) {
        selectedIndex = index
    }
}
