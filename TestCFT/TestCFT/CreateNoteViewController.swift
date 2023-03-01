//
//  CreateNoteViewController.swift
//  TestCFT
//
//  Created by Данил on 27.02.2023.
//

import Foundation
import UIKit
import SnapKit

class CreateNoteViewController: UIViewController {
  
//MARK: - Параметры
    
    var note: Note?
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 22)
        textView.clipsToBounds = true
        return textView
    }()

//MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        setupViews()
        createSaveButton()
        
        if let note = note {
            textView.text = note.text
        }
    }
    
//MARK: - Методы
    
    private func setupViews() {
        view.addSubview(textView)
        textView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-50)
            make.bottom.equalToSuperview()
            make.right.equalToSuperview()
            make.left.equalToSuperview().offset(5)
        }
    }
    
    private func createSaveButton() {
        let saveButton = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(savePressed))
        saveButton.tintColor = .systemYellow
        let fontButton = UIBarButtonItem(title: "Font", style: .plain, target: self, action: #selector(fontButtonPressed))
        fontButton.tintColor = .systemYellow
        navigationItem.rightBarButtonItems = [saveButton, fontButton]
        
    }
    
    @objc func savePressed() {
        note?.text = textView.text
        try? note?.managedObjectContext?.save()
        textView.text = ""
        navigationController?.popViewController(animated: true)
    }
    
    @objc func fontButtonPressed() {
        let config = UIFontPickerViewController.Configuration()
        config.includeFaces = false
        let fontPicker = UIFontPickerViewController(configuration: config)
        fontPicker.delegate = self
        present(fontPicker, animated: true)
    }
}

//MARK: - extension UIFontPickerViewControllerDelegate

extension CreateNoteViewController: UIFontPickerViewControllerDelegate {
    
    func fontPickerViewControllerDidCancel(_ viewController: UIFontPickerViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }
    
    func fontPickerViewControllerDidPickFont(_ viewController: UIFontPickerViewController) {
        let descriptor = viewController.selectedFontDescriptor
        if let descriptor = descriptor {
            textView.font = UIFont(descriptor: descriptor, size: 22)
        }
        viewController.dismiss(animated: true, completion: nil)
    }
}
