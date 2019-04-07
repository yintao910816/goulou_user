//
//  DoctorAttentionModel.swift
//  aileyun
//
//  Created by huchuang on 2017/8/17.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class DoctorModel: NSObject {
    
    var hospitalId : NSNumber?
    var doctorId : NSNumber?
    
    var hospitalName : String?
    var realName : String?
    var replyCount : NSNumber?
    
    var imgUrl : String?
    var brif : String?
    var reviewNum : NSNumber?
    var doctorRole : String?
    var docPrice : String?
    
    var goodProject : String?
    var reviewStar : NSNumber?
    
    //是否咨询过
    var consultation : NSNumber?
    
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
    


}
