//
//  MainCoordinator.swift
//  CodeAcronymChallenge
//
//  Created by admin on 22/03/2022.
//

import UIKit

protocol Coodinator {
    var navigationController: UINavigationController { get set }
    func start()
}

class MainCoordinator: Coodinator {
    
    var navigationController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navigationController = navController
    }
    
    func start() {
        let networkmanager = NetworkManager()
        let viewModel = AcronymViewModel(network: networkmanager)
        let vc = AcronymSearchViewController(viewModel: viewModel)
        self.navigationController.pushViewController(vc, animated: false)
    }
    
    
    
}
