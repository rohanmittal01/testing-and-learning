//
//  filtersOptionsViewController.swift
//  testing
//
//  Created by Vandana Mittal on 7/14/20.
//  Copyright © 2020 Rohan Mittal. All rights reserved.
//

import UIKit

class filtersOptionsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var collectionView: UICollectionView!
    let filterName=["Mediatrix Filters", "Noise Reduction", "Colour Mapping", "Mask"]

    let filterImage = [ #imageLiteral(resourceName: "1 (2)"),  #imageLiteral(resourceName: "2 (2)"),  #imageLiteral(resourceName: "3 (2)"),  #imageLiteral(resourceName: "4 (2)")]
    
    override func viewDidLoad() {
        super.viewDidLoad()

//        let layout = UICollectionViewFlowLayout()
//        layout.minimumLineSpacing = 10
//        self.collectionView?.collectionViewLayout = layout
        // Do any additional setup after loading the view.
    }

//      func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//                let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
//                let cellWidth: CGFloat = flowLayout.itemSize.width
//                let cellSpacing: CGFloat = flowLayout.minimumInteritemSpacing
//                let cellCount = CGFloat(collectionView.numberOfItems(inSection: section))
//                var collectionWidth = collectionView.frame.size.width
//                if #available(iOS 11.0, *) {
//                    collectionWidth -= collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right
//                }
//                let totalWidth = cellWidth * cellCount + cellSpacing * (cellCount - 1)
//                if totalWidth <= collectionWidth {
//                    let edgeInset = (collectionWidth - totalWidth) / 2
//                    return UIEdgeInsets(top: flowLayout.sectionInset.top, left: edgeInset, bottom: flowLayout.sectionInset.bottom, right: edgeInset)
//                } else {
//                    return flowLayout.sectionInset
//                }
//            }
  
                

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
                       return CGSize(width: 281, height: 75)
                   }
                
                func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                    
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! imgFilterCollectionViewCell
                    
                    cell.image.image = filterImage[indexPath.row]
                    return cell
                }

              
                
                func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                
                    print(indexPath.row)

                }


}
