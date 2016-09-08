//
//  HXHFilter.swift
//  Functional_1
//
//  Created by 张强 on 16/9/7.
//  Copyright © 2016年 ColorPen. All rights reserved.
//

import Foundation
import CoreImage
import AppKit

typealias Filter = (CIImage) -> CIImage

class HXHFilter : NSObject {
    
    /**
     高斯模糊滤镜
     
     blur 返回一个新函数 - 接受一个CIImage 返回一个新图像
     */
    
    func blur(radius : Double) -> Filter {
        
        return { (image : CIImage) in
            
            let parameters = [kCIInputRadiusKey : radius, kCIInputImageKey : image] as [String : Any]
            
            guard let filter = CIFilter.init(name: "CIGaussianBlur", withInputParameters: parameters) else {
                fatalError()
            }
            
            guard let outputimage = filter.outputImage else {
                fatalError()
            }
            
            return outputimage
        }
    }
    
    /*!
     颜色生成滤镜
     */
    func colorGenerator(color: NSColor) -> Filter {
        
        // 匿名参数，强调颜色生成滤镜是可以忽略图像参数的
        return {_ in
            
            guard let col = CIColor.init(color: color) else {
                fatalError()
            }
            
            let parameters = [kCIInputColorKey : col]
            
            guard let filter = CIFilter.init(name: "CIConstantColorGenerator", withInputParameters: parameters) else {
                fatalError()
            }
            
            guard let outputimage = filter.outputImage else {
                fatalError()
            }
            
            return outputimage
        }
    }
    
    /*!
     图像覆盖合成滤镜
     */
    func compositeSourceOver(overlay : CIImage) -> Filter {
        
        return { (image : CIImage) in
            let parameters = [kCIInputBackgroundImageKey : image, kCIInputImageKey : overlay]
            
            guard let filter = CIFilter.init(name: "CISourceOverCompositing", withInputParameters: parameters) else {
                fatalError()
            }
            
            guard let outputImage = filter.outputImage else {
                fatalError()
            }
            
            let cropRect = image.extent
            
            return outputImage.cropping(to: cropRect)
        }
    }
    /*!
     组合滤镜
     */
    func colorOverlay(color : NSColor) -> Filter {
        return { (image : CIImage) in
            
            let overlay : CIImage = self.colorGenerator(color: color)(image)
            
            return self.compositeSourceOver(overlay: overlay)(image)
        }
    }
    
}






