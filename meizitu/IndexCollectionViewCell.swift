//
//  IndexCollectionViewCell.swift
//  CookBook
//
//  Created by 王卓 on 16/8/25.
//  Copyright © 2016年 SherryTeam. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

class IndexCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    var dataModel:MyData?
    
    func configWithDataModel(_ data: MyData) -> Void{
        func configApperance(){
            self.contentView.layer.backgroundColor = UIColor.white.cgColor
            self.contentView.layer.borderWidth = 0.5
            self.contentView.layer.borderColor = UIColor.clear.cgColor
            self.layer.shadowColor = UIColor.darkGray.cgColor
            self.layer.shadowOffset = CGSize(width: 0, height: 0)
            self.layer.shadowRadius = 4.0
            self.layer.shadowOpacity = 0.9
            self.layer.masksToBounds = false
            self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds,cornerRadius: self.contentView.layer.cornerRadius).cgPath
        }
        configApperance()
        dataModel = data
        
        title.text = data.title
        image.kf.setImage(with: URL(string: data.img!), placeholder: nil, options: nil, progressBlock: { (receivedSize, totalSize) in
            
        }) { (image, error, cacheType, imageURL) in
            
        }
    }
}
