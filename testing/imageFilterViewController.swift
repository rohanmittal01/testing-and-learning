//
//  imageFilterViewController.swift
//  testing
//
//  Created by Vandana Mittal on 7/11/20.
//  Copyright © 2020 Rohan Mittal. All rights reserved.
//

import UIKit

class imageFilterViewController: UIViewController {

    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func button(_ sender: Any) {
//        img2.image = img1.image?.addFilter(filter: FilterType.Chrome)
//        img3.image = img1.image?.addFilter(filter: FilterType.Fade)
//        img4.image = img1.image?.addFilter(filter: FilterType.Instant)
//        img2.image = img1.image?.addFilter(filter: FilterType.Mono)
//        img3.image = img1.image?.addFilter(filter: FilterType.Noir)
//        img4.image = img1.image?.addFilter(filter: FilterType.Process)
        img2.image = img1.image?.addFilter(filter: FilterType.Process)
        img3.image = img1.image?.addFilter(filter: FilterType.Tonal)
        img4.image = img1.image?.addFilter(filter: FilterType.Transfer)

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

