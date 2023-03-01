//
//  ViewController.swift
//  TestCFT
//
//  Created by Данил on 26.02.2023.
//

import UIKit
import SnapKit
import CoreData

class ViewController: UIViewController {
 
//MARK: - Параметры
    
    private let persistentContainer = NSPersistentContainer(name: "TestCFT")
    let createNoteVC = CreateNoteViewController()
    
    private lazy var fetchedResultController: NSFetchedResultsController<Note> = {
        let fetchRequest = Note.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "text", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        let fetchedResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchedResultController.delegate = self
        return fetchedResultController
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .insetGrouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
//MARK: - viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        loadPersistentStore()
        view.backgroundColor = .systemBackground
        createButtons()
        setupViews()
    }
    
//MARK: - Методы
    
    private func setupViews() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.bottom.equalToSuperview()
        }
    }
    
    private func loadPersistentStore() {
        persistentContainer.loadPersistentStores { persistentStoreDescription, error in
            if let error = error {
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultController.performFetch()
                } catch {
                    print(error)
                }
            }
        }
    }

}

//MARK: - extension TableView

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections  = fetchedResultController.sections {
            return sections[section].numberOfObjects
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = fetchedResultController.object(at: indexPath)
        let cell = UITableViewCell()
        cell.textLabel?.text = note.text
        cell.accessoryType = .disclosureIndicator
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let note = fetchedResultController.object(at: indexPath)
            persistentContainer.viewContext.delete(note)
            try? persistentContainer.viewContext.save()
        }
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let createNoteVC = CreateNoteViewController()
        createNoteVC.note = fetchedResultController.object(at: indexPath)
        navigationController?.pushViewController(createNoteVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
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
        let backButton = UIBarButtonItem(title: "Notes", style: .plain, target: self, action: #selector(backPressed))
        backButton.tintColor = .systemYellow
        navigationItem.backBarButtonItem = backButton
    }
    
    @objc func newNoteButtonPressed() {
        createNoteVC.note = Note.init(entity: NSEntityDescription.entity(forEntityName: "Note", in: persistentContainer.viewContext)!, insertInto: persistentContainer.viewContext)
        self.navigationController?.pushViewController(createNoteVC, animated: true)
    }
    
    @objc func backPressed() {}
}

//MARK: - NSFetchedResultsControllerDelegate

extension ViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let  indexPath = newIndexPath {
                tableView.insertRows(at: [indexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .move:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let note = fetchedResultController.object(at: indexPath)
                let cell = tableView.cellForRow(at: indexPath)
                if let text = note.text {
                    cell?.textLabel?.text = text
                }
            }
        @unknown default:
            break
        }
    }
}
