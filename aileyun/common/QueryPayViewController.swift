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
    
    @IBOutlet weak var payStatusView: UIView!
    @IBOutlet weak var payRemindOutlet: UILabel!
    @IBOutlet weak var payStatusIconOutlet: UIImageView!
    
    private var timer: CountdownTimer!

    private var payStatus: Bool = true
    // 支付完成回调
    var payCallBack: ((Bool)->())?
    
    var payModelInfo: PreOrderInfoModel!
    
    @IBAction func backAction(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
        payCallBack?(payStatus)
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
                    SVProgressHUD.dismiss()
                    if data.0 == true {
                        self?.payStatus = true
                    }else {
                        self?.payRemindOutlet.text = "支付失败"
                        self?.payStatusIconOutlet.image = UIImage.init(named: "pay_failure")
                        
                        self?.payStatus = false
                    }
                    self?.payStatusView.isHidden = false
                })
            }else {
                strongSelf.timeCutDownOutlet.text = "\(value)秒..."
            }
        }
        
        timer.timerStar()
    }
}
