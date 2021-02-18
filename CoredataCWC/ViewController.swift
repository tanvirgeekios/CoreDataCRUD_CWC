//
//  ViewController.swift
//  CoredataCWC
//
//  Created by MD Tanvir Alam on 17/2/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var plusBarButton: UIBarButtonItem!
    @IBOutlet weak var personTable: UITableView!
    var managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var persons = [Person]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Persons"
        personTable.delegate = self
        personTable.dataSource = self
        fetchData()
    }

    private func fetchData(){
        do{
            self.persons = try managedObjectContext.fetch(Person.fetchRequest())
        }catch{
            showErrorAlert(with: "Error Fetching Data")
        }
        DispatchQueue.main.async {
            self.personTable.reloadData()
        }
    }
    
    private func showErrorAlert(with message:String){
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: nil))
        present(alert, animated: true)
    }
    
    
    @IBAction func plusBarButtonClicked(_ sender: Any) {
        let alert = UIAlertController(title: "Create a Person", message: "Write person name, age, nationality", preferredStyle: .alert)
        
        alert.addTextField { (name) in
            name.placeholder = "Enter name"
        }
        alert.addTextField { (age) in
            age.placeholder = "Enter Age"
        }
        alert.addTextField { (nationality) in
            nationality.placeholder = "Enter nationality"
        }
        
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_ action: UIAlertAction) -> Void   in
            let name = alert.textFields?[0].text!
            let age = alert.textFields?[1].text!
            let nationality = alert.textFields?[2].text!
            if let name = name, let age = age, let nationality = nationality{
                if !name.isEmpty && !age.isEmpty && !nationality.isEmpty {
                    if age.isInt{
                        print("Data: \(name) \(age) \(nationality)")
                        // Send data to core data
                        let newPerson = Person(context: self.managedObjectContext)
                        newPerson.name = name
                        newPerson.age = Int16(age)!
                        newPerson.nationality = nationality
                        
                        do{
                            try self.managedObjectContext.save()
                            self.fetchData()
                            
                        }
                        catch{
                            let alert3 = UIAlertController(title: "Error", message: "Error saving data in coredata", preferredStyle: .alert)
                            alert3.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
                                self.dismiss(animated: true, completion: nil)
                                self.present(alert, animated: true, completion: nil)
                            }))
                            self.present(alert3, animated: true, completion: nil)
                        }
                    }else{
                        let alert2 = UIAlertController(title: "Error", message: "Age must be a wholenumber", preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                            self.present(alert, animated: true, completion: nil)
                        }))
                        self.present(alert2, animated: true, completion: nil)
                    }
                    
                    
                }else{
                    print("data missing")
                    self.dismiss(animated: true, completion: nil)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
            }else{
                print("data missing")
                self.dismiss(animated: true, completion: nil)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //SwipeAction Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            let personToRemove = self.persons[indexPath.row]
            self.managedObjectContext.delete(personToRemove)
            do{
                try self.managedObjectContext.save()
            }catch{
                self.showErrorAlert(with: "Error Deleting Data")
            }
            self.fetchData()
        }
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let editablePerson = self.persons[indexPath.row]
        let alert = UIAlertController(title: "Edit a Person", message: "Write person name, age, nationality", preferredStyle: .alert)
        
        alert.addTextField { (name) in
            name.placeholder = "Enter name"
            name.text = editablePerson.name
        }
        alert.addTextField { (age) in
            age.placeholder = "Enter Age"
            age.text = String(editablePerson.age)
        }
        alert.addTextField { (nationality) in
            nationality.placeholder = "Enter nationality"
            nationality.text = editablePerson.nationality
        }
        
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { (_ action: UIAlertAction) -> Void   in
            let name = alert.textFields?[0].text!
            let age = alert.textFields?[1].text!
            let nationality = alert.textFields?[2].text!
            if let name = name, let age = age, let nationality = nationality{
                if !name.isEmpty && !age.isEmpty && !nationality.isEmpty {
                    if age.isInt{
                        print("Data: \(name) \(age) \(nationality)")
                        // update data to core data
                        editablePerson.name = name
                        editablePerson.age = Int16(age)!
                        editablePerson.nationality = nationality
                        
                        do{
                            try self.managedObjectContext.save()
                            self.fetchData()
                            
                        }
                        catch{
                            let alert3 = UIAlertController(title: "Error", message: "Error saving data in coredata", preferredStyle: .alert)
                            alert3.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
                                self.dismiss(animated: true, completion: nil)
                                self.present(alert, animated: true, completion: nil)
                            }))
                            self.present(alert3, animated: true, completion: nil)
                        }
                    }else{
                        let alert2 = UIAlertController(title: "Error", message: "Age must be a wholenumber", preferredStyle: .alert)
                        alert2.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { (action) in
                            self.dismiss(animated: true, completion: nil)
                            self.present(alert, animated: true, completion: nil)
                        }))
                        self.present(alert2, animated: true, completion: nil)
                    }
                    
                    
                }else{
                    print("data missing")
                    self.dismiss(animated: true, completion: nil)
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
            }else{
                print("data missing")
                self.dismiss(animated: true, completion: nil)
                self.present(alert, animated: true, completion: nil)
                return
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = personTable.dequeueReusableCell(withIdentifier:"PCell", for: indexPath)
        cell.textLabel?.text = persons[indexPath.row].name
        return cell
    }
    
    
    
}

extension String {
    var isInt: Bool {
        return Int(self) != nil
    }
}

