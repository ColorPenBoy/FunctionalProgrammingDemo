//
//  ViewController.swift
//  Functional_1
//
//  Created by 张强 on 16/9/7.
//  Copyright © 2016年 ColorPen. All rights reserved.
//

import Cocoa

// 为组合滤镜引入运算符
//infix operator >>> { associativity left }

class ViewController: NSViewController {

 
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let url = NSURL.init(string: "http://www.objc.io/images/covers/16.jpg")
        let image = CIImage.init(contentsOf: url as! URL)!
    
        let imageview1 = self.createImage(frame: NSMakeRect(0, 0, 200, 200), image: image)
        self.view.addSubview(imageview1)

        
        // 滤镜
        let blurRadius = 5.0
        let overlayColor = NSColor.red.withAlphaComponent(0.2)
        let blurredImage = HXHFilter().blur(radius: blurRadius)(image)
        let overlaidImage = HXHFilter().colorOverlay(color: overlayColor)(blurredImage)
     
        let imageview2 = self.createImage(frame: NSMakeRect(210, 0, 200, 200), image: overlaidImage)
        self.view.addSubview(imageview2)

        
        // 复合函数
        let resultImage = HXHFilter().colorOverlay(color: overlayColor)(HXHFilter().blur(radius: blurRadius)(image))

        let imageview3 = self.createImage(frame: NSMakeRect(420, 0, 200, 200), image: resultImage)
        self.view.addSubview(imageview3)
        
        
        // 自定义运算符来组合滤镜
        func composeFilters(filter1: Filter, _ filter2: Filter) -> Filter {
            return {image in filter2(filter1(image))}
        }
        
        // 使用自定义组合滤镜 - 更加清晰易懂
        let myFilter1 = composeFilters(filter1: HXHFilter().blur(radius: blurRadius), HXHFilter().colorOverlay(color: overlayColor))
        let resultImage1 = myFilter1(image)
        
        let imageview4 = self.createImage(frame: NSMakeRect(640, 0, 200, 200), image: resultImage1)
        self.view.addSubview(imageview4)
        
//        func >>>(filter1: Filter, _ filter2: Filter) -> Filter {
//            return {image in filter2(filter1(image))}
//        }
//        let myFilter2 = HXHFilter().blur(radius: blurRadius) >>> HXHFilter().colorOverlay(color: overlayColor)
//        let resultImage2 = myFilter2(image)

    }

    private func createImage(frame : NSRect, image : CIImage) -> NSImageView {
       
        let imageview : NSImageView = NSImageView.init(frame:frame)
        // imageview.image = NSImage.init(contentsOf: url as! URL)
        
        // CIImage convert to NSImage
        let rep : NSCIImageRep = NSCIImageRep.init(ciImage: image)
        let nsImage : NSImage = NSImage.init(size: rep.size)
        nsImage.addRepresentation(rep)
        imageview.image = nsImage
        
        return imageview
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

}

