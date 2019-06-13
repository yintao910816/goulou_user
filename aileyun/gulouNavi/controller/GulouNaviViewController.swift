//
//  GulouNaviViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/8/10.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import MessageUI

class GulouNaviViewController: UIViewController {
    
    var collectionV : UICollectionView?
    
    let ReuseIdentifier = "ReuseIdentifier"
    
    var placeArr = [PlacePositionModel]() {
        didSet{
            if placeArr.count > 0 {
                widthDic = [NSInteger : CGFloat]()
                collectionV?.reloadData()
            }
        }
    }
    
    var tempArr = ["北院挂号收费处", "北院检验科", "北院门诊药房", "北院输液室", "北院方便门诊", "生殖医学科", "北院不育科", "生殖医学科B超"]
    
    var tempIdArr = ["5000112", "5000116", "5000117", "5000139", "9400026", "9400027", "9400214", "9400028"]
    
    var widthDic = [NSInteger : CGFloat]()
    
    let cellMaxWidth = (SCREEN_WIDTH - 20)/3
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        get{
            return .lightContent
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "院内导航"
        self.view.backgroundColor = kDefaultThemeColor
        
        initUI()
        
        requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.isHidden = false
    }
    
    
    func initUI(){
        
        let backV = UIView.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 64))
        backV.backgroundColor = UIColor.white
        self.view.addSubview(backV)
        
        let mapImgV = UIImageView.init(frame: CGRect.init(x: 0, y: 64, width: SCREEN_WIDTH, height: 200))
        mapImgV.image = UIImage.init(named: "gulouNavi")
        mapImgV.contentMode = .scaleAspectFit
        mapImgV.isUserInteractionEnabled = true
        self.view.addSubview(mapImgV)
        
        mapImgV.backgroundColor = klightGrayColor
        
        let mapL = UILabel()
        mapL.text = "展开地图"
        mapL.textAlignment = NSTextAlignment.center
        mapL.textColor = UIColor.white
        mapL.layer.cornerRadius = 20
        mapL.clipsToBounds = true
        
        let backColor = UIColor.init(white: 0.1, alpha: 0.5)
        mapL.backgroundColor = backColor
        
        mapImgV.addSubview(mapL)
        mapL.snp.updateConstraints {(make) in
            make.center.equalTo(mapImgV)
            make.height.equalTo(40)
            make.width.equalTo(100)
        }
        
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(GulouNaviViewController.showMap))
        mapImgV.addGestureRecognizer(tapG)
        
        let titleL = UILabel()
        titleL.text = "热门搜索"
        self.view.addSubview(titleL)
        titleL.snp.updateConstraints { (make) in
            make.top.equalTo(mapImgV.snp.bottom).offset(20)
            make.left.equalTo(self.view).offset(20)
            make.height.equalTo(20)
        }
        
        let layout = EqualSpaceFlowLayout()
//        layout.minimumInteritemSpacing = CGFloat(KDefaultPadding)
//        layout.minimumLineSpacing = CGFloat(KDefaultPadding)
        layout.scrollDirection = .vertical  
        collectionV = UICollectionView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 100), collectionViewLayout: layout)
        self.view.addSubview(collectionV!)
        collectionV?.snp.updateConstraints { (make) in
            make.top.equalTo(titleL.snp.bottom).offset(14)
            make.right.equalTo(self.view).offset(-5)
            make.left.equalTo(self.view).offset(5)
            make.bottom.equalTo(self.view)
        }
        collectionV?.backgroundColor = UIColor.white
        collectionV?.dataSource = self
        collectionV?.delegate = self
        collectionV?.register(GroupManagerViewCell.self, forCellWithReuseIdentifier: ReuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func requestData(){
        HttpRequestManager.shareIntance.HC_naviList { [unowned self](success, arr)in
            if success == true{
                HCShowInfo(info: "刷新数据成功")
                self.placeArr = arr!
            }else{
                HCShowError(info: "网络异常")
            }
        }
    }

    @objc func showMap(){
        let mapVC = IpsMapViewController.init(mapId: NaviMapId)
        mapVC.locationShareDelegate = self
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
    
    func naviToPlace(name : String, targetId : String){
        let naviVC = IpsMapViewController.init(mapId: NaviMapId, targetName: name, targetId: targetId)
        naviVC.locationShareDelegate = self
        self.navigationController?.pushViewController(naviVC, animated: true)
    }
    
}

extension GulouNaviViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if placeArr.count > 0 {
            return placeArr.count
        }else{
            return tempArr.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReuseIdentifier, for: indexPath) as! GroupManagerViewCell
        if placeArr.count > 0 {
            cell.contentS = placeArr[indexPath.row].name
        }else{
            cell.contentS = tempArr[indexPath.row]
        }
        return  cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if widthDic[indexPath.row] == nil{
            let tempCell = GroupManagerViewCell()
            if placeArr.count > 0 {
                tempCell.contentS = placeArr[indexPath.row].name
            }else{
                tempCell.contentS = tempArr[indexPath.row]
            }

            let width = tempCell.finalWidth! > cellMaxWidth ? cellMaxWidth : tempCell.finalWidth
            widthDic[indexPath.row] = width
            return CGSize.init(width: width!, height: 30)
        }else{
            return CGSize.init(width: widthDic[indexPath.row]!, height: 30)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if placeArr.count > 0 {
            naviToPlace(name: placeArr[indexPath.row].name!, targetId: placeArr[indexPath.row].code!)
        }else{
            naviToPlace(name: tempArr[indexPath.row], targetId: tempIdArr[indexPath.row])
        }
    }
}

extension GulouNaviViewController : IpsLocationShareProtocol {
    func ipsLocationShare(_ type: IpsShareType, title: String!, desc: String!, url: String!, thumbImage image: UIImage!) {
        switch type {
        case .weChat:
            shareToWechat(title: title, desc: desc, url: url, thumbImage: image)
        case .QQ:
            shareToQQ(title: title, desc: desc, url: url, thumbImage: image)
        case .SMS:
            shareToSMS(url: url)
        default:
            HCPrint(message: "unknown")
        }
    }
    
    func shareToSMS(url: String){
        if MFMessageComposeViewController.canSendText() {
            let smsVC = MFMessageComposeViewController.init()
            smsVC.body = url
            smsVC.messageComposeDelegate = self
            
            let rootVC = UIApplication.shared.windows.first?.rootViewController!
            rootVC?.present(smsVC, animated: true, completion: nil)
        }
    }
    
    func shareToWechat(title : String, desc : String, url : String, thumbImage : UIImage){
        let message = WXMediaMessage.init()
        message.title = title
        message.description = desc
        message.setThumbImage(thumbImage)
        
        let webpageObj = WXWebpageObject.init()
        webpageObj.webpageUrl = url
        
        message.mediaObject = webpageObj
        
        let req = SendMessageToWXReq.init()
        req.bText = false
        req.message = message
        req.scene = Int32(WXSceneSession.rawValue)
        
        WXApi.send(req)
    }
    
    func shareToQQ(title : String, desc : String, url : String, thumbImage : UIImage){
        
        let url = URL.init(string: url)!
        let imgData = thumbImage.pngData()!
        let newsObj = QQApiNewsObject.init(url: url, title: title, description: desc, previewImageData: imgData, targetContentType: QQApiURLTargetTypeNews)!
        let req = SendMessageToQQReq.init(content: newsObj)
    
        let sent = QQApiInterface.send(req)
        
        handleSendResult(sendResult: sent)
    }
    
    func handleSendResult(sendResult:QQApiSendResultCode){
        var message = ""
        
        switch sendResult {
        case EQQAPIAPPNOTREGISTED:
            message = "App未注册"
        case EQQAPIMESSAGECONTENTINVALID, EQQAPIMESSAGECONTENTNULL,
             EQQAPIMESSAGETYPEINVALID:
            message = "发送参数错误"
        case EQQAPIQQNOTINSTALLED:
            message = "QQ未安装"
        case EQQAPIQQNOTSUPPORTAPI:
            message = "API接口不支持"
        case EQQAPISENDFAILD:
            message = "发送失败"
        case EQQAPIQZONENOTSUPPORTTEXT:
            message = "空间分享不支持纯文本分享，请使用图文分享"
        case EQQAPIQZONENOTSUPPORTIMAGE:
            message = "空间分享不支持纯图片分享，请使用图文分享"
        default:
            message = "发送成功"
        }
        
        HCShowInfo(info: message)
    }

}

extension GulouNaviViewController : MFMessageComposeViewControllerDelegate{
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        if result == MessageComposeResult.cancelled {
            let rootVC = UIApplication.shared.windows.first?.rootViewController!
            rootVC?.dismiss(animated: true, completion: nil)
        }
    }
}
