//
//  MyTodoViewController.swift
//  MyTodo
//
//  Created by Minh Tan Vu on 22/06/2023.
//

import UIKit
import RealmSwift

class MyTodoViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var greetingLb: UILabel!
    
    private var todoDataSource = [Todo]()
    private var selectedIndexPath: IndexPath?
    
    let realm = try! Realm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        
        readAll()
        
    }
    
    func setupView() {
        // Greeting label
        greetingLb.text = UserDefaultsService.shared.owner
        
        //SearchBar
        searchBar.delegate = self
        searchBar.placeholder = "Search Todo"
        
        //TableView
        tableView.dataSource = self
        tableView.delegate = self
        
        //Setup AddButton
        addButton.layer.cornerRadius = addButton.bounds.height/2
        addButton.clipsToBounds = true
        addButton.layer.shadowOffset = CGSize(width: 2, height: 2)
        addButton.layer.shadowColor = UIColor.darkGray.cgColor
        addButton.layer.shadowOpacity = 0.7
        addButton.layer.masksToBounds = false
    }
    
    private func readAll() {
//        let realm = try! Realm()
        let todos = realm.objects(Todo.self)
        self.todoDataSource.removeAll()
        self.todoDataSource.append(contentsOf: todos)
        self.tableView.reloadData()
    }
    
    private func queryTodo(by query: String) {
        
        if query.isEmpty {
            self.readAll()
        } else {
            /**
             Mở realm
             */
//            let realm = try! Realm()
            
            /// Lấy data
            let todos = realm.objects(Todo.self)
            
            // Tìm kiếm theo tên
            let todosQuery = todos.where { todo in
                todo.title.contains(query, options: .caseInsensitive)
            }
            self.todoDataSource.removeAll()
            self.todoDataSource.append(contentsOf: todosQuery)
            self.tableView.reloadData()
        }
    }
    
    private func updateTodo(todo: Todo) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Edit Todo Title", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Edit Todo Title", style: .default) { action in
            do {
                try! self.realm.write {
                    todo.title = (textField.text != "") ? textField.text! : todo.title
                    /// Reload lại tableview
                    
                    self.tableView.reloadRows(at: [self.selectedIndexPath!], with: .automatic)
                    self.selectedIndexPath = nil
                }
            } catch {
                print("Error editing Todo \(error)")
            }
        }
        
        alert.addAction(action)
        alert.addTextField { alertTextField in
            textField = alertTextField
            textField.placeholder = "Enter new title"
        }
        present(alert, animated: true)
    }
    
    private func deleteTodo(todo: Todo, indexPath: IndexPath) {
        /**
         Mở realm
         */
//        let realm = try! Realm()
        
        /// Xóa
        try! realm.write {
            realm.delete(todo)
        }
        self.todoDataSource.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    @IBAction func addBtnTapped(_ sender: UIButton) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New Todo", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Todo Item", style: .default) { action in
            do {
                try self.realm.write {
                    let newTodo = Todo()
                    newTodo.title = textField.text! != "" ? textField.text! : "New Todo"
                    newTodo.dateCreated = .now
                    self.realm.add(newTodo)
                    self.todoDataSource.append(newTodo)
                    self.tableView.insertRows(at: [IndexPath(item: self.todoDataSource.count - 1, section: 0)], with: .automatic)
                }
            } catch {
                print("Error saving Todo \(error)")

            }
            self.tableView.reloadData()
        }
        
        alert.addAction(action)
        alert.addTextField { alertTextField in
            textField = alertTextField
            textField.placeholder = "Add a new Todo"
        }
        present(alert, animated: true)
    }
    
    private func deleteAllOfASpecialType() {
        /**
         Mở realm
         */
//        let realm = try! Realm()
        
        try! realm.write {
            let allTodos = realm.objects(Todo.self)
            realm.delete(allTodos)
        }
    }
}

    // MARK: - Table view data source
extension MyTodoViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoDataSource.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let todo = self.todoDataSource[indexPath.row]
        
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "TodoItemCell")
        
        var config = UIListContentConfiguration.cell()
    
        let attributeString = NSMutableAttributedString(string: todo.title ?? "No title")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSRange(location: 0, length: attributeString.length))
        if let dateCreated = todo.dateCreated {
            
            let dateFormater = DateFormatter()
            dateFormater.dateFormat = "dd/MM/yyyy HH:mm"
            
            let dateString = dateFormater.string(from: dateCreated)
            config.secondaryText = dateString
            config.secondaryTextProperties.color = .lightGray
        }
        
        if todo.isCompleted {
            cell.accessoryType = .checkmark
            config.attributedText = attributeString
        } else {
            cell.accessoryType = .none
            config.text = todo.title ?? "No title"
        }
        
        cell.contentConfiguration = config

        return cell
    }
}

//MARK: - Table view Delegate
extension MyTodoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let todo = self.todoDataSource[indexPath.row]
//        let realm = try! Realm()
        try! realm.write({
            todo.isCompleted = !todo.isCompleted
        })
        tableView.deselectRow(at: indexPath, animated: true)
        tableView.reloadData()
        self.selectedIndexPath = nil
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let todo = self.todoDataSource[indexPath.row]
        let editAction = UIContextualAction(style: .destructive, title: "Edit") { (action, view, handler) in
            self.selectedIndexPath = indexPath
            self.updateTodo(todo: todo)
            handler(true)
        }
        
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (action, view, handler) in
            self.deleteTodo(todo: todo, indexPath: indexPath)
            handler(true)
        }
        deleteAction.backgroundColor = .red
        
        let configuration = UISwipeActionsConfiguration(actions: [editAction, deleteAction])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
}
extension MyTodoViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.queryTodo(by: searchText)
    }
}

