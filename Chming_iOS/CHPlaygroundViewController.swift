//
//  CHPlaygroundViewController.swift
//  Chming_iOS
//
//  Created by CLEE on 17/08/2017.
//  Copyright © 2017 leejaesung. All rights reserved.
//

import UIKit

class CHPlaygroundViewController: UIViewController {
    
    @IBOutlet var sampleImg: UIImageView!
    
    @IBOutlet var sampleView: UIView!
    
    @IBAction func testActivationAction(_ sender: UIButton) {
    
    
    
    }
    
    @IBAction func cancelAction(_ sender: UIButton) {
    
        self.dismiss(animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
