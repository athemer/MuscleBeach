//
//  ShoppingCartDetailViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/4/16.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit

class ShoppingCartDetailViewController: UIViewController {
    
    var orderDataToCart: OrderModel?
    
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var time: UILabel!
    
    @IBOutlet weak var deliver: UILabel!
    
    @IBOutlet weak var deliverAdd: UILabel!
    
    @IBOutlet weak var deliverDetail: UILabel!

    @IBOutlet weak var mealAamount: UILabel!
    
    @IBOutlet weak var mealBamount: UILabel!
    
    @IBOutlet weak var mealCamount: UILabel!
    
    @IBOutlet weak var price: UILabel!
    
    @IBOutlet weak var deliverFee: UILabel!
    
    @IBOutlet weak var total: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUpLabels()
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpLabels() {
        date.text = orderDataToCart?.date
        time.text = orderDataToCart?.time
        deliver.text = orderDataToCart?.delvier
        deliverAdd.text = orderDataToCart?.locationArea
        deliverDetail.text = orderDataToCart?.locationDetail
        mealAamount.text = "\((orderDataToCart?.mealTypeAAmount)!)"
        mealBamount.text = "\((orderDataToCart?.mealTypeBAmount)!)"
        mealCamount.text = "\((orderDataToCart?.mealTypeCAmount)!)"
        price.text = "\((orderDataToCart?.price)!)"
        deliverFee.text = "\((orderDataToCart?.delvierFee)!)"
        
        total.text = "\((orderDataToCart?.price)! + (orderDataToCart?.delvierFee)!)"
    }


}
