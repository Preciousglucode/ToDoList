//
//  ViewController.swift
//  ToDo
//
//  Created by Precious Omoroga on 2023/02/27.
//
import UIKit
class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
  let tableView: UITableView = {
    let table = UITableView()
    table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    return table
  }()
  //Date picker/calender
  let datePicker: UIDatePicker = {
    let datePicker = UIDatePicker()
    datePicker.locale = .current
    datePicker.datePickerMode = .dateAndTime
    datePicker.preferredDatePickerStyle = .compact
    datePicker.tintColor = .systemBlue
    return datePicker
  }()
  private var models = [ToDoListItem]()
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
    title = "Joewe's To Do List"
    view.addSubview(tableView)
    getAllItems()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.frame = view.bounds
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAdd))
  }
  func showAlert(item: ToDoListItem) {
    let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "Submit", style: .cancel, handler: {
      action in
      self.setDueDate(item: item, dueDate: self.datePicker.date)
    }))
    alert.view.addSubview(datePicker)
    present(alert, animated: true)
  }
  @objc private func didTapAdd() {
    let alert = UIAlertController(title: "New Item", message: "Enter new To Do", preferredStyle: .alert)
    alert.addTextField(configurationHandler: nil)
    alert.addAction(UIAlertAction(title: "Select Due Date", style: .cancel, handler: { _ in guard let field = alert.textFields?.first, let text = field.text, !text.isEmpty else{
      return
    }
      let newItem = self.createItem(name: text)
      self.showAlert(item: newItem)
    }))
    present(alert, animated: true)
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return models.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let model = models[indexPath.row]
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    var dateString = "-"
    if let dueDate = model.dueDate{
      dateString = DateFormatter.dayMonthYearTimeFormatter.string(from: dueDate)
    }
    cell.accessoryType = model.isChecked ? .checkmark : .none
    cell.textLabel?.text = "\(model.name!) \t \t \(dateString)"
    cell.detailTextLabel?.text = "\(dateString)"
    return cell
  }
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let item = models[indexPath.row]
    let sheet = UIAlertController(title: "Edit", message: nil, preferredStyle: .actionSheet)
    sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
    sheet.addAction(UIAlertAction(title: "Edit", style: .default, handler: { _ in
      let alert = UIAlertController(title: "Edit Item", message: "Edit your new item", preferredStyle: .alert)
      alert.addTextField(configurationHandler: nil)
      alert.textFields?.first?.text = item.name
      alert.addAction(UIAlertAction(title: "Save", style: .cancel, handler: { [weak self] _ in
        guard let field = alert.textFields?.first, let newName = field.text, !newName.isEmpty else{
          return
        }
        self?.updateItem(item: item, newName: newName)
      }))
      self.present(alert, animated: true)
    }))
    sheet.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in self?.deleteItem(item: item)
    }))
    item.isChecked = !item.isChecked
    tableView.reloadData()
    present(sheet , animated: true)
  }
  func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
    return true
  }
  func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    models.swapAt(sourceIndexPath.row, destinationIndexPath.row)
  }
  @IBAction func didTapSort() {
    if tableView.isEditing{
      tableView.isEditing = false
    }
    else {
      tableView.isEditing = true
    }
  }
  // Core Data
  func getAllItems() {
    do {
      models = try context.fetch(ToDoListItem.fetchRequest())
      DispatchQueue.main.async {
        self.tableView.reloadData()
      }
    }
    catch{
      //error
    }
  }
  func createItem(name: String) -> ToDoListItem {
    let newItem = ToDoListItem(context: context)
    newItem.name = name
    newItem.createAt = Date()
    do {
      try context.save()
      getAllItems()
    }
    catch{
    }
    return newItem
  }
  func deleteItem(item: ToDoListItem){
    context.delete(item)
    do{
      try context.save()
      getAllItems()
    }
    catch{
    }
  }
  func updateItem(item: ToDoListItem, newName: String){
    item.name = newName
    do{
      try context.save()
      getAllItems()
    }
    catch{
    }
  }
  func setDueDate(item: ToDoListItem, dueDate: Date){
    item.dueDate = dueDate
    do{
      try context.save()
      getAllItems()
    }
    catch{
    }
  }
}
extension DateFormatter{
  static let dayMonthYearTimeFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-YYYY, HH:mm"
    return dateFormatter
  }()
}



