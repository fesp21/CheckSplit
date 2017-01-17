//
//  ViewController.swift
//  CheckSplit
//
//  Created by Henry Dinhofer on 12/22/16.
//  Copyright © 2016 Henry Dinhofer. All rights reserved.
//

import UIKit
import Crashlytics

// instead of reloadTable() look into func insertRows(at indexPaths: [IndexPath], with animation: UITableViewRowAnimation)


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBOutlet weak var foodPeopleToggle: UISegmentedControl!
    @IBOutlet weak var itemTableView: UITableView!
    @IBOutlet weak var itemTextView: UITextView!
    @IBOutlet weak var priceTextView: UITextView!
    
    let store = MealDataStore.sharedInstance
    
    var lastSelectedIndexPath : IndexPath?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        itemTableView.delegate = self
        itemTableView.dataSource = self
        itemTableView.allowsSelection = true
        priceTextView.accessibilityIdentifier = "Price"
        itemTextView.accessibilityIdentifier = "Item"
        priceTextView.delegate = self
        itemTextView.delegate = self
        
        print("Toggle is currently \(foodPeopleToggle.selectedSegmentIndex)")
        
        //Crashlytics force crash button
        let button = UIButton(type: .roundedRect)
        button.frame = CGRect(x: 20, y: 50, width: 100, height: 30)
        button.setTitle("Crash", for: .normal)
        button.addTarget(self, action: #selector(self.crashButtonTapped(sender:)), for: .touchUpInside)
        view.addSubview(button)

        // Do any additional setup after loading the view, typically from a nib.
    }
    
    @IBAction func crashButtonTapped(sender: AnyObject) {
        Crashlytics.sharedInstance().crash()
    }

    override func viewWillAppear(_ animated: Bool) {
        if let indexPath = itemTableView.indexPathForSelectedRow {
            itemTableView.deselectRow(at: indexPath, animated: false)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: IBActions
    @IBAction func toggleTapped(_ sender: Any) {
        let toggleTitle = foodPeopleToggle.titleForSegment(at: foodPeopleToggle.selectedSegmentIndex) ?? ""
        
        priceTextView.isHidden = toggleTitle == "People" ? true : false
        itemTextView.text = "Enter food name"
        priceTextView.text = "Price"
        itemTableView.reloadData()
    }

    @IBAction func resetTapped(_ sender: Any) {
        store.clear()
        itemTableView.reloadData()
    }
    @IBAction func editTapped(_ sender: Any) {
        
        if itemTableView.isEditing { itemTableView.setEditing(false, animated: true)  }
        else { itemTableView.setEditing(true, animated: true) }
        
    }
    @IBAction func addItemTapped(_ sender: Any) {
        let name = itemTextView.text ?? ""
        let priceText = priceTextView.text ?? ""
        let toggleTitle = foodPeopleToggle.titleForSegment(at: foodPeopleToggle.selectedSegmentIndex) ?? ""
        var badInfoEntered : Bool = false
        var price : Double = 0
        
        if name == "" || name == "Enter food name" { badInfoEntered = true }
        if toggleTitle != "People"
        {
            if priceText == "" || priceText == "Price" { badInfoEntered = true }
            if Double(priceText) == nil {
                badInfoEntered = true
            } else {
                price = Double(priceText)!
            }

        }
        
        
        guard badInfoEntered == false
            else {
                let controller = UIAlertController(title: "Error", message: "Incorrect information entered", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(controller, animated: true, completion: nil)
                return
        }
        
        switch toggleTitle {
        case "Food":   store.add(item: Food(name: name, cost: price))
        case "Drinks": store.add(item: Drink(name: name, cost: price))
        case "People": store.add(item: Person(name: name))
        default: fatalError("Couldn't add item to store")
        }
        
        // reset views
        itemTextView.text = ""
        priceTextView.text = "Price"
        self.tabBarController?.tabBar.items?.first?.badgeValue = "\(store.patrons.count)"
        itemTableView.reloadData()
        itemTextView.becomeFirstResponder()
        
}
    
    
    // MARK: - Tableview data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        var numberOfRows : Int = 0
        let toggleTitle = foodPeopleToggle.titleForSegment(at: foodPeopleToggle.selectedSegmentIndex) ?? "Error"
        
        switch toggleTitle {
            case "Food": numberOfRows = store.food.count
            case "People": numberOfRows = store.patrons.count
            case "Drinks": numberOfRows = store.drinks.count
        default:
            fatalError("Number of Rows couldn't be deciphered!")
        }
        
        return numberOfRows
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = itemTableView.dequeueReusableCell(withIdentifier: "itemCell"),
            let toggleTitle = foodPeopleToggle.titleForSegment(at: foodPeopleToggle.selectedSegmentIndex)
        else { return UITableViewCell() }


        let row = indexPath.row
        let label : String
        
        
        
        switch toggleTitle {
            case "Food": label = store.food[row].description
            case "People": label = "\(store.patrons[row].name)  $\(store.patrons[row].totalTally)"
            case "Drinks": label = store.drinks[row].description
        default:
            fatalError("Number of Rows couldn't be deciphered!")
        }
        
        cell.textLabel?.text = label
        
        return cell
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return foodPeopleToggle.titleForSegment(at: foodPeopleToggle.selectedSegmentIndex)
    }
    // MARK: - Tableview delegate
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let toggleTitle = foodPeopleToggle.titleForSegment(at: foodPeopleToggle.selectedSegmentIndex),
              let cell = itemTableView.cellForRow(at: indexPath),
              let text = cell.textLabel?.text,
              lastSelectedIndexPath?.row != indexPath.row
        else {
                itemTableView.deselectRow(at: indexPath, animated: true)
                lastSelectedIndexPath = nil
                return
        }
        
        lastSelectedIndexPath = indexPath
        
//        if lastSelectedIndexPath?.row == indexPath.row {
//            itemTableView.deselectRow(at: indexPath, animated: true)
//            lastSelectedIndexPath = nil
//        }
//        else { lastSelectedIndexPath = indexPath }
        
        
        var itemComponents : [String]
    
        if toggleTitle == "People" {
            itemComponents = text.components(separatedBy: " $")
        } else {
            itemComponents = text.components(separatedBy: " - ")
        }
        
        itemTextView.text = itemComponents[0]
        priceTextView.text = itemComponents[1]

    
        /*
        let controller = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
        let save = UIAlertAction(title: "Save", style: .default) { (action) in
            // hit save
            let nameTextField = controller.textFields![0] as UITextField
            let priceTextField = controller.textFields![1] as UITextField
            
            let newName = nameTextField.text ?? "Error"
            let newPriceText = priceTextField.text ?? "0.0"
            let newPrice = Double(newPriceText) ?? 0.0
            
            if toggleTitle == "People" {
                let person = self.store.patrons[indexPath.row]
                person.name = newName
                self.store.patrons[indexPath.row] = person
            }
            else {
                let food = self.store.food[indexPath.row]
                food.name = newName
                food.cost = newPrice
                self.store.food[indexPath.row] = food
            }
            self.itemTableView.reloadData()
    
        }
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        
        controller.addTextField { (textField : UITextField) in
            textField.placeholder = "Enter food name"
        }
        
        controller.addTextField { (textField : UITextField) in
            textField.placeholder = "Price"
        }
        
        controller.addAction(save)
        controller.addAction(cancel)
        self.present(controller, animated: true, completion: nil)
        */

    }
    
    // MARK: - Textview delegate
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard let identifier = textView.accessibilityIdentifier
        else { return }
        
        if identifier == "Item" {
            if itemTextView.text == "Enter food name" { itemTextView.text = "" }
            if priceTextView.text == "" { priceTextView.text = "Price" }
        }
        else if identifier == "Price" {
            if priceTextView.text == "Price" { priceTextView.text = "" }
            if itemTextView.text == "" { itemTextView.text = "Enter food name" }
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        guard let toggle = foodPeopleToggle.titleForSegment(at: foodPeopleToggle.selectedSegmentIndex)
        else { return false }
        
        if text == "\n", let indexPath = itemTableView.indexPathForSelectedRow {
            let name = itemTextView.text ?? "Error"
            let price = Double(priceTextView.text) ?? 0
            
            if toggle == "People" {
                let person = self.store.patrons[indexPath.row]
                person.name = name
                self.store.patrons[indexPath.row] = person
            }
            else {
                let food = self.store.food[indexPath.row]
                food.name = name
                food.cost = price
                self.store.food[indexPath.row] = food
            }
            self.view.endEditing(true)
            itemTableView.reloadRows(at: [indexPath], with: .automatic)
            return false
        }
        
        if text == "\n" {
            if itemTextView.text == "" { itemTextView.text = "Enter food name" }
            self.view.endEditing(true)
            return false
        }
        return true
    }
    
}

