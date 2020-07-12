//
//  filterViewController.swift
//  testing
//
//  Created by Vandana Mittal on 6/30/20.
//  Copyright © 2020 Rohan Mittal. All rights reserved.
//

import UIKit
import MetalKit
import MetalPerformanceShaders
import CoreImage
import CoreImage.CIFilterBuiltins

class filterViewController: UIViewController {

    var device: MTLDevice? = MTLCreateSystemDefaultDevice()
    var commandQueue: MTLCommandQueue?
    @IBOutlet weak var img1: UIImageView!
    @IBOutlet weak var img2: UIImageView!
    @IBOutlet weak var img3: UIImageView!
    @IBOutlet weak var img4: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        commandQueue = self.device!.makeCommandQueue()
        img1.image = UIImage(named: "Picture1")
        img2.image = UIImage(named: "pic2")
        // Do any additional setup after loading the view.
    }
    
    func laplacian(_ image: CGImage) -> CGImage? {
        print("laplacian")
        let commandBuffer = self.commandQueue?.makeCommandBuffer()!

        let laplacian = MPSImageSobel(device: device as! MTLDevice)

        let textureLoader = MTKTextureLoader(device: device as! MTLDevice)
        let options: [MTKTextureLoader.Option : Any]? = nil
        let srcTex = try! textureLoader.newTexture(cgImage: image, options: options)

        let desc = MTLTextureDescriptor.texture2DDescriptor(pixelFormat: srcTex.pixelFormat,
                                                            width: srcTex.width,
                                                            height: srcTex.height,
                                                            mipmapped: false)
        desc.pixelFormat = .rgba8Unorm
        desc.usage = [.shaderRead, .shaderWrite]

        let lapTex = self.device?.makeTexture(descriptor: desc)!

        laplacian.encode(commandBuffer: commandBuffer as! MTLCommandBuffer, sourceTexture: srcTex, destinationTexture: lapTex as! MTLTexture)

        #if os(macOS)
        let blitCommandEncoder = commandBuffer.makeBlitCommandEncoder()!
        blitCommandEncoder.synchronize(resource: lapTex)
        blitCommandEncoder.endEncoding()
        #endif

        commandBuffer?.commit()
        commandBuffer?.waitUntilCompleted()

        // Note: You may want to use a different color space depending
        // on what you're doing with the image
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        // Note: We skip the last component (A) since the Laplacian of the alpha
        // channel of an opaque image is 0 everywhere, and that interacts oddly
        // when we treat the result as an RGBA image.
        let bitmapInfo = CGImageAlphaInfo.noneSkipLast.rawValue
        let bytesPerRow = lapTex!.width * 4
        let bitmapContext = CGContext(data: nil,
                                      width: lapTex!.width,
                                      height: lapTex!.height,
                                      bitsPerComponent: 8,
                                      bytesPerRow: bytesPerRow,
                                      space: colorSpace,
                                      bitmapInfo: bitmapInfo)!
        lapTex?.getBytes(bitmapContext.data!,
                        bytesPerRow: bytesPerRow,
                        from: MTLRegionMake2D(0, 0, lapTex!.width, lapTex!.height),
                        mipmapLevel: 0)
        return bitmapContext.makeImage()
    }
    
    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
        print("convert")
        let context = CIContext(options: nil)
        if context != nil {
            return context.createCGImage(inputImage, from: inputImage.extent)
        }
        return nil
    }
    
    func subtract(source: UIImage, mask: UIImage) -> UIImage {
        print("subtract")
        UIGraphicsBeginImageContextWithOptions(source.size, false, source.scale)
        source.draw(at: CGPoint.zero)
        mask.draw(at: CGPoint.zero, blendMode: .destinationOut, alpha: 1.0)
        let result = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
        
        return result!
    }
    
    func imageTapped(image: UIImage) -> UIImage {
           let beginImage = CIImage(image: image)
           if let filter = CIFilter(name: "CILinearGradient") {
               filter.setValue(beginImage, forKey: kCIInputImageKey)
            let newImage = UIImage(ciImage: filter.outputImage!)
            return newImage
           }
        return image
       }
    
    @IBAction func laplacianButton(_ sender: Any) {
        
//        let ciImage = CIImage(image: img1.image!)!
//        let cgImage = convertCIImageToCGImage(inputImage: ciImage)
//        let retrievedCGImage = laplacian(cgImage!)
//        var retrievedImage = UIImage(cgImage: retrievedCGImage!)
//        img1.image = retrievedImage
//        retrievedImage = imageTapped(image: retrievedImage)
//        img2.image = subtract(source: retrievedImage, mask: img1.image!)
//        img2.image = imageTapped(image: img1.image!)
        
//        let delayTime = DispatchTime.now() + 3.0
//        DispatchQueue.main.asyncAfter(deadline: delayTime, execute: {
//            self.hello()
//          })
        img3.image = hello(image: img1.image!)
        
//        if((img3.image) != nil){
//        img4.image = imageTapped(image: img1.image!)
//        }
//        img1.image = imageTapped(image: img2.image!)
    }

    func hello(image: UIImage?) -> UIImage{
        
        let context = CIContext(options: nil)
        let blur = CIFilter.gaussianBlur()
//        blur.inputImage = CIImage(image: image!)
        blur.radius = 30

        if let output = blur.outputImage {
            if let cgimg = context.createCGImage(output, from: output.extent) {
                let processedImage = UIImage(cgImage: cgimg)
                // use your blurred image here
            
                return processedImage
            }
        }
        return image!
    }
}
//
//extension UIImage{
//
//    var noiseReducted: UIImage? {
// let coreImageContext = CIContext(options: nil)
// var gradientFilter = CIFilter(name: "CILinearGradient")
// gradientFilter?.setDefaults()
// let startColor = CIColor(cgColor: UIColor.yellow.cgColor)
// let endColor = CIColor(cgColor: UIColor.red.cgColor)
// let startVector = CIVector(x: 0, y: 0)
// let endVector = CIVector(x: 100, y: 100)
// gradientFilter?.setValue(startVector, forKey: "inputPoint0")
// gradientFilter?.setValue(endVector, forKey: "inputPoint1")
// gradientFilter?.setValue(startColor, forKey: "inputColor0")
// gradientFilter?.setValue(endColor, forKey: "inputColor1")
// let outputImage = gradientFilter?.outputImage
// var cgimg: CGImage? = nil
// if let outputImage = outputImage {
//     cgimg = coreImageContext.createCGImage(outputImage, from: CGRect(x: 0, y: 0, width: 100, height: 100))
// }
// var newImage: UIImage? = nil
// if let cgimg = cgimg {
//     newImage = UIImage(cgImage: cgimg)
// }
// return newImage
//
//    }
//
//    
//}
