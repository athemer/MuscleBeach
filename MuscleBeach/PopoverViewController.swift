//
//  PopoverViewController.swift
//  MuscleBeach
//
//  Created by 陳冠華 on 2017/3/30.
//  Copyright © 2017年 my app. All rights reserved.
//

import UIKit
import Firebase

protocol ValueChangedDelegate: class {
    func didChangeMealAmount(_ manager: PopoverViewController, didGet newAmount:[String: Int])
}

class PopoverViewController: UIViewController {

    static let shared = PopoverViewController()
    
    weak var delegate: ValueChangedDelegate?
    
    var newAmount: [String: Int] = [:]
    
    var amountA: Int = 0
    var amountB: Int = 0
    var amountC: Int = 0
    var key: String = ""

    @IBOutlet weak var amountALable: UILabel!
    
    @IBOutlet weak var amountBLable: UILabel!
    
    @IBOutlet weak var amountCLAbel: UILabel!
    
    @IBOutlet weak var stepperA: UIStepper!
    
    @IBOutlet weak var stepperB: UIStepper!
    
    @IBOutlet weak var stepperC: UIStepper!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        amountALable.text = "\(amountA)"
        amountBLable.text = "\(amountB)"
        amountCLAbel.text = "\(amountC)"
        
        
        stepperA.value = Double (amountA)
        stepperB.value = Double (amountB)
        stepperC.value = Double (amountC)
        
        
        print ("good")
        // Do any additional setup after loading the view.
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        print ("bye")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        
        
        var revisedMealData: [String: Int] = ["typeA": amountA, "typeB": amountB, "typeC": amountC]
        FIRDatabase.database().reference().child("order").child(key).child("meal").updateChildValues(revisedMealData)
       
//        let storyboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        // swiftlint:disable:next force_cast
//        let vc = storyboard.instantiateViewController(withIdentifier: "ShoppingCartViewController") as! ShoppingCartViewController
//        // swiftlint:disable:previous force_cast

        
        getData(data: revisedMealData)
        
        
        self.willMove(toParentViewController: nil)
        
        self.view.removeFromSuperview()
        
        self.removeFromParentViewController()
        
        
        
        print ("QOO")
        

    }
    
    @IBAction func cancelTapped(_ sender: Any) {
        
        self.willMove(toParentViewController: nil)
        
        self.view.removeFromSuperview()
        
        self.removeFromParentViewController()
 
        
    }

    @IBAction func stepperAValueChanged(_ sender: Any) {
        

          amountALable.text = "\(Int(stepperA.value))"
          amountA = Int(stepperA.value)
    }
    
    @IBAction func stepperBValueChanged(_ sender: Any) {
        
          amountBLable.text = "\(Int(stepperB.value))"
          amountB = Int(stepperB.value)
    }
    
    
    @IBAction func stepperCValueChanged(_ sender: Any) {
        
        amountCLAbel.text = "\(Int(stepperC.value))"
        amountC = Int(stepperC.value)
    }
    
    
    func getData (data: [String: Int]) {
        newAmount = data
        self.delegate?.didChangeMealAmount(self, didGet: self.newAmount)
    }
}
