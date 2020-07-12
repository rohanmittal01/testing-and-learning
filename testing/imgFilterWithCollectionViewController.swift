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
    let filterName=["Default", "Map", "Invert", "Chrome", "Fade", "Instant", "Mono", "Noir", "Process", "Tonal", "Transfer"]
    let filterType = ["", "CIColorMap", "CIColorInvert", "CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant", "CIPhotoEffectMono"
, "CIPhotoEffectNoir", "CIPhotoEffectProcess", "CIPhotoEffectTonal", "CIPhotoEffectTransfer"]
    override func viewDidLoad() {
        super.viewDidLoad()

        originalImage = #imageLiteral(resourceName: "statue")
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
                           popoverController.sourceView = view
            popoverController.sourceRect = view.bounds
               //            popoverController.barButtonItem = sender
                       }
        
                present(actionSheet, animated: true, completion: nil)
                
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
                cell.image.image = colorMap(image: originalImage)
            case 2:
                cell.image.image = colorInvert(image: originalImage)
            default:
                cell.image.image = originalImage.addFilter(filter: FilterType(rawValue: filterType[indexPath.row])!)
            }

            print("Filter Name: \(filterName[indexPath.row])")
            print("Filter Type: \(filterType[indexPath.row])")
            cell.imageName.text = filterName[indexPath.row]
            cell.layer.cornerRadius = 5
      
            return cell
        }
        
      
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if(indexPath.row == 0){
                imageView.image = originalImage
            }else if(indexPath.row == 1){
                imageView.image = colorMap(image: originalImage)
            }else if(indexPath.row == 2){
                imageView.image = colorInvert(image: originalImage)
            }else if(indexPath.row == 3){
                selectedFilter(indexPath: 3)
            }else if(indexPath.row == 4){
                selectedFilter(indexPath: 4)
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
            }
        }
    
    func selectedFilter(indexPath: Int){
        imageView.image = originalImage.addFilter(filter: FilterType(rawValue: filterType[indexPath])!)
    }
    

    func colorInvert(image: UIImage) -> UIImage {
           let beginImage = CIImage(image: image)
           if let filter = CIFilter(name: "CIColorInvert") {
            
               filter.setValue(beginImage, forKey: kCIInputImageKey)
            let newImage = UIImage(ciImage: filter.outputImage!)
            return newImage
           }
        return image
       }
    
    
    func colorMap(image: UIImage) -> UIImage {
           let beginImage = CIImage(image: image)
        let colormapImage = CIImage(image: gradientImage)
           if let filter = CIFilter(name: "CIColorMap") {
            
               filter.setValue(beginImage, forKey: kCIInputImageKey)
            filter.setValue(colormapImage, forKey: kCIInputGradientImageKey)
            let newImage = UIImage(ciImage: filter.outputImage!)
            return newImage
           }
        return image
       }
    
    
    
    
       func applyColorMap(_ imageIn: CIImage?) -> CIImage? {
           // Convert imageIn to B&W by using a gradient image half white / half black
  
           let colormapImage = gradientImage
        if colormapImage == nil {
               print("Bailing out.  Gradient image allocation was NOT successful.")
               return nil
           }
           var colorMapFilter = CIFilter(name: "CIColorMap")
           //[colorMapFilter setDefaults];
           colorMapFilter?.setValue(imageIn, forKey: "inputImage")
           colorMapFilter?.setValue(colormapImage, forKey: "inputGradientImage")
           return colorMapFilter?.value(forKey: "outputImage") as? CIImage //apply filter and return the new image
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
}
