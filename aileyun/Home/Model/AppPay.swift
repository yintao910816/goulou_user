//
//  AppPay.swift
//  aileyun
//
//  Created by sw on 10/04/2019.
//  Copyright © 2019 huchuang. All rights reserved.
//

import Foundation

class AppointInfoModel: NSObject {
        
    var additionalFee: String = ""
    var card_no: String = ""
    var charge_price: String = ""
    var clinic_flag: String = ""
    var depart_code: String = ""
    var depart_name: String = ""
    var diagnoseFee: String = ""
    var doctor_name: String = ""
    var doctor_sn: String = ""
    var gh_date: String = ""
    var gh_sequence: String = ""
    var his_order_id: String = ""
    var mobile: String = ""
    var name: String = ""
    var order_id: String = ""
    var patient_id: String = ""
    var record_sn: String = ""
    var register_sn: String = ""
    var remark: String = ""
    var request_date: String = ""
    var social_no: String = ""
    var time_code: String = ""
    var time_name: String = ""
    var totalFee: String = ""
    var unit_name: String = ""
    var unit_type: String = ""
    var visit_flag: String = ""
    var wb: String = ""
    
    // MARK:- 构造函数
    init(_ dict : [String : Any]) {
        super.init()
        setValuesForKeys(dict)
    }
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
