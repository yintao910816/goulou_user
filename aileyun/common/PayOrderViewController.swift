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

    var payModelInfo: PreOrderInfoModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "支付状态"
    }

    @IBAction func actions(_ sender: UIButton) {
        SVProgressHUD.show()
        let model = payModelInfo.orderPayconfigs.first(where: { $0.payName == "支付宝" })
        HttpRequestManager.shareIntance.prePay(orderId: payModelInfo.orderId, payCode: model?.payCode ?? "") { data in
            if let msg = data.1 {
                SVProgressHUD.showError(withStatus: msg)
            }else {
                SVProgressHUD.dismiss()
            }
        }
    }
}
