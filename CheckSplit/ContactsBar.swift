//
//  ContactsBar.swift
//  tryingOutNewHorizontalScrollingCocoapods
//
//  Created by Henry Dinhofer on 1/15/17.
//  Copyright © 2017 Henry Dinhofer. All rights reserved.
//

import UIKit
import MEVHorizontalContacts

class ContactsBar: UIView, MEVHorizontalContactsDataSource {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    var horizontalContacts : MEVHorizontalContacts = MEVHorizontalContacts()
    let store = MealDataStore.sharedInstance

    init() {
        super.init(frame: .zero)
        self.setupView()
    }
    
    override init(frame: CGRect) {
        let screenWidth = UIScreen.main.bounds.size.width
        
        super.init(frame: CGRect(x: 0, y: 40, width: screenWidth, height: 100))
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()

    }
    // this is all probs not the "right way" but moving along...
    init(frame : CGRect, withContacts: MEVHorizontalContacts) {
        super.init(frame: frame)
        setupView()
    }
    
    func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.horizontalContacts = MEVHorizontalContacts()
        self.horizontalContacts.backgroundColor = UIColor.white
        self.horizontalContacts.dataSource = self
        self.addSubview(horizontalContacts)
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[horizontalContacts]|", options: .alignAllCenterX, metrics: nil, views: ["horizontalContacts": horizontalContacts]))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[horizontalContacts]|", options: .alignAllCenterY, metrics: nil, views: ["horizontalContacts": horizontalContacts]))
    }

    //MARK: - MEVHorizontalContactsDataSource Methods
    func numberOfContacts() -> Int {
        return store.patrons.count
    }
    
    func numberOfItems(atContactIndex index: Int) -> Int {
        return 3
    }
    
    func contact(at index: Int) -> MEVHorizontalContactsCell {
        guard let cell = horizontalContacts.dequeueReusableContactCell(for: index) else { return MEVHorizontalContactsCell() }
        cell.imageView.image = UIImage(named: getImageName(at: index)) //generateImage(at: index)
            
        cell.imageView?.layer.borderColor = UIColor(red: CGFloat(34 / 255.0), green: CGFloat(167 / 255.0), blue: CGFloat(240 / 255.0), alpha: CGFloat(1)).cgColor
        cell.imageView?.layer.borderWidth = 1.0
        cell.label.text = self.getUserName(at: index)
        cell.label.font = UIFont.boldSystemFont(ofSize: CGFloat(12.0))
        cell.label.textColor = UIColor.darkGray
        return cell
    }
    
    func item(_ item: Int, atContactIndex index: Int) -> MEVHorizontalContactsCell {
        
        var image: UIImage?
        var labelText: String = ""
        switch item {
        case 0:
            labelText = "My items"    // My items  (new listview with just my items) have ability to remove (deselect it)
            image = UIImage(named: "actionCall")
        case 1:
            labelText = "My bill"   // My bill
            image = UIImage(named: "actionEmail")
        case 2:
            labelText = "Message"
            image = UIImage(named: "actionMessage")
        default:
            labelText = "Call"
            image = UIImage(named: "actionCall")
        }
        
        let cell: MEVHorizontalContactsCell = horizontalContacts.dequeueReusableItemCell(for: index)
        cell.imageView?.image = image
        cell.imageView?.tintColor = UIColor(red: CGFloat(34 / 255.0), green: CGFloat(167 / 255.0), blue: CGFloat(240 / 255.0), alpha: CGFloat(1))
        cell.imageView?.layer.borderColor = UIColor(red: CGFloat(34 / 255.0), green: CGFloat(167 / 255.0), blue: CGFloat(240 / 255.0), alpha: CGFloat(1)).cgColor
        cell.imageView?.layer.borderWidth = 1.0
        cell.label.text = labelText
        cell.label.font = UIFont.boldSystemFont(ofSize: 10.0)
        cell.label.textColor = UIColor.darkGray
        
        
        return cell
    }
    
        func horizontalContactsInsets() -> UIEdgeInsets {
            return UIEdgeInsetsMake(5, 0, 5, 0)
        }
        func horizontalContactsSpacing() -> Int {
            return 5
        }
    

    //MARK: - Helper methods
    func getImageName(at index: Int) -> String {
        var array: [String] = ["image1", "image2", "image3", "image4", "image5", "image6", "image7", "image8", "image9", "image10", "image1", "image2", "image3", "image4", "image5", "image6", "image7", "image8", "image9", "image10", "image1", "image2", "image3", "image4", "image5", "image6", "image7", "image8", "image9", "image10"]
        let name = array[index]
        return name
    }
    
    func getUserName(at index: Int) -> String {
        return store.patrons[index].name
        
        /*var array: [String] = ["James", "Mary", "Robert", "Patricia", "David", "Linda", "Charles", "Barbara", "John", "Paul", "James", "Mary", "Robert", "Patricia", "David", "Linda", "Charles", "Barbara", "John", "Paul", "James", "Mary", "Robert", "Patricia", "David", "Linda", "Charles", "Barbara", "John", "Paul"]
        let name = array[index]
        return name
         */
    }
    
    //additional methods
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    func generateImage(at index : Int) -> UIImage {

        let userName = getUserName(at: index)
        let firstLetter = "\(userName.characters.first!)"
        
        let viewHeight: CGFloat = 200.0
        let viewWidth : CGFloat = 200.0
        let myView = UIView(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))
        myView.backgroundColor = getBackgroundColor(at: index) //UIColor.red

        
        // duh just make it center and whole screen
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight))

        
        label.text = firstLetter
        label.font = UIFont(name: "Georgia", size: 100.0)
        label.textColor = UIColor.white
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        
        myView.addSubview(label)
        
        
        //label.center = CGPoint(x: origin.x + 200/2, y: origin.y + 200/2)
        
        let image = UIImage(view: myView)
        return image
    }
    func getBackgroundColor(at index : Int) -> UIColor {
        var color : UIColor = .lightGray
        
        let numberOfColors = 7
        
        let position = index % numberOfColors
        
        switch position {
        case 0: color = .green
        case 1: color = .darkGray
        case 2: color = .yellow
        case 3: color = .blue
        case 4: color = .orange
        case 5: color = .cyan
        case 6: color = .brown
            
        default: color = .gray
            
        }
        return color
    }
}
