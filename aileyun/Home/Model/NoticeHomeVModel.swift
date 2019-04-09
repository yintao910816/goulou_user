//
//  NoticeHomeVModel.swift
//  aileyun
//
//  Created by huchuang on 2017/11/11.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class NoticeHomeVModel: NSObject {

    var content : String = "GoodNews is coming"
    var title : String?
    var id : NSNumber?
    var createTime : String?
    var type : NSNumber?
    var updateTime : String?
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
