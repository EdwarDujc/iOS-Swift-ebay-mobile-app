//
//  ViewController.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/15/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit
import McPicker

class ViewController: UIViewController, UITextFieldDelegate {
    //MARK: outlets
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var keyword: UITextField!
    @IBOutlet weak var category: McTextField!    
    @IBOutlet weak var condNewCheckbox: UIButton!
    
    //MARK: properties
    var condNewChecked = false
    let category_option:[[String]] = [["All Categories", "Art", "Baby", "Books", "Clothing, Shoes & Accessories", "Computers/Tablets & Networking", "Health & Beauty", "Music", "Video Games & Consoles"]]
    
    @IBAction func SearchWishControl(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0 :
            searchView.isHidden = false
            break
        case 1:
            searchView.isHidden = true
            break
        default:
            break
        }
    }
    
    override func viewDidLoad() {
        
        // Category
        let mcInputView = McPicker(data: category_option)
        category.text="All Categories"
        category.inputViewMcPicker = mcInputView
        category.doneHandler = { [weak category] (selections) in
            category?.text = selections[0]!
        }
        //do something if user selects an option and taps done
        category.cancelHandler = { [weak category] in
            //do something if user cancels
        }
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    
    //MARK: Actions
    @IBAction func condNewCheckAction(_ sender: Any) {
        if (!condNewChecked){
            condNewCheckbox.setImage(UIImage(named: "markedCheckbox") , for: UIControl.State.normal)
            condNewChecked = true
        }
        else {
            condNewCheckbox.setImage(UIImage(named: "emptyCheckbox") , for: UIControl.State.normal)
            condNewChecked = false
        }
    }
    
}

