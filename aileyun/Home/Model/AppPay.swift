//
//  AppPay.swift
//  aileyun
//
//  Created by sw on 10/04/2019.
//  Copyright © 2019 huchuang. All rights reserved.
//

import Foundation

class AppointInfoModel: HJModel {
    
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
    var registerFee: String = ""
    
    var hos_no: String = ""
    var rg_HIS_PatientID: String = ""
}

import HandyJSON
class PreOrderInfoModel: HandyJSON {
//    var orderId: String = ""
//    var orderPayconfigs: [OrderPayconfigsModel] = []
//    var price: String = "0"

    var rcptStreamNo: String = ""
    var payMethodList: [OrderPayconfigsModel] = []
    var totalFee: NSNumber = NSNumber.init(value: 0)
    
    var info: String  = ""
    // 点h5上支付按钮，h5传过来的orderId
    var appointId: String = ""
    // 显示在界面上的价格
    var showTotleFee: String = ""

    required init() { }
}

class OrderPayconfigsModel: HandyJSON {
    
    // 02-支付宝
    var itemMethod: String = "02";
    
    required init() { }
}
