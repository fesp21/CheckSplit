//
//  BillListViewController.swift
//  CheckSplit
//
//  Created by Henry Dinhofer on 1/1/17.
//  Copyright © 2017 Henry Dinhofer. All rights reserved.
//

import UIKit
import MEVHorizontalContacts

//Make a dinner session  methods
//Get list to display
//Get list to display each item's people that are splitWith

class BillListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MEVHorizontalContactsDelegate {

    @IBOutlet weak var billTableView: UITableView!

    let store = MealDataStore.sharedInstance
    var selected = [Drink]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billTableView.delegate = self
        billTableView.dataSource = self
        billTableView.allowsMultipleSelectionDuringEditing = true
        billTableView.setEditing(true, animated: true)
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        makeBubbles()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - IBActions
    @IBAction func coverTapped(_ sender: Any) {
    }
    
    //MARK: - MEVHorizontalContactsDelegate Methods
    func contactSelected(at index: Int) {
        print("Contact selected at index \(index)")
    }
    func item(_ item: Int, selectedAtContactIndex index: Int) {
        print("selectedAtContactIndex - index : \(index) option : \(item) ")
    }
    
    // MARK: - TableView Delegate
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 { return "DRINKS" }
        else { return "ENTREES" }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 20.0
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0  { return store.drinks.count }
        else  { return store.food.count   } //section == 1
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.white
        return footer
    }
   
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") ?? UITableViewCell()
        let section = indexPath.section
    
        if section == 0 {
            let drink = store.drinks[indexPath.row]
            let splitWithCount = drink.splitWith.count
            cell.textLabel?.text = "\(drink.name) - \(drink.cost)"
            cell.detailTextLabel?.text = splitWithCount > 1 ? "(\(drink.splitWith.count))ppl" : ""
            
            
        }
        else if section == 1 {
            let food = store.food[indexPath.row]
            
            cell.textLabel?.text = "\(food.name)"
            cell.detailTextLabel?.text = ""
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        // update singleton
        if section == 0 {
            let drink = store.drinks[indexPath.row]
            store.add(item: drink, toPerson: Person(name: "David Z"))
            selected.append(drink)
        }
        print("Now selected:\n")
        for drink in selected {
            print(drink.description)
        }
        // reselect
        //    check mark
        guard let selectedIndexPaths = billTableView.indexPathsForSelectedRows
            else { return }
        billTableView.reloadRows(at: [indexPath], with: .automatic)
        for indexPath in selectedIndexPaths {
            billTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
        }
        
        //    highlight background
//        let selectedCell = billTableView.cellForRow(at: indexPath)
//        selectedCell?.contentView.backgroundColor = UIColor.red
        //selectedCell?.accessoryView?.backgroundColor = UIColor.red
        //selectedCell?.multipleSelectionBackgroundView?.backgroundColor = UIColor.red
//        selectedCell?.textLabel?.textColor = UIColor.white
//        selectedCell?.detailTextLabel?.textColor = UIColor.white
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let section = indexPath.section
        
        //update singleton
        if section == 0 {
            let drink = store.drinks[indexPath.row]
            store.remove(item: drink, fromPerson: Person(name: "David Z"))
            guard let index = selected.index(of: drink)
                else { return }
            selected.remove(at: index)
        }
        
        // unselect
        billTableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    //MARK: - helper methods 
    func makeBubbles() {
        let bar = ContactsBar(frame: .zero)
        bar.horizontalContacts.delegate = self
        let containerView = UIView(frame: CGRect(x: 0, y: 40, width: self.view.bounds.size.height, height: 100))
        containerView.addSubview(bar)
        view.addSubview(containerView)
        
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[horizontalContacts]|", options: .alignAllCenterX, metrics: nil, views: ["horizontalContacts": bar]))
        self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[horizontalContacts]|", options: .alignAllCenterY, metrics: nil, views: ["horizontalContacts": bar]))
        

    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
