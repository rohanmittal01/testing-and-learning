//
//  videoCompressionViewController.swift
//  OCRCam
//
//  Created by Vandana Mittal on 6/25/20.
//  Copyright © 2020 Rohan Mittal. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit

class videoCompressionViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate {

    private var picker: UIImagePickerController?
//    private var videoView: VideoView?
    var videoChosenUrl: URL!
    var compressedURL: URL!
    override func viewDidLoad() {
        super.viewDidLoad()

//        self.view.frame = UIScreen.main.bounds
//        self.videoView = VideoView(frame: UIScreen.main.bounds)
//        self.view.addSubview(videoView!)


    }

    
    @IBAction func choose(_ sender: Any) {
        
        //
        
            actionSheet()
    }
    
    func actionSheet(){
        
        let actionSheet = UIAlertController(title: "Choose Media", message: "Photo Library or Files?", preferredStyle: .actionSheet)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let photoLibrary = UIAlertAction(title: "Photo Library", style: .default){action in
            self.imagePickerChoose()
        }
        let files = UIAlertAction(title: "Files", style: .default){action in
            self.pickFromFile()
        }
        actionSheet.addAction(photoLibrary)
        actionSheet.addAction(files)
        actionSheet.addAction(cancel)
        present(actionSheet, animated: true, completion: nil)
        
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
}
    

    func pickFromFile(){
               do{
                   let importMenu = try UIDocumentMenuViewController(documentTypes: [String(kUTTypeMovie)], in: .import)
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

        videoChosenUrl = urlFoundAt
    }
    
    
    
    func documentMenu(_ documentMenu: UIDocumentMenuViewController, didPickDocumentPicker documentPicker: UIDocumentPickerViewController) {
                documentPicker.delegate = self
                present(documentPicker, animated: true, completion: nil)
        }

    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        print("view was cancelled")
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func compress(_ sender: Any) {
        
        print(videoChosenUrl ?? "not found")
                 compressionInit(url:  videoChosenUrl!)
        
    }
    
    func compressionInit(url: URL){

        print("here2")
        let videoToCompress = url
        videoChosenUrl = url
        // Declare destination path and remove anything exists in it
        let destinationPath = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("compressed.mp4")
        try? FileManager.default.removeItem(at: destinationPath)

        // Compress
        let cancelable = compressh264VideoInBackground(
            videoToCompress: videoToCompress,
            destinationPath: destinationPath,
            size: nil,
            compressionTransform: .keepSame,
            compressionConfig: .defaultConfig,
            completionHandler: { [weak self] path in
                print("---------------------------")
                print("Success", path)
                print("---------------------------")
                print("Original video size:")
                videoToCompress.verboseFileSizeInMB()
                print("---------------------------")
                print("Compressed video size:")
                path.verboseFileSizeInMB()
                print("---------------------------")
                self?.compressedURL = path
            },
            errorHandler: { e in
                print("---------------------------")
                print("Error: ", e)
                print("---------------------------")
            },
            cancelHandler: {
                print("---------------------------")
                print("Cancel")
                print("---------------------------")
            }
        )

        // To cancel compression, use below example
        //////////////////////////////
        // cancelable.cancel = true
        //////////////////////////////
    }


    

    @IBAction func previewButton(_ sender: Any) {
        print("chosen video url: \(String(describing: videoChosenUrl))")
        previewVideo(url: (videoChosenUrl)!)
        print(videoChosenUrl?.verboseFileSizeInMB())

    }
    @IBAction func afterCompression(_ sender: Any) {
        print("compressed url: \(compressedURL!)")
        print("File size: \(compressedURL.verboseFileSizeInMB())")
        previewVideo(url: compressedURL!)
    }

    func previewVideo(url: URL){

        let player = AVPlayer(url: url)
        let vcPlayer = AVPlayerViewController()
        vcPlayer.player = player
        self.present(vcPlayer, animated: true, completion: nil)

    }

}



// Utility to print file size to console
extension URL {
    func verboseFileSizeInMB() {
        let p = self.path

        let attr = try? FileManager.default.attributesOfItem(atPath: p)

        if let attr = attr {
            let fileSize = Float(attr[FileAttributeKey.size] as! UInt64) / (1024.0 * 1024.0)

            print(String(format: "FILE SIZE: %.2f MB", fileSize))
        } else {
            print("No file")
        }
    }
}



