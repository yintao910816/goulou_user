//
//  PayOrderViewController.swift
//  aileyun
//
//  Created by sw on 12/04/2019.
//  Copyright © 2019 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class PayOrderViewController: BaseViewController {

    @IBOutlet weak var priceOutlet: UILabel!
    @IBOutlet weak var detailOutlet: UILabel!
    
    var payModelInfo: PreOrderInfoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "支付状态"
        priceOutlet.text = payModelInfo.price
        detailOutlet.text = payModelInfo.info
    }

    @IBAction func actions(_ sender: UIButton) {
        SVProgressHUD.show()
        let model = payModelInfo.orderPayconfigs.first(where: { $0.payName == "支付宝" })
        HttpRequestManager.shareIntance.prePay(orderId: payModelInfo.orderId, payCode: model?.payCode ?? "") { [weak self] data in
            if let preOrderString = data.0 {
                AlipaySDK.defaultService()?.payOrder(preOrderString, fromScheme: kScheme, callback: { [weak self] resultDic in
                    HCPrint(message: resultDic)
                    let resultS = resultDic?["resultStatus"] as! String
                    
                    switch resultS {
                    case "4000":
                        HCShowError(info: "订单支付失败")
                    case "6001":
                        HCShowError(info: "用户中途取消")
                    case "6002":
                        HCShowError(info: "网络连接出错")
                    case "9000":
//                        let s = resultDic?["result"] as! String
//                        do{
//                            let dic = try JSONSerialization.jsonObject(with: s.data(using: .utf8)!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String : Any]
//                            let tempDic = dic["alipay_trade_app_pay_response"] as! [String : Any]
//                            let tradeNo = tempDic["out_trade_no"] as! String
//                            //支付成功  发送通知
//
//                            let not = Notification.init(name: NSNotification.Name.init(ALIPAY_SUCCESS), object: nil, userInfo: ["tradeNo" : tradeNo])
//                            self?.checkAlipayResult(note: not)
//                        }
//                        catch{}
                        guard let strongSelf = self else { return }
                        let queryVC = QueryPayViewController.init(nibName: "QueryPayViewController", bundle: Bundle.main)
                        queryVC.payModelInfo = strongSelf.payModelInfo
                        strongSelf.navigationController?.pushViewController(queryVC, animated: true)
                    default:
                        HCShowError(info: "nothing")
                    }
                })
            }else {
                SVProgressHUD.showError(withStatus: data.1)
            }
        }
    }
    
    func checkAlipayResult(note : Notification){
        SVProgressHUD.show(withStatus: "正在查询支付结果...")
        
        let tradeNo = note.userInfo?["tradeNo"] as! String
        HttpRequestManager.shareIntance.checkAlipayResult(tradeNo: tradeNo) { (success, msg) in
            if success == true {
                HCShowInfo(info: msg)
                self.navigationController?.pushViewController(ConsultRecordViewController(), animated: true)
            }else{
                HCShowError(info: msg)
            }
        }
    }
}
