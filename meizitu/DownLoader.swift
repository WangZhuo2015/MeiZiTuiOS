//
//  DownLoader.swift
//  meizitu
//
//  Created by WangZhuo on 24/03/2017.
//  Copyright © 2017 SherryTeam. All rights reserved.
//

//import Foundation
import UIKit
class DownLoader {
//    func downloadArray(data:[Girl],percent:(_ per:Int)->Void,complete:()->()) {
//        for item in data{
//            UIImageWriteToSavedPhotosAlbum(
//                UIImage(data: try! Foundation.Data(contentsOf: URL(string: item.img!)!),
//                        self,
//                        #selector(GirlViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
//
//        }
//    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer){
        if error != nil {
            HUD.flash(.labeledError(title: "错误", subtitle: "保存失败"), delay: 0.5)
        }else{
            HUD.flash(.labeledSuccess(title: "成功", subtitle: "保存成功"), delay: 0.5)
        }
    }
}
