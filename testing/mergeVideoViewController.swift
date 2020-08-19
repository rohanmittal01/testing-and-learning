//
//  mergeVideoViewController.swift
//  testing
//
//  Created by Vandana Mittal on 7/15/20.
//  Copyright © 2020 Rohan Mittal. All rights reserved.
//

import UIKit
import AVKit

class mergeVideoViewController: UIViewController {

    var url1: URL!
    var url2: URL!
    
    var urlMerged: URL!
    @IBAction func mergeButton(_ sender: UIButton) {

        AVMutableComposition().mergeVideo([url1, url2, url2, url2, url2]) { [weak self] url, error in
            if((url) != nil){
                 print("-----------------------")
                print("url: \(url!)")
                 print("-----------------------")
                self!.urlMerged = url
                self?.share(sender: sender)
            }else{
                print("-----------------------")
                print("Error")
                print("-----------------------")
            }
        }
    }
    
    
    @IBAction func play1(_ sender: Any) {
        let player = AVPlayer(url: url1!)
        let vcPlayer = AVPlayerViewController()
        vcPlayer.player = player
        self.present(vcPlayer, animated: true, completion: nil)
    }
    
    @IBAction func playButton(_ sender: Any) {
        
        let player = AVPlayer(url: urlMerged!)
        let vcPlayer = AVPlayerViewController()
        vcPlayer.player = player
        self.present(vcPlayer, animated: true, completion: nil)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        url1 = URL(fileURLWithPath: Bundle.main.path(forResource: "WhatsApp Video 2020-07-15 at 5.29.23 PM", ofType: "mp4")!)
        url2 = URL(fileURLWithPath: Bundle.main.path(forResource: "WhatsApp Video 2020-07-15 at 5.29.24 PM", ofType: "mp4")!)
        // Do any additional setup after loading the view.
    }
    

    func share(sender: UIButton){
        let activityViewController = UIActivityViewController(activityItems: [urlMerged], applicationActivities: [])
               if let popoverController = activityViewController.popoverPresentationController{
                     popoverController.sourceView = sender
                         popoverController.sourceRect = sender.bounds
                        //            popoverController.barButtonItem = sender
                                }
                     self.present(activityViewController, animated: true, completion: nil)
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
