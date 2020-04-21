//
//  ViewController.swift
//  Books
//
//  Created by Alaa Maher on 4/21/20.
//  Copyright © 2020 Alaa Maher. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    let appColorKey = "AppColor"
    var books: [Book] = []
    let fileURL = URL(fileURLWithPath: "books", relativeTo: FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setAppColor()
        loadBooks()
        title = "Books List"
        tableView.register(UINib(nibName: "BookTableViewCell", bundle: nil), forCellReuseIdentifier: "BookTableViewCell")
        
        
    }
    
    func setAppColor() {
        if let color = UserDefaults.standard.string(forKey: appColorKey) {
            self.navigationController?.navigationBar.barTintColor = UIColor(named: color)
        } else {
            showAppColorAlert()
        }
    }
    
    func showAppColorAlert() {
        let alert = UIAlertController(title: "App Style",
                                      message: "Please select your app style",
                                      preferredStyle: .actionSheet)
        
        let purpleAction = UIAlertAction(title: "Purple", style: .default) { [unowned self] action in
            self.navigationController?.navigationBar.barTintColor = UIColor(named: "AppPurple")
            UserDefaults.standard.set("AppPurple", forKey: self.appColorKey)
        }
        
        let yellowAction = UIAlertAction(title: "Yellow",
                                         style: .default) { [unowned self] action in
                                            self.navigationController?.navigationBar.barTintColor = UIColor(named: "AppYellow")
                                            UserDefaults.standard.set("AppYellow", forKey: self.appColorKey)
        }
        alert.addAction(purpleAction)
        alert.addAction(yellowAction)
        
        present(alert, animated: true)
    }
    
    @IBAction func addName(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "New Book",
                                      message: nil,
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save", style: .default) {
            [unowned self] action in
            
            guard let titleTextField = alert.textFields?.first,
                let authorTextField = alert.textFields?[1],
                let title = titleTextField.text, let author = authorTextField.text else {
                    return
            }
            let book = Book(title: title, author: author)
            self.books.append(book)
            self.save()
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .cancel)
        
        alert.addTextField(
            configurationHandler: { (textField: UITextField) in
                textField.placeholder = "Title"
        })
        
        alert.addTextField(
            configurationHandler: { (textField: UITextField) in
                textField.placeholder = "Author"
        })
        
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func save() {
        
        do {
            // let encodedBooks = try JSONEncoder().encode(books)
            let encodedBooks = try PropertyListEncoder().encode(books)
            
            try encodedBooks.write(to: fileURL)
            //print("File saved: \(fileURL.absoluteURL)")
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
    func loadBooks() {
        do {
            let encodedBooks = try Data(contentsOf: fileURL)
            self.books = try PropertyListDecoder().decode(Array<Book>.self, from: encodedBooks)
            
        } catch {
            print("Unable to read the file")
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath)
        -> UITableViewCell {
            
            let book = books[indexPath.row]
            let cell =
                tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell",
                                              for: indexPath) as! BookTableViewCell
            
            cell.setTitle(title: book.title)
            cell.setAuthor(author: book.author)
            return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        self.books.remove(at: indexPath.row)
        self.save()
        self.tableView.reloadData()
    }
}
