//
//  imgFilterWithCollectionViewController.swift
//  testing
//
//  Created by Vandana Mittal on 7/12/20.
//  Copyright © 2020 Rohan Mittal. All rights reserved.
//

import UIKit

class imgFilterWithCollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    var originalImage: UIImage!
    var gradientImage: UIImage!
    let filterName=["Default", "Noise Reduction", "Map", "Invert", "Sepia", "Chrome", "Fade", "Instant", "Mono", "Noir", "Process", "Tonal", "Tone1", "Tone2", "Transfer"]
    let filterType = ["", "CINoiseReduction", "CIColorMap", "CIColorInvert", "CISepiaTone", "CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono"
        , "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CISRGBToneCurveToLinear", "CILinearToSRGBToneCurve", "CIPhotoEffectTransfer"]
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        originalImage = #imageLiteral(resourceName: "Rohan Mittal")
        gradientImage = #imageLiteral(resourceName: "gradient")
        imageView.image = originalImage
        collectionView.delegate = self
        let layout = UICollectionViewFlowLayout()

        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .horizontal
        self.collectionView?.collectionViewLayout = layout
        actionSheet()
        
    }
    
    
    func actionSheet(){
                
                let actionSheet = UIAlertController(title: "Choose Media", message: "Photo Library or Files?", preferredStyle: .actionSheet)
                let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                let photoLibrary = UIAlertAction(title: "Photo Library", style: .default){action in
                    self.gradientImage = #imageLiteral(resourceName: "gradient")
                }
                let files = UIAlertAction(title: "Files", style: .default){action in
                    self.gradientImage = #imageLiteral(resourceName: "Rohan Mittal")
                }
                actionSheet.addAction(photoLibrary)
                actionSheet.addAction(files)
                actionSheet.addAction(cancel)
        
        if let popoverController = actionSheet.popoverPresentationController{
            popoverController.sourceView = self.view
            popoverController.sourceRect = self.view.bounds
               //            popoverController.barButtonItem = sender
                       }
        
                present(actionSheet, animated: true, completion: nil)
                
            }
    
    @IBAction func shareButton(_ sender: UIButton) {
        share(sender: sender)
    }
    
    
       func startActivityIndicator(){
              activityIndicator.center = self.view.center
              activityIndicator.hidesWhenStopped = true
              activityIndicator.style = UIActivityIndicatorView.Style.white
              let transform = CGAffineTransform(scaleX: 1,y: 1);
              activityIndicator.transform = transform
              view.addSubview(activityIndicator)
              activityIndicator.startAnimating()
          }
          
          func stopActivityIndicator(){
              activityIndicator.stopAnimating()
          }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        let cellWidth: CGFloat = flowLayout.itemSize.width
        let cellSpacing: CGFloat = flowLayout.minimumInteritemSpacing
        let cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
        var collectionWidth = collectionView.frame.size.width
        if #available(iOS 11.0, *) {
            collectionWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
        }
        let totalWidth = cellWidth * cellCount + cellSpacing * (cellCount - 1)
        if totalWidth <= collectionWidth {
            let edgeInset = (collectionWidth - totalWidth) / 2
            return UIEdgeInsets(top: flowLayout.sectionInset.top, left: edgeInset, bottom: flowLayout.sectionInset.bottom, right: edgeInset)
        } else {
            return flowLayout.sectionInset
        }
    }
//
//        @IBAction func button(_ sender: Any) {
//    //        img2.image = img1.image?.addFilter(filter: FilterType.Chrome)
//    //        img3.image = img1.image?.addFilter(filter: FilterType.Fade)
//    //        img4.image = img1.image?.addFilter(filter: FilterType.Instant)
//    //        img2.image = img1.image?.addFilter(filter: FilterType.Mono)
//    //        img3.image = img1.image?.addFilter(filter: FilterType.Noir)
//    //        img4.image = img1.image?.addFilter(filter: FilterType.Process)
//    //        img2.image = img1.image?.addFilter(filter: FilterType.Process)
//    //        img3.image = img1.image?.addFilter(filter: FilterType.Tonal)
//    //        img4.image = img1.image?.addFilter(filter: FilterType.Transfer)
//
//        }
        

        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return filterName.count
        }

        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
        
        
        
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//            return 10
//        }
//
//        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//            return 10
//        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
               return CGSize(width: 80, height: 95)
           }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! imgFilterCollectionViewCell
            
            switch indexPath.row {
            case 0:
                cell.image.image = originalImage
            case 1:
                cell.image.image = originalImage.noiseReduction()
            case 2:
                cell.image.image = originalImage.colorMap(gradientImage: gradientImage)
            case 3:
                cell.image.image = originalImage.colorInvert()
            case 4:
                cell.image.image = originalImage.sepiaTone()
            default:
                cell.image.image = originalImage.addFilter(filter: FilterType(rawValue: filterType[indexPath.row])!)
            }

            print("Filter Name: \(filterName[indexPath.row])")
            print("Filter Type: \(filterType[indexPath.row])")
            cell.imageName.text = filterName[indexPath.row]
            cell.layer.cornerRadius = 5
      
            return cell
        }
        
//        let imageRef = iv.image.cgImage
//        let context = CIContext(options: nil) // 1
//        var ciImage: CIImage? = nil
//        if let imageRef = imageRef {
//            ciImage = CIImage(cgImage: imageRef)
//        } // 2
//        var filter = CIFilter(name: "CINoiseReduction")
//        filter?.setDefaults()
//        filter?.setValue(ciImage, forKey: "inputImage") // 3
//        let ciResult = filter?.value(forKey: kCIOutputImageKey) as? CIImage // 4
//        var cgImage: CGImage? = nil
//        if let ciResult = ciResult {
//            cgImage = context.createCGImage(ciResult, from: ciResult?.extent ?? CGRect.zero)
//        }
//        var img: UIImage? = nil
//        if let cgImage = cgImage {
//            img = UIImage(cgImage: cgImage)
//        }
//        iv.image = img
      
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            startActivityIndicator()
            if(indexPath.row == 0){
                imageView.image = originalImage.colorAlpha()
            }else if(indexPath.row == 1){
                imageView.image = originalImage.noiseReduction()
                
            }else if(indexPath.row == 2){
                imageView.image = originalImage.colorMap(gradientImage: gradientImage)
                stopActivityIndicator()
            }else if(indexPath.row == 3){
                 imageView.image = originalImage.colorInvert()
                stopActivityIndicator()
            }else if(indexPath.row == 4){
                imageView.image = originalImage.sepiaTone()
            }else if(indexPath.row == 5){
                selectedFilter(indexPath: 5)
            }else if(indexPath.row == 6){
                selectedFilter(indexPath: 6)
            }else if(indexPath.row == 7){
                selectedFilter(indexPath: 7)
            }else if(indexPath.row == 8){
                selectedFilter(indexPath: 8)
            }else if(indexPath.row == 9){
                selectedFilter(indexPath: 9)
            }else if(indexPath.row == 10){
                selectedFilter(indexPath: 10)
            }else if(indexPath.row == 11){
                selectedFilter(indexPath: 11)
            }else if(indexPath.row == 12){
                selectedFilter(indexPath: 12)
            }else if(indexPath.row == 13){
                selectedFilter(indexPath: 13)
            }else if(indexPath.row == 14){
                selectedFilter(indexPath: 14)
            }else if(indexPath.row == 15){
                selectedFilter(indexPath: 15)
            }

        }
    
    func selectedFilter(indexPath: Int){
        imageView.image = originalImage.addFilter(filter: FilterType(rawValue: filterType[indexPath])!)
        stopActivityIndicator()
    }
    

    func share(sender: UIButton){
          
        let activityViewController = UIActivityViewController(activityItems: [imageView.image], applicationActivities: [])
        
        if let popoverController = activityViewController.popoverPresentationController{
        popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
           //            popoverController.barButtonItem = sender
                   }
               self.present(activityViewController, animated: true, completion: nil)
        
        
          
      }

    
    
    
    
    
}

enum FilterType : String {
case Chrome = "CIPhotoEffectChrome"
case Fade = "CIPhotoEffectFade"
case Instant = "CIPhotoEffectInstant"
case Mono = "CIPhotoEffectMono"
case Noir = "CIPhotoEffectNoir"
case Process = "CIPhotoEffectProcess"
case Tonal = "CIPhotoEffectTonal"
case Transfer =  "CIPhotoEffectTransfer"
case Tone1 = "CISRGBToneCurveToLinear"
case Tone2 = "CILinearToSRGBToneCurve"
}

extension UIImage {

    func addFilter(filter : FilterType) -> UIImage {
        let filter = CIFilter(name: filter.rawValue)
        // convert UIImage to CIImage and set as input
        let ciInput = CIImage(image: self)
        filter?.setValue(ciInput, forKey: "inputImage")
        // get output CIImage, render as CGImage first to retain proper UIImage scale
        let ciOutput = filter?.outputImage
        let ciContext = CIContext()
        let cgImage = ciContext.createCGImage(ciOutput!, from: (ciOutput?.extent)!)
        //Return the image
        return UIImage(cgImage: cgImage!)
    }
    
      func noiseReduction() -> UIImage{
          let beginImage = CIImage(image: self)

        print("In function")
             if let filter = CIFilter(name: "CINoiseReduction") {
                          filter.setDefaults()
                 filter.setValue(beginImage, forKey: kCIInputImageKey)
              filter.setValue(0.1, forKey: "inputNoiseLevel")
              filter.setValue(0.4, forKey: "inputSharpness")
              let newImage = UIImage(ciImage: filter.outputImage!)
    
              return newImage
             }
          return self
      }
    
    func colorInvert() -> UIImage {
           let beginImage = CIImage(image: self)
           if let filter = CIFilter(name: "CIColorInvert") {
            
               filter.setValue(beginImage, forKey: kCIInputImageKey)
            let newImage = UIImage(ciImage: filter.outputImage!)
            return newImage
           }
        return self
       }
    func colorAlpha() -> UIImage {
           let beginImage = CIImage(image: self)
           if let filter = CIFilter(name: "CIMaskToAlpha") {
            
               filter.setValue(beginImage, forKey: kCIInputImageKey)
            let newImage = UIImage(ciImage: filter.outputImage!)
            return newImage
           }
        return self
       }
    
    func sepiaTone() -> UIImage{
           let beginImage = CIImage(image: self)
           if let filter = CIFilter(name: "CISepiaTone") {
                filter.setDefaults()
                filter.setValue(beginImage, forKey: kCIInputImageKey)
            let newImage = UIImage(ciImage: filter.outputImage!)
            return newImage
           }
        return self
    }
    
    
    func colorMap(gradientImage: UIImage) -> UIImage {
           let beginImage = CIImage(image: self)
        let colormapImage = CIImage(image: gradientImage)
           if let filter = CIFilter(name: "CIColorMap") {
            
               filter.setValue(beginImage, forKey: kCIInputImageKey)
            filter.setValue(colormapImage, forKey: kCIInputGradientImageKey)
            let newImage = UIImage(ciImage: filter.outputImage!)
            return newImage
           }
        return self
       }

}
