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
    
    var note: Note?
    
    lazy var textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .systemFont(ofSize: 22)
        return textView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        textView.delegate = self
        view.backgroundColor = .systemBackground
        setupViews()
        createSaveButton()
    }
    
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
        navigationItem.rightBarButtonItem = saveButton
    }
    
    @objc func savePressed() {
        note?.text = textView.text
        try? note?.managedObjectContext?.save()
        textView.text = ""
        navigationController?.popViewController(animated: true)
    }
}

extension CreateNoteViewController: UITextViewDelegate {
}
