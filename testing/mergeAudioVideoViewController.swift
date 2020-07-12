//
//  mergeAudioVideoViewController.swift
//  testing
//
//  Created by Vandana Mittal on 6/28/20.
//  Copyright © 2020 Rohan Mittal. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import MobileCoreServices

class mergeAudioVideoViewController: UIViewController, UIImagePickerControllerDelegate, UIDocumentMenuDelegate, UINavigationControllerDelegate, UIDocumentPickerDelegate {

    
      private var picker: UIImagePickerController?
    var videoChosenUrl: URL!
    var audioChosenUrl: URL!
    var savePathUrl: URL!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imagePickerChoose()
    }
    
    
     func imagePickerChoose(){
            
            self.picker = UIImagePickerController()
            self.picker?.delegate = self
            self.picker?.sourceType = .photoLibrary
            self.picker?.mediaTypes = [kUTTypeMovie as String]
            self.present(self.picker!, animated: true)
                   
            
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
                
            let videoToCompress = info[UIImagePickerController.InfoKey.mediaURL] as! URL
                
                // Declare destination path and remove anything exists in it
                let destinationPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("compressed.mp4")
            print(destinationPath)
                try? FileManager.default.removeItem(at: destinationPath)
                videoChosenUrl = videoToCompress
                
            dismiss(animated: true, completion: nil)
            pickFromFile()
            
    }
       
    
    
    func pickFromFile(){
               do{
                   let importMenu = try UIDocumentMenuViewController(documentTypes: [String(kUTTypeAudio)], in: .import)
                        importMenu.delegate = self
                        importMenu.modalPresentationStyle = .formSheet
                        self.present(importMenu, animated: true, completion: nil)
                        }
                   }
    
    public func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {

            guard let myURL = urls.first else {
                    return
                    }
                     let urlFoundAt = myURL
                     let theFileName = urlFoundAt.lastPathComponent as! String

        audioChosenUrl = urlFoundAt
        
    }
    
    
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
                documentPicker.delegate = self
                present(documentPicker, animated: true, completion: nil)
        }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }

    @IBAction func merge(_ sender: Any) {
        mergeFilesWithUrl(videoUrl: videoChosenUrl, audioUrl: audioChosenUrl)
    }
    
    func mergeFilesWithUrl(videoUrl:URL, audioUrl:URL)
    {
        let mixComposition : AVMutableComposition = AVMutableComposition()
        var mutableCompositionVideoTrack : [AVMutableCompositionTrack] = []
        var mutableCompositionAudioTrack : [AVMutableCompositionTrack] = []
        let totalVideoCompositionInstruction : AVMutableVideoCompositionInstruction = AVMutableVideoCompositionInstruction()


        //start merge

        let aVideoAsset : AVAsset = AVAsset(url: videoUrl)
        let aAudioAsset : AVAsset = AVAsset(url: audioUrl)

        mutableCompositionVideoTrack.append(mixComposition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: kCMPersistentTrackID_Invalid)!)
        mutableCompositionAudioTrack.append( mixComposition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)!)

        let aVideoAssetTrack : AVAssetTrack = aVideoAsset.tracks(withMediaType: AVMediaType.video)[0]
        let aAudioAssetTrack : AVAssetTrack = aAudioAsset.tracks(withMediaType: AVMediaType.audio)[0]



        do{
            if(aVideoAssetTrack.timeRange.duration <= aAudioAssetTrack.timeRange.duration){
                
                try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aVideoAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: CMTime.zero)

            //In my case my audio file is longer then video file so i took videoAsset duration
            //instead of audioAsset duration

                try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aVideoAssetTrack.timeRange.duration), of: aAudioAssetTrack, at: CMTime.zero)

            }else{
                
                try mutableCompositionVideoTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aAudioAssetTrack.timeRange.duration), of: aVideoAssetTrack, at: CMTime.zero)

                           //In my case my audio file is longer then video file so i took videoAsset duration
                           //instead of audioAsset duration

                           try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(start: CMTime.zero, duration: aAudioAssetTrack.timeRange.duration), of: aAudioAssetTrack, at: CMTime.zero)

                
            }
            //Use this instead above line if your audiofile and video file's playing durations are same

            //            try mutableCompositionAudioTrack[0].insertTimeRange(CMTimeRangeMake(kCMTimeZero, aVideoAssetTrack.timeRange.duration), ofTrack: aAudioAssetTrack, atTime: kCMTimeZero)

        }catch{

        }

        totalVideoCompositionInstruction.timeRange = CMTimeRangeMake(start: CMTime.zero,duration: aVideoAssetTrack.timeRange.duration )

        let mutableVideoComposition : AVMutableVideoComposition = AVMutableVideoComposition()
        mutableVideoComposition.frameDuration = CMTimeMake(value: 1, timescale: 30)

//        mutableVideoComposition.renderSize = CGSizeMake(1280,720)

        //        playerItem = AVPlayerItem(asset: mixComposition)
        //        player = AVPlayer(playerItem: playerItem!)
        //
        //
        //        AVPlayerVC.player = player



        //find your video on this URl
//        let savePathUrl : NSURL = NSURL(fileURLWithPath: NSHomeDirectory() + "/Documents/newVideo.mp4")

          savePathUrl = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("compressed.mp4")
        
        let assetExport: AVAssetExportSession = AVAssetExportSession(asset: mixComposition, presetName: AVAssetExportPresetHighestQuality)!
        assetExport.outputFileType = AVFileType.mp4
        assetExport.outputURL = savePathUrl as URL
        assetExport.shouldOptimizeForNetworkUse = true

        assetExport.exportAsynchronously { () -> Void in
            switch assetExport.status {

            case AVAssetExportSessionStatus.completed:

                //Uncomment this if u want to store your video in asset

                //let assetsLib = ALAssetsLibrary()
                //assetsLib.writeVideoAtPathToSavedPhotosAlbum(savePathUrl, completionBlock: nil)

                print("success")
            case  AVAssetExportSessionStatus.failed:
                print("failed \(assetExport.error)")
            case AVAssetExportSessionStatus.cancelled:
                print("cancelled \(assetExport.error)")
            default:
                print("complete")
            }
        }

    }
    
    
    @IBAction func preview(_ sender: Any) {
        
        let player = AVPlayer(url: savePathUrl)
               let vcPlayer = AVPlayerViewController()
               vcPlayer.player = player
               self.present(vcPlayer, animated: true, completion: nil)
        
        
    }
    

}
