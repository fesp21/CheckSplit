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

    var bar : ContactsBar!

    @IBOutlet weak var billTableView: UITableView!
    
    @IBOutlet weak var nowEditingLabel: UILabel!
    
    var personsTableView : UITableView!
    let reuseIdentifier = "contactCell"
    
    let store = MealDataStore.sharedInstance
    
    var selected = [Drink]()
    var splitWithPersonIndex : Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        billTableView.delegate = self
        billTableView.dataSource = self
        billTableView.allowsMultipleSelectionDuringEditing = true
        billTableView.setEditing(true, animated: true)
        
        makeBubbles()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        billTableView.reloadData()
        bar.horizontalContacts.reloadData()
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidLayoutSubviews() {
        personsTableView = UITableView(frame: billTableView.frame)
        
        personsTableView.delegate = self
        personsTableView.dataSource = self
        personsTableView.register(UINib(nibName: "ContactTableViewCell", bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        personsTableView.allowsMultipleSelection = true
        
        view.addSubview(personsTableView)
        personsTableView.isHidden = true
        
    }
    
    // MARK: - IBActions
    @IBAction func coverTapped(_ sender: Any) {
    }
    
    //MARK: - MEVHorizontalContactsDelegate Methods
    func contactSelected(at index: Int) {
        print("Contact selected at index \(index)")
        
        let selectedName = store.patrons[index].name
        nowEditingLabel.text = "Now editing as \(selectedName)"
        
        
        if let selectedRows = billTableView.indexPathsForSelectedRows { //deselect all
            for index in selectedRows {
                billTableView.deselectRow(at: index, animated: false)
            }
        }
    }
    
    func item(_ item: Int, selectedAtContactIndex index: Int) {
        print("selectedAtContactIndex - index : \(index) option : \(item) ")
        
        if item == 0 {  // show my items
            personsTableView.isHidden = false
            splitWithPersonIndex = index
            billTableView.isHidden = true
            personsTableView.reloadData()
        }
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
        return 24
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 64
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if splitWithPersonIndex == nil {
            if section == 0  { return store.drinks.count }
            else  { return store.food.count   } //section == 1
        }
        else {
            //show personal items
            if section == 0 { return store.patrons[splitWithPersonIndex!].drinks.count }
            else { return store.patrons[splitWithPersonIndex!].entrees.count  }
        }
        
        
    }
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        footer.backgroundColor = UIColor.white
        return footer
    }
   
    // MARK: - TableView DataSource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section

        if let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell") {
            
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
            return cell    //henry refactor: one return statement kthx
        }
        
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier) as? ContactTableViewCell,
            let personIndex = splitWithPersonIndex {
            
            let person = store.patrons[personIndex]
            if section == 0 {
                let drink = person.drinks[indexPath.row]
                cell.nameLabel.text = "\(drink.name)"
                cell.splitWithLabel.text = drink.splitWithPeople
            }
            else if section == 1 {
                let food = person.entrees[indexPath.row]
                
                cell.nameLabel?.text = "\(food.name)"
                //cell.splitWithLabel?.text =
            }
            
            //cell.setSelected(true, animated: false)
            return cell
        }
        
        return UITableViewCell()
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
        let screenWidth = self.view.bounds.size.width
        bar = ContactsBar(frame: .zero )
        bar.horizontalContacts.delegate = self
        let containerView = UIView(frame: CGRect(x: 0, y: 40, width: screenWidth, height: 100))
        containerView.addSubview(bar!)
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
