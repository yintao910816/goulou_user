//
//  QueryPayViewController.swift
//  aileyun
//
//  Created by sw on 15/04/2019.
//  Copyright © 2019 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD

class QueryPayViewController: BaseViewController {

    @IBOutlet weak var timeCutDownOutlet: UILabel!
    @IBOutlet weak var priceOutlet: UILabel!
    
    private var timer: CountdownTimer!

    
    var payModelInfo: PreOrderInfoModel!
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "支付状态"
        
        timer = CountdownTimer.init(totleCount: 3)
        
        timer.showTextCallBack = { [weak self] value in
            guard let strongSelf = self else { return }
            
            if value == 0 {
                strongSelf.timeCutDownOutlet.text = "请您耐心等待..."
                SVProgressHUD.show()
                HttpRequestManager.shareIntance.queryPay(orderId: strongSelf.payModelInfo.orderId, appointId: strongSelf.payModelInfo.appointId, callBack: { [weak self] data in
                    if data.0 == true {
                        SVProgressHUD.dismiss()
                        self?.push()
                    }else {
                        SVProgressHUD.showError(withStatus: data.1)
                    }
                })
            }else {
                strongSelf.timeCutDownOutlet.text = "\(value)秒..."
            }
        }
        
        timer.timerStar()
    }
    
    private func push() {
        let webVC = WebViewController()
        webVC.isPopRoot = true
        webVC.url = "https://wx.ivfcn.com/imagingRecord"
        navigationController?.pushViewController(webVC, animated: true)
    }

}
