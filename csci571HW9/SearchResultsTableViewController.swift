//
//  SearchResultsTableViewController.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/18/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireSwiftyJSON
import SwiftyJSON
import Toast_Swift

class SearchResultsTableViewController: UITableViewController {
    
    var products = [Item]()
    var searchResultsJson:JSON!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController!.navigationBar.topItem!.title = "Product Search"
        loadProducts()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return products.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "SearchCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? SearchResultsTableViewCell else {
            fatalError("The dequeued cell is not an instance of SearchResultsTableViewCell.")
        }
        
        // Configure the cell...
        let product = products[indexPath.row]
        cell.titleLabel.text = product.title
        cell.priceLabel.text = "$" + product.price
        cell.shippingLabel.text = product.shipping
        cell.zipcodeLabel.text = product.zipcode
        cell.conditionLabel.text = product.condition
        cell.photoImageView.image = product.photo
        
        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */
 

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

//     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let vc1 = segue.destination as? TabBarViewController  {
            guard let selectedCell = sender as? SearchResultsTableViewCell else {
                fatalError("Unexpected sender: \(sender)")
            }
            guard let indexPath = tableView.indexPath(for: selectedCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            vc1.product = self.products[indexPath.row]
//            print("product in SearchResultsTableViewController: ", self.products[indexPath.row].title)
        }
    }
    
    private func loadProducts(){
        var total_num = 0
        total_num = self.searchResultsJson["findItemsAdvancedResponse"][0]["searchResult"][0]["item"].count
        
//        print("total_num: ", total_num)
        if (total_num == 0) {
            showAlert(Title: "No Results", Message: "Failed to fetch search results")
            return
        }

        for index in 0...total_num - 1{
            let item = self.searchResultsJson["findItemsAdvancedResponse"][0]["searchResult"][0]["item"][index]
            
            let id = item["itemId"][0].string ?? ""
            let galleryURL = item["galleryURL"][0].string ?? "N.A."
            var photo: UIImage?
            if (galleryURL != "N.A."){
                let imageUrl = URL(string: galleryURL)!
                let imageData = try! Data(contentsOf: imageUrl)
                photo = UIImage(data: imageData) ?? UIImage(named: "defaultImage")
            } else {
                photo = UIImage(named: "defaultImage")
            }
            
            
            let title = item["title"][0].string ?? "N.A."
//            var price = "$"
            var price = ""
            price += item["sellingStatus"][0]["currentPrice"][0]["__value__"].string ?? "N.A."
            var shipping = item["shippingInfo"][0]["shippingServiceCost"][0]["__value__"].string ?? "N.A."
            if (shipping == "0.0"){
                shipping = "FREE"
            } else if (shipping != "N.A.") {
                shipping = "$" + shipping
            }
            let zipcode = item["postalCode"][0].string ?? "N.A."
            let condition_id = item["condition"][0]["conditionId"][0].string ?? "N.A."
            var condition = "N.A."
            switch condition_id {
            case "1000":
                condition = "NEW"
            case "2000":
                condition = "REFURBISHED"
            case "2500":
                condition = "REFURBISHED"
            case "3000":
                condition = "USED"
            case "4000":
                condition = "USED"
            case "5000":
                condition = "USED"
            case "6000":
                condition = "USED"
            default:
                condition = "N.A."
            }
            
            let wishButton = UIButton()
            wishButton.addTarget(self, action: "pressed", for: .touchUpInside)
            
            func pressed(sender: UIButton!) {
                print("wish button clicked")
            }
            let viewUrl = item["viewItemURL"][0].string ?? "www.ebay.com"
            
            guard let product = Item(id: id, title: title, price: price, shipping: shipping, zipcode: zipcode, condition: condition, photo: photo!, photoUrl: galleryURL, isInCart: false, viewUrl: galleryURL) else {
                fatalError("Unable to instantiate product 1")
            }
            
            products.append(product)
        }
    }
    
    private func showAlert(Title: String, Message: String){
        // create the alert
        let alert = UIAlertController(title: Title, message: Message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: { _ in self.performSegue(withIdentifier: "unwindSegueToVC1", sender: nil)
        }))
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

}
