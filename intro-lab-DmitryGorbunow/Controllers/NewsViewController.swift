//
//  ViewController.swift
//  intro-lab-DmitryGorbunow
//
//  Created by Dmitry Gorbunow on 2/3/23.
//

import UIKit
import CoreData

class NewsViewController: UIViewController {
    
    let cellID = "cellID"
    var page = 1
    
    private lazy var fetchedhResultController: NSFetchedResultsController<NSFetchRequestResult> = {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: News.self))
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "publishedAt", ascending: true)]
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.sharedInstance.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()

    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(NewsTableViewCell.self, forCellReuseIdentifier: cellID)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.refreshControl = refreshControl
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navBarConfig()
        setupView()
        setupConstraints()
        updateTableContent()
    }
    
    @objc private func refresh(sender: UIRefreshControl) {
        updateTableContent()
        sender.endRefreshing()
    }
    
    private func navBarConfig() {
        title = "News"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupView() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    private func updateTableContent() {
        do {
            try self.fetchedhResultController.performFetch()
            print("COUNT FETCHED FIRST: \(String(describing: self.fetchedhResultController.sections?[0].numberOfObjects))")
        } catch let error  {
            print("ERROR: \(error)")
        }
        let service = APIService()
        service.getDataWith(page: page) { (result) in
            switch result {
            case .Success(let data):
                self.clearData()
                self.saveInCoreDataWith(array: data)
            case .Error(let message):
                DispatchQueue.main.async {
                    self.showAlertWith(title: "Error", message: message)
                }
            }
        }
    }
    
    private func showAlertWith(title: String, message: String, style: UIAlertController.Style = .alert) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
    }
    
    private func createNewsEntityFrom(dictionary: [String: AnyObject]) -> NSManagedObject? {
        let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let newsEntity = NSEntityDescription.insertNewObject(forEntityName: "News", into: context) as? News {
            newsEntity.author = dictionary["author"] as? String
            newsEntity.desc = dictionary["description"] as? String
            newsEntity.urlToImage = dictionary["urlToImage"] as? String
            newsEntity.url = dictionary["url"] as? String
            newsEntity.title = dictionary["title"] as? String
            newsEntity.publishedAt = dictionary["publishedAt"] as? String
            let source = dictionary["source"] as? [String: AnyObject]
            newsEntity.sourse = source?["name"] as? String
            return newsEntity
        }
        return nil
    }
    
    private func saveInCoreDataWith(array: [[String: AnyObject]]) {
        _ = array.map{self.createNewsEntityFrom(dictionary: $0)}
        do {
            try CoreDataStack.sharedInstance.persistentContainer.viewContext.save()
        } catch let error {
            print(error)
        }
    }
    
    private func clearData() {
        do {
            let context = CoreDataStack.sharedInstance.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "News")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                CoreDataStack.sharedInstance.saveContext()
            } catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
}

extension NewsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = fetchedhResultController.sections?.first?.numberOfObjects {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as? NewsTableViewCell else {
            return UITableViewCell()
        }
        if let news = fetchedhResultController.object(at: indexPath) as? News {
            cell.setNewsCellWith(news: news)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let vc = DetailsNewsViewController()
        _ = CoreDataStack.sharedInstance.persistentContainer.viewContext
        if let news = fetchedhResultController.object(at: indexPath) as? News {
            vc.setNewsWith(news: news)
            DataManager.shared.setViews(url: news.url ?? "", views: DataManager.shared.getViews(url: news.url ?? "") + 1)
            
            tableView.reloadData()
        }
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        if let lastIndex = fetchedhResultController.sections?.first?.numberOfObjects {
            if indexPath.row == lastIndex - 1 {
                page += 1
                updateTableContent()
            }
        }

    }
}

extension NewsViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.tableView.insertRows(at: [newIndexPath!], with: .automatic)
        case .delete:
            self.tableView.deleteRows(at: [indexPath!], with: .automatic)
        default:
            break
        }
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
}


