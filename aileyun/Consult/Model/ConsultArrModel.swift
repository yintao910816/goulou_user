//
//  ConsultArrModel.swift
//  aileyun
//
//  Created by huchuang on 2017/7/21.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class ConsultArrModel: HJModel {
    var dataState : [HC_consultArrModel]?
    var dataSource : [[HC_consultViewmodel]]?
    var status : String?
    var pageNo : NSInteger = 1

    convenience init(stateArr : [HC_consultArrModel], sourceArr : [[HC_consultViewmodel]], status : String, pageNo : NSInteger) {
        self.init()
        
        dataState = stateArr
        dataSource = sourceArr
        self.status = status
        self.pageNo = pageNo
    }
    
}
