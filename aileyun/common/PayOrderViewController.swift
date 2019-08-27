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
    
    private var payStatue: Bool = true
    private var needChangeVC: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "支付状态"
        priceOutlet.text = "\(payModelInfo.showTotleFee)元"
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if needChangeVC == true {
            if payStatue == true
            {
                push()
            }else {
                navigationController?.popViewController(animated: true)
            }
        }
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
        
        let model = payModelInfo.payMethodList.first(where: { $0.itemMethod == "02" })
        HttpRequestManager.shareIntance.prePay(orderId: payModelInfo.rcptStreamNo, payCode:  model?.itemMethod ?? "02") { [weak self] data in
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
                            strongSelf.needChangeVC = true
                            strongSelf.payStatue = statu
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
        webVC.isIgoreWebBack = true
        webVC.url = "https://wx.ivfcn.com/imagingRecord"
        navigationController?.pushViewController(webVC, animated: true)
        
        needChangeVC = false
    }
    
    @objc private func alipaySuccess() {
        SVProgressHUD.dismiss()
        
        let queryVC = QueryPayViewController.init(nibName: "QueryPayViewController", bundle: Bundle.main)
        queryVC.payModelInfo = payModelInfo
        navigationController?.pushViewController(queryVC, animated: true)
        
        queryVC.payCallBack = { [weak self] statu in
            self?.needChangeVC = true
            self?.payStatue = statu
        }
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
