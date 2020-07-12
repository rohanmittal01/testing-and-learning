//
//  ViewController.swift
//  testing
//
//  Created by Vandana Mittal on 6/23/20.
//  Copyright © 2020 Rohan Mittal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var appearanceSegment: UISegmentedControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func segmentControl(_ sender: Any) {
        
        switch appearanceSegment.selectedSegmentIndex{
        case 0: overrideUserInterfaceStyle = .light
        case 1: overrideUserInterfaceStyle = .dark
        case 2: overrideUserInterfaceStyle = .unspecified
        default: overrideUserInterfaceStyle = .unspecified
        }
        
    }
    
}

