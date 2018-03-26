//
//  ImageLayout.swift
//  Sbirka
//
//  Created by Игорь on 02/01/2018.
//  Copyright © 2018 Xuli. All rights reserved.
//

import Foundation
import UIKit

public enum ImageSource {
//    case network(String?)
    case named(String)
    case data(Foundation.Data)
    case image(UIImage)
    //    case LocalByName(String)
    case none
}

public class ImageLayout: ViewLayout {
    
    var source: ImageSource
    
    public init(frame: CGRect, source: ImageSource, hidden: Bool = false) {
        self.source = source
        
        super.init(frame: frame, hidden: hidden)
    }
    
    override class var emptyLayout: ImageLayout {
        return ImageLayout(frame: CGRect.zero, source: .none, hidden: true)
    }
}

extension UIImageView {
    public func applyLayout(_ layout: ImageLayout) {
        isHidden = layout.hidden
        if isHidden { return }
        frame = layout.frame
        applySource(layout.source)
    }
    
    public func applySource(_ source: ImageSource) {
        switch source {
//        case .network(let url):
//            setImageByUrl(url)
        // TODO: provide method to download via third party libraries
        case .data(let data):
            image = UIImage(data: data)
        case .named(let named):
            image = UIImage(named: named)
            //        case .LocalByName(let fileName):
        case .image(let img):
            image = img
        case .none:
            image = nil
        }
    }
}

extension UIButton {
    public func applyLayout(_ layout: ImageLayout) {
        applyLayout(layout, clear: true)
    }
    
    public func applyLayout(_ layout: ImageLayout, clear: Bool) {
        isHidden = layout.hidden
        if isHidden { return }
        frame = layout.frame
        switch layout.source {
//        case .network(let url):
//            setImageByUrl(url, clear: clear)
        case .data(let data):
            let image = UIImage(data: data)
            setImage(image, for: .normal)
        case .named(let named):
            let image = UIImage(named: named)
            setImage(image, for: .normal)
            //        case .LocalByName(let fileName):
        //            setImage(image, forState: .Normal)
        case .image(let img):
            setImage(img, for: .normal)
        case .none:
            setImage(nil, for: .normal)
        }
    }
}
