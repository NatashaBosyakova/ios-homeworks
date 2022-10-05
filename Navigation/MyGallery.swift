//
//  MyGallery.swift
//  Navigation
//
//  Created by Наталья Босякова on 05.10.2022.
//

import UIKit

class MyGallery {
    
    func getCount() -> Int {
        
        let fileManager = FileManager.default
        let dirContents = try? fileManager.contentsOfDirectory(atPath: Bundle.main.bundlePath+"/MyGallery/")
        let count = dirContents?.count

        return (count == nil) ? 0 : count!
    }
    
    func getImage(index: Int) -> UIImage {
        
        let url = URL.init(fileURLWithPath: Bundle.main.bundlePath+"/MyGallery/Photo-"+String(index)+".jpeg")
        if let imageData = NSData(contentsOf: url), let image = UIImage(data: imageData as Data) {
            return image
        }
        else {
            fatalError("Image \""+Bundle.main.bundlePath+"/MyGallery/Photo-"+String(index)+".jpeg\" not found!")
        }

    }
}
