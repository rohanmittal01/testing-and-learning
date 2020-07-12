//
//  trimmerViewController.swift
//  testing
//
//  Created by Vandana Mittal on 6/27/20.
//  Copyright © 2020 Rohan Mittal. All rights reserved.
//

import UIKit
import MobileCoreServices
import AVKit


class trimmerViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate, UIVideoEditorControllerDelegate {

      private var picker: UIImagePickerController?
    var videoChosenUrl: URL!

    let editor = UIVideoEditorController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        editor.delegate = self
        // Do any additional setup after loading the view.
    }
    
    @IBAction func choose(_ sender: Any) {
        
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
            print("Destination Path: \(destinationPath)")
            print("Chosen Path: \(videoToCompress)")
//                try? FileManager.default.removeItem(at: destinationPath)
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
    
    @IBAction func trimButton(_ sender: Any) {
         editor.delegate = self
        trim()
    }
    
    
    func trim(){
        print("here1===================")
        let url = "\(String(describing: videoChosenUrl!))"
        print("URL: \(url)===================")
//        if UIVideoEditorController.canEditVideo(atPath: url) {
//
//            editor.videoPath = url
//            editor.videoMaximumDuration = 0
//            present(editor, animated:true)
//        }
//
        
        if UIVideoEditorController.canEditVideo(atPath: videoChosenUrl.relativePath) {
                let editController = UIVideoEditorController()
                editController.videoPath = videoChosenUrl.relativePath
                editController.delegate = self
                present(editController, animated:true)
        }else{
            print("------------------------------------------")
            print("Error encountered")
            print("------------------------------------------")
            
        }
//        guard UIVideoEditorController.canEditVideo(atPath: "\(videoChosenUrl!)") else { return }
//
//
//        editor.videoPath = "\(videoChosenUrl!)"
//        editor.videoMaximumDuration = 0
//
//        present(editor, animated: true, completion: nil)
    }
    
    
    
    func videoEditorController(_ editor: UIVideoEditorController,
       didSaveEditedVideoToPath editedVideoPath: String) {
        dismiss(animated:true)
        let editedUrl = URL(string: editedVideoPath)
        share(url: URL(fileURLWithPath: editedUrl!.relativePath))
    }

    func videoEditorControllerDidCancel(_ editor: UIVideoEditorController) {
        print("--------------------------")
        print("Canceled")
        print("--------------------------")
       dismiss(animated:true)
    }

    func videoEditorController(_ editor: UIVideoEditorController,
               didFailWithError error: Error) {
        print("---------------------------------------")
       print("an error occurred: \(error.localizedDescription)")
        print("----------------------------------------")
       dismiss(animated:true)
    }
    
    func share(url: URL){
        
        let activityViewController = UIActivityViewController(activityItems: [url], applicationActivities: [])
             self.present(activityViewController, animated: true, completion: nil)
        
    }
//    func videoEditorController(_ editor: UIVideoEditorController,
//      didSaveEditedVideoToPath editedVideoPath: String) {
//
//        print("-------------------------")
//        print("Save Pressed")
//        print("-------------------------")
//
////      let activityViewController = UIActivityViewController(activityItems: [videoChosenUrl], applicationActivities: [])
////      self.present(activityViewController, animated: true, completion: nil)
//    }
//    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
