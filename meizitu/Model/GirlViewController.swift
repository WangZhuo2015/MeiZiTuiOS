//
//  GirlViewController.swift
//  meizitu
//
//  Created by 王卓 on 16/8/31.
//  Copyright © 2016年 SherryTeam. All rights reserved.
//

import UIKit
import SnapKit
//import PKHUD
import Kingfisher
import UCZProgressView
import ALAssetsLibrary_CustomPhotoAlbum
import Photos
class GirlViewController: UIViewController {

    var naviTitle:String?
    var url:String?
    var dataArray = [Girl]()
    var image = UIImageView()
    var label = UILabel()
    var slider = UISlider()
    var download : UIBarButtonItem?
    var saveButton: UIBarButtonItem?
    var progressView:UCZProgressView!
    var page = 0{
        didSet{
            label.text = "\(page+1)/\(dataArray.count)"
            slider.value = Float(page - 1)
            progressView.progress = 0
            image.kf.setImage(with: URL(string: dataArray[page].img), placeholder: nil, options: nil, progressBlock: { (receivedSize, totalSize) in
                self.progressView.progress = CGFloat(receivedSize/totalSize)
                }) { (image, error, cacheType, imageURL) in
                    
            }
            //image.kf_setImageWithURL(NSURL(string: dataArray[page].img))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        ServiceProxy.getGirl(url!) { (girls, error) in
            self.dataArray = (girls?.girls)!.sorted(by: {$0.0.index > $0.1.index})
            self.progressView.progress = 0
            self.image.kf.setImage(with: URL(string: self.dataArray[self.page].img))
            self.label.text = "\(self.page+1)/\(self.dataArray.count)"
            
            self.slider.minimumValue = 1
            self.slider.maximumValue = Float(self.dataArray.count)
            
            
            self.slider.addTarget(self, action: #selector(GirlViewController.slide(_:)), for: .valueChanged)
        }
        self.download = UIBarButtonItem(title: "下载全部 ", style: .done, target: self as AnyObject, action: #selector(GirlViewController.downloadAll(_:)))
        self.navigationItem.title = naviTitle
        view.addSubview(image)
        view.insertSubview(label, aboveSubview: view)
        view.insertSubview(slider, aboveSubview: view)
        image.contentMode = .scaleAspectFit
        image.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(44)
            make.left.equalTo(view)
            make.right.equalTo(view)
            make.bottom.equalTo(label)
        }
        saveButton = UIBarButtonItem(title: "保存", style: .done, target: self as AnyObject, action: #selector(GirlViewController.savePhoto))
        self.navigationItem.rightBarButtonItems = [download!,saveButton!]
        
        label.textColor = UIColor.white
        label.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-8)
            make.left.equalTo(view.snp.left)
        }
        slider.snp.makeConstraints { (make) in
            make.bottom.equalTo(view.snp.bottom).offset(-8)
            make.left.equalTo(label.snp.right).offset(15)
            make.right.equalTo(view.snp.left).offset(-15)
        }
        self.progressView = UCZProgressView(frame: self.view.bounds)
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.indeterminate = false
        self.image.addSubview(progressView)
        progressView.progress = 1
        progressView.showsText = true
        progressView.snp.makeConstraints { (make) in
            make.edges.equalTo(image)
        }
        
        
        view.backgroundColor = UIColor.darkGray
        
        
        
        
        
        
        
        
        let left = UISwipeGestureRecognizer(target: self, action: #selector(GirlViewController.swipe(_:)))
        left.direction = .left
        let right = UISwipeGestureRecognizer(target: self, action: #selector(GirlViewController.swipe(_:)))
        right.direction = .right
        view.addGestureRecognizer(left)
        view.addGestureRecognizer(right)
        // Do any additional setup after loading the view.
    }
    
    func slide(_ slider:UISlider){
        page = Int(slider.value) - 1
    }
    func downloadAll(_ btn:UIButton){
        let progress = PKHUDProgressView()
        //PKHUD.sharedHUD.contentView = progress
        HUD.show(.labeledProgress(title: "保存图片", subtitle: "第(1/\(dataArray.count))张"))
        count=0
        cursiveDownload(data: dataArray, offset: 0)
        //downloadArray(data: dataArray)
    }
    
    func swipe(_ gr:UISwipeGestureRecognizer){
        if gr.direction == .right{
            if page > 0{
                page -= 1
            }
        }else if gr.direction == .left{
            if page < dataArray.count-1{
                page += 1
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(UIImage(data: try! Foundation.Data(contentsOf: URL(string: dataArray[page].img)!))!, self, #selector(GirlViewController.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo:UnsafeRawPointer){
        if error != nil {
            HUD.flash(.labeledError(title: "错误", subtitle: "保存失败"), delay: 0.5)
        }else{
            HUD.flash(.labeledSuccess(title: "成功", subtitle: "保存成功"), delay: 0.5)
        }
    }
    
    var count = 0{
        didSet{
            HUD.show(.labeledProgress(title: "保存图片", subtitle: "第(\(count)/\(dataArray.count))张"))
        }
    }
    func completeImageDownload(error:Error?){
        if count == dataArray.count{
            if error != nil {
                HUD.flash(.labeledError(title: "错误", subtitle: "保存图片失败"), delay: 0.5)
            }else{
                HUD.flash(.labeledSuccess(title: "成功", subtitle: "保存全部图片成功"), delay: 0.5)
            }
        }
    }
//    func image(_ image: UIImage, didFinishSavingAllWithError error: NSError?, contextInfo:UnsafeRawPointer){
//        count+=1
//        HUD.show(.labeledProgress(title: "保存图片", subtitle: "第(\(count)/\(dataArray.count))张"))
//        //PKHUD.sharedHUD.contentView.
//        if count == dataArray.count{
//            if error != nil {
//                HUD.flash(.labeledError(title: "错误", subtitle: "保存图片失败"), delay: 0.5)
//            }else{
//                HUD.flash(.labeledSuccess(title: "成功", subtitle: "保存全部图片成功"), delay: 0.5)
//            }
//        }
//    }
    
    

    
    func cursiveDownload(data:[Girl],offset:Int){
        let library = ALAssetsLibrary()
        if offset<data.count{
            library.save(UIImage(data: try! Foundation.Data(contentsOf: URL(string: data[offset].img)!))!, toAlbum: naviTitle, completion: { (url, error) in
                self.count+=1
                self.cursiveDownload(data: data, offset: offset+1)
            }) { (error) in
                self.count+=1
                self.cursiveDownload(data: data, offset: offset+1)
            }
        }else{
            self.completeImageDownload(error: nil)
        }
        //cursiveDownload(data: data, batch: batch, offset: offset+batch)
    }


//    func cursiveDownload(data:[Girl],batch:Int,offset:Int){
//        
//        for (index,item) in data{
//            if index<count {continue}
//            if index-offset>batch{break}
//            library.save(UIImage(data: try! Foundation.Data(contentsOf: URL(string: item.img)!))!, toAlbum: naviTitle, completion: { (url, error) in
//                self.completeImageDownload(error: error)
//            }) { (error) in
//                
//            }
//        }
//        if
//        //cursiveDownload(data: data, batch: batch, offset: offset+batch)
//    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
