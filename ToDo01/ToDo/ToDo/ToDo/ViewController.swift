//
//  ViewController.swift
//  ToDo
//
//  Created by Precious Omoroga on 2023/02/27.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    lazy var tableView : UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell") //creating a tableview and registering a cell
        return table
    }()
    
    private var models = [ToDoListItem]() //array
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "TO DO LIST"
        view.addSubview(tableView) // create the cell as a sub view to put a view
        getAllItems()
        tableView.delegate = self  //assing it a delegate and data sorce
        tableView.dataSource = self
        tableView.frame = view.bounds //assing a frame
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
    }
    @objc private func didTapAdd() {
        let alert = UIAlertController(title: "New Item", message: "Enter A New Item", preferredStyle: .alert)
        alert.addTextField(configurationHandler: nil)
        alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: { [weak self] _ in //for retain cycles
            guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else {
                return
            }
            self?.createItem(name: text)
            
        }))
        
        present(alert, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = model.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        let item = models[indexPath.row]  //del the item selected
        
        
        
        let sheet = UIAlertController(title: "Edit Item", message: "nil", preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        sheet.addAction(UIAlertAction(title: "Edit To Do List", style: .default, handler: { _ in
            
            let alert = UIAlertController(title: "New Item", message: "Edit Your Item", preferredStyle: .alert)
            
            alert.addTextField(configurationHandler: nil)
            alert.textFields?.first?.text = item.name //name will be filled when i tap edit
            alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in //for retain cycles
                guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else {
                    return
                }
                self?.updateItem(item: item, newName: newName) // to update the item
                
            }))
            
            self.present(alert, animated: true)
            
        }))
        sheet.addAction(UIAlertAction(title: "Delete Item", style: .destructive, handler: {[weak self] _ in
            self?.deleteItem(item: item)
        }))
        
        present(sheet, animated: true)
        
    }
    
    //Core Data
    
    
    func getAllItems() {
        do{
            models = try context.fetch(ToDoListItem.fetchRequest())
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        catch {
            //error
        }
        
    }
    
    func createItem(name: String) {
        let newItem = ToDoListItem(context: context)
        newItem.name = name
        newItem.createAt = Date()
        
        do {
            try context.save()
            getAllItems()  //refresh our models and reload my tableview
        }
        catch {
            
        }
    }
    
    func deleteItem(item: ToDoListItem) {
        context.delete(item)
        do {
            try context.save()
            getAllItems() //the refreshed item dets dell in real time
        }
        catch {
            
        }
    }
    
    func updateItem(item: ToDoListItem, newName: String) {
        item.name = newName
        do {
            try context.save()
            getAllItems() //the refreshed items
        }
        catch {
            
        }
    }
    
}



