//
//  noiseReductionViewController.swift
//  testing
//
//  Created by Vandana Mittal on 7/15/20.
//  Copyright © 2020 Rohan Mittal. All rights reserved.
//

import UIKit

class noiseReductionViewController: UIViewController {

   
    @IBOutlet weak var noiseLevelSlider: UISlider!
    @IBOutlet weak var sharpnessSlider: UISlider!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var noiseLabel: UILabel!
    @IBOutlet weak var sharpnessLabel: UILabel!
    
    var noiseLevel: Float = 0.02
    var sharpness: Float = 0.4
    let originalImage = #imageLiteral(resourceName: "Rohan Mittal")
    @IBAction func noiseLevelSlider(_ sender: Any) {
        print(self.noiseLevelSlider.value)
        noiseLevel = self.noiseLevelSlider.value
        noiseLabel.text = String(format: "%.2f", noiseLevel)
        imageView.image = originalImage.noiseReduction(noiseLevel: noiseLevel, sharpness: sharpness)
    }
    @IBAction func sharpnessSlider(_ sender: Any) {
        sharpness = self.sharpnessSlider.value
        sharpnessLabel.text = String(format: "%.2f", sharpness)
        imageView.image = originalImage.noiseReduction(noiseLevel: noiseLevel, sharpness: sharpness)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        noiseLabel.text = "0.02"
        sharpnessLabel.text = "0.4"
        imageView.image = originalImage.noiseReduction(noiseLevel: 0.02, sharpness: 0.4)
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


    

