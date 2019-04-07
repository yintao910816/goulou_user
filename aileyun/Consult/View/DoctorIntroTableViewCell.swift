//
//  DoctorIntroTableViewCell.swift
//  aileyun
//
//  Created by huchuang on 2017/7/18.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class DoctorIntroTableViewCell: UITableViewCell {
    var model : DoctorModel? {
        didSet{
            specialityL.text = model?.goodProject
            introL.text = model?.brif
        }
    }
    
    lazy var specialityL : UILabel = {
        let l = UILabel()
        l.font = UIFont.init(name: kReguleFont, size: 13)
        l.textColor = kTextColor
        return l
    }()
    
    lazy var introL : UILabel = {
        let l = UILabel()
        l.font = UIFont.init(name: kReguleFont, size: 12)
        l.textColor = kLightTextColor
        l.numberOfLines = 0
        return l
    }()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(specialityL)
        self.addSubview(introL)
        
        specialityL.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(15)
        }
        introL.snp.updateConstraints { (make) in
            make.left.equalTo(self).offset(20)
            make.top.equalTo(specialityL.snp.bottom).offset(10)
            make.width.equalTo(SCREEN_WIDTH - 40)
            make.bottom.equalTo(self).offset(-10)
        }
        
    }
    
    func debug(){
        specialityL.text = "试管婴儿， 人工授精"
        introL.text = "我也不知道写什么东西上去所以就随便写点主要还是为了测试能不能换行啦我也不知道写什么东西上去所以就随便写点主要还是为了测试能不能换行啦我也不知道写什么东西上去所以就随便写点主要还是为了测试能不能换行啦我也不知道写什么东西上去所以就随便写点主要还是为了测试能不能换行啦我也不知道写什么东西上去所以就随便写点主要还是为了测试能不能换行啦"
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
