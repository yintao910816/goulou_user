//
//  GroupManagerViewCell.swift
//  pregnancyForD
//
//  Created by pg on 2017/5/15.
//  Copyright © 2017年 pg. All rights reserved.
//

import UIKit

class GroupManagerViewCell: UICollectionViewCell {
    
    var finalWidth : CGFloat?
    
    var contentS : String? {
        didSet{
            infoL.text = contentS
            infoL.sizeToFit()
            let tempF = infoL.frame
            finalWidth = tempF.size.width + 20
        }
    }
    
    lazy var infoL : UILabel = {
        let l = UILabel()
        l.font = UIFont.init(name: kReguleFont, size: 13)
        l.textColor = kLightTextColor
        l.textAlignment = .center
        l.layer.borderColor = kLightTextColor.cgColor
        l.layer.borderWidth = 1
        l.layer.cornerRadius = 15
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(infoL)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super .init(coder: aDecoder)
    }

    override func layoutSubviews() {
        infoL.snp.updateConstraints { (make) in
            make.left.right.top.bottom.equalTo(self)
        }
    }
    
}
