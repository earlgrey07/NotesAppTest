//
//  ViewController.swift
//  TestCFT
//
//  Created by Данил on 26.02.2023.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        createButtons()
    }


}

//MARK: - createNavigationController

extension ViewController {
    
    func createNavigationController() -> UINavigationController {
        let viewController = ViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        viewController.navigationItem.title = "Notes"
        viewController.navigationController?.navigationBar.prefersLargeTitles = true
        return navigationController
    }
    
    func createButtons() {
        let newNoteButton = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(newNoteButtonPressed))
        navigationItem.rightBarButtonItem = newNoteButton
        newNoteButton.tintColor = .systemYellow
    }
    
    @objc func newNoteButtonPressed() {
        
    }
}
