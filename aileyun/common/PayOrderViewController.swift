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
    @IBOutlet weak var topCns: NSLayoutConstraint!
    
    @IBOutlet weak var failureView: UIView!
    @IBOutlet weak var failurePriceOutlet: UILabel!
    
    var payModelInfo: PreOrderInfoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "支付状态"
        priceOutlet.text = "\(payModelInfo.price)元"
        detailOutlet.text = payModelInfo.info
        
        failurePriceOutlet.text = priceOutlet.text
        
        topCns.constant += LayoutSize.fitTopArea
        
        NotificationCenter.default.addObserver(self, selector: #selector(alipaySuccess),
                                               name: NSNotification.Name.init(ALIPAY_SUCCESS),
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(alipayFailure(no:)),
                                               name: NSNotification.Name.init(PAY_FAIL),
                                               object: nil)
    }
    
    @IBAction func actions(_ sender: UIButton) {
        if sender.tag == 200 {
            navigationController?.popViewController(animated: true)
        }else {
            preparePay()
        }
    }
    
    private func preparePay() {
        SVProgressHUD.show()
        
        let model = payModelInfo.orderPayconfigs.first(where: { $0.payName == "支付宝" })
        HttpRequestManager.shareIntance.prePay(orderId: payModelInfo.orderId, payCode: model?.payCode ?? "") { [weak self] data in
            if let preOrderString = data.0 {
                AlipaySDK.defaultService()?.payOrder(preOrderString, fromScheme: kScheme, callback: { [weak self] resultDic in
                    SVProgressHUD.dismiss()
                    let resultS = resultDic?["resultStatus"] as! String
                    switch resultS {
                    case "4000":
                        self?.failureView.isHidden = false
                    case "6001":
//                        HCShowError(info: "您取消了支付")
                        self?.failureView.isHidden = false
                    case "6002":
//                        HCShowError(info: "网络连接出错")
                        self?.failureView.isHidden = false
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
                        
                        queryVC.payCallBack = { statu in
                            if statu == true {
                                strongSelf.push()
                            }else {
                                strongSelf.navigationController?.popViewController(animated: true)
                            }
                        }
                    default:
                        HCShowError(info: "nothing")
                    }
                })
            }else {
                SVProgressHUD.showError(withStatus: data.1)
            }
        }
    }
    
    private func push() {
        let webVC = WebViewController()
        webVC.isPopRoot = true
        webVC.url = "https://wx.ivfcn.com/imagingRecord"
        navigationController?.pushViewController(webVC, animated: true)
    }
    
    @objc private func alipaySuccess() {
        SVProgressHUD.dismiss()
        
        let queryVC = QueryPayViewController.init(nibName: "QueryPayViewController", bundle: Bundle.main)
        queryVC.payModelInfo = payModelInfo
        navigationController?.pushViewController(queryVC, animated: true)
    }
    
    @objc private func alipayFailure(no: Notification) {
        guard let status = no.object as? String else {
            SVProgressHUD.showError(withStatus: "支付失败")
            return
        }
        
        SVProgressHUD.dismiss()
        switch status {
        case "4000":
            failureView.isHidden = false
        case "6001":
//            HCShowError(info: "您取消了支付")
            failureView.isHidden = false
        case "6002":
            failureView.isHidden = false
//            HCShowError(info: "网络连接出错")
        default:
            failureView.isHidden = false
//            HCShowError(info: "未知状态")
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
