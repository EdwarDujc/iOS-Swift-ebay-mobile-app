//
//  shippingViewController.swift
//  csci571HW9
//
//  Created by Jincheng Du on 4/20/19.
//  Copyright © 2019 Jincheng Du. All rights reserved.
//

import UIKit

class shippingViewController: UIViewController {
    @IBOutlet weak var sellerCaptionLabel: UILabel!
    @IBOutlet weak var shippingCaptionLabel: UILabel!
    @IBOutlet weak var returnCaptionLabel: UILabel!
    @IBOutlet weak var feedbackScoreLabel: UILabel!
    @IBOutlet weak var popularityLabel: UILabel!
    @IBOutlet weak var starImage: UIImageView!
    @IBOutlet weak var shippingCostLabel: UILabel!
    @IBOutlet weak var globalShippingLabel: UILabel!
    @IBOutlet weak var handlingTimeLabel: UILabel!
    @IBOutlet weak var policyLabel: UILabel!
    @IBOutlet weak var refundModeLabel: UILabel!
    @IBOutlet weak var returnWithLabel: UILabel!
    @IBOutlet weak var shippingPaidLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sellerCaptionLabel.layer.addBorder(edge: UIRectEdge.top, color: UIColor.lightGray, thickness: 0.5)
        sellerCaptionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 0.5)
        shippingCaptionLabel.layer.addBorder(edge: UIRectEdge.top, color: UIColor.lightGray, thickness: 0.5)
        shippingCaptionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 0.5)
        
        returnCaptionLabel.layer.addBorder(edge: UIRectEdge.top, color: UIColor.lightGray, thickness: 0.5)
        returnCaptionLabel.layer.addBorder(edge: UIRectEdge.bottom, color: UIColor.lightGray, thickness: 0.5)
        
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
