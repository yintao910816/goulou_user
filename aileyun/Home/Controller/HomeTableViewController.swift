//
//  HomeTableViewController.swift
//  aileyun
//
//  Created by huchuang on 2017/6/16.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class HomeTableViewController: BaseViewController {
    
//    let searchBtn = homeSearchButton()
    
    var expertGuidS : String?
    
    var classOnline : String?
    
    let messageBtn = badgeButton.init(frame: CGRect.init(x: 0, y: 0, width: 30, height: 30))
    
    lazy var naviBackV : UIView = {
        let space = AppDelegate.shareIntance.space
        let b = UIView.init(frame: CGRect.init(x: 0, y: space.topSpace, width: SCREEN_WIDTH, height: 44))
        let glassV = UIToolbar.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 44))
        b.addSubview(glassV)
        return b
    }()
    
    lazy var noticeV : NoticeView = {
        let l = NoticeView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: GoodnewsHeight))
        return l
    }()

    lazy var containerV : UIView = {
        let c = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: ScrollImageVHeight + FuncSizeWidth + SelectViewHeight + ViewGap * 2 + KnownledgeViewHeight))
        c.backgroundColor = kdivisionColor
        c.clipsToBounds = true
        return c
    }()
    
    
    lazy var picScrollV : topView = {
        let t = topView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: ScrollImageVHeight))
        t.naviCtl = self.navigationController
        t.autoScrollTimeInterval = 3
        return t
    }()
    
    var howManyLayer : CGFloat? {
        didSet{
            HCPrint(message: howManyLayer)
            refreshView(layer: howManyLayer!)
        }
    }
    
    lazy var functionV : HomeFunctionView = {
        let f = HomeFunctionView.init(frame: CGRect.init(x: 0, y: ScrollImageVHeight, width: SCREEN_WIDTH, height: FuncSizeWidth))
        f.naviVC = self.navigationController
        return f
    }()
    
    lazy var selectV : selectView = {
        let s = selectView.init(frame: CGRect.init(x: 0, y: ScrollImageVHeight + FuncSizeWidth + ViewGap, width: SCREEN_WIDTH, height: SelectViewHeight))
        return s
    }()
    
    lazy var gooodnewsV : GoodNewsView = {
        let g = GoodNewsView.init(frame: CGRect.init(x: 0, y: ScrollImageVHeight + FuncSizeWidth + ViewGap * 2 + SelectViewHeight, width: SCREEN_WIDTH, height: GoodnewsHeight))
        return g
    }()
    
    lazy var knowledgeVC : KnowledgeViewController = {
        let k = KnowledgeViewController()
        k.view.frame = CGRect.init(x: 0, y: ScrollImageVHeight + FuncSizeWidth + SelectViewHeight + ViewGap * 3 + GoodnewsHeight, width: SCREEN_WIDTH, height: KnownledgeViewHeight)
        k.naviVC = self.navigationController
        return k
    }()
    
    let reuseIdentifier = "reuseIdentifier"
    
    lazy var tableV : UITableView = {
        let space = AppDelegate.shareIntance.space
        let t = UITableView.init(frame: CGRect.init(x: 0, y: space.topSpace, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - space.topSpace - space.bottomSpace - 48))
        t.rowHeight = UITableView.automaticDimension
        t.estimatedRowHeight = 300
//        t.dataSource = self
//        t.delegate = self
        return t
    }()
    
    
//    var circleArr : [HCCircleModel]?{
//        didSet{
//            tableV.reloadData()
//        }
//    }

    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        get {
            return .default
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        markUnreadNum()
        
        initUI()
        
        //设置数据
//        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_getHrefH5URL(){[weak self](success, msg) in
            if success == false{
                HCPrint(message: "获取配置失败，从本地加载中")
                
                if let bbsFgiUrl = UserDefaults.standard.value(forKey: kbbsFgiUrl) {
                    UserManager.shareIntance.HCUserInfo?.bbsFgiUrl = bbsFgiUrl as! String
                }
                
                if let getBbsTokenUrl = UserDefaults.standard.value(forKey: kgetBbsTokenUrl) {
                    UserManager.shareIntance.HCUserInfo?.getBbsTokenUrl = getBbsTokenUrl as! String
                }
                
                if let findLastestTopics = UserDefaults.standard.value(forKey: kfindLastestTopics) {
                    UserManager.shareIntance.HCUserInfo?.findLastestTopics = findLastestTopics as! String
                }
            }
            
            if let bbsToken = UserDefaults.standard.value(forKey: kBBSToken) {
                UserManager.shareIntance.HCUserInfo?.BBSToken = bbsToken as! String
            }else{
                HttpRequestManager.shareIntance.HC_getBBSToken {(success, BBSToken) in
                }
            }
            
            self?.tableV.mj_header.beginRefreshing()
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.markUnreadNum), name: NSNotification.Name.init(CLEAR_MSG_STATUS), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeTableViewController.bindSuccessPushWeb(no:)), name: NSNotification.Name.init(bindSuccessToPush), object: nil)
    }
    
    @objc private func bindSuccessPushWeb(no: Notification) {
        if let webURL = no.object as? String {
            let webVC = WebViewController()
            webVC.isPopRoot = true
            webVC.url = webURL
            navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    
    func initUI(){
        setupNavibar()
        
        self.view.addSubview(tableV)
//        tableV.register(treasuryTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
        
        tableV.contentInset = UIEdgeInsets.init(top: -44, left: 0, bottom: 0, right: 0)
    
        containerV.addSubview(picScrollV)
        containerV.addSubview(functionV)
        containerV.addSubview(noticeV)
        containerV.addSubview(selectV)
        containerV.addSubview(gooodnewsV)
        containerV.addSubview(knowledgeVC.view)
        
        tableV.tableHeaderView = containerV
        
        //导航栏底色
        self.view.insertSubview(naviBackV, aboveSubview: tableV)
        
        //诊疗流程
        selectV.guideBtn.addTarget(self, action: #selector(HomeTableViewController.treatFlow), for: .touchUpInside)
        //暂时去之前的论坛
        selectV.classroomBtn.addTarget(self, action: #selector(HomeTableViewController.groupDiscuss), for: .touchUpInside)
        
        let headRefresher = MJRefreshNormalHeader.init(refreshingTarget: self, refreshingAction: #selector(HomeTableViewController.requestData))
        headRefresher?.setTitle("下拉刷新数据", for: .idle)
        headRefresher?.setTitle("释放刷新数据", for: .pulling)
        headRefresher?.setTitle("正在请求数据", for: .refreshing)

        tableV.mj_header = headRefresher
    }
    
    func setupNavibar(){
        self.navigationItem.title = "首页"
        
        let contV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 44, height: 44))
        contV.isUserInteractionEnabled = true
        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(HomeTableViewController.qrcodeVC))
        contV.addGestureRecognizer(tapG)
        
        let qrcodeIV = UIImageView.init(frame: CGRect.init(x: 6, y: 10, width: 22, height: 22))
        qrcodeIV.image = UIImage.init(named: "qrcodeBlack")
        contV.addSubview(qrcodeIV)
        
        let leftItem = UIBarButtonItem.init(customView: contV)
        self.navigationItem.leftBarButtonItem = leftItem
        
        messageBtn.addTarget(self, action: #selector(HomeTableViewController.messageAction), for: .touchUpInside)
        let rightItem = UIBarButtonItem.init(customView: messageBtn)
        self.navigationItem.rightBarButtonItem = rightItem
    }
    
    @objc func messageAction(){
        self.navigationController?.pushViewController(MessageViewController(), animated: true)
    }
    
    @objc func goodNewsDetail(){
        SVProgressHUD.show()
        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "GOOD_NEWS_2017") { [weak self](success, info) in
            if success == true {
                SVProgressHUD.dismiss()
                HCPrint(message: info)
                let webVC = WebViewController()
                webVC.url = info
                self?.navigationController?.pushViewController(webVC, animated: true)
            }else{
                HCShowError(info: info)
            }
        }
    }
    
    @objc func noticeDetail(){
        SVProgressHUD.show()
        let notIdS = String.init(format: "%d", (noticeV.modelArr![noticeV.row].id!.intValue))
        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "NOTICE_DETAIL_URL", callback: { [weak self](success, urlS) in
            SVProgressHUD.dismiss()
            if success == true{
                let webVC = WebViewController()
                webVC.url = urlS + "?noticeId=" + notIdS
                self?.navigationController?.pushViewController(webVC, animated: true)
            }else{
                HCShowError(info: urlS)
            }
        })
    }
    
    @objc func qrcodeVC(){
        self.navigationController?.pushViewController(QRCodeScanViewController(), animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refreshView(layer : CGFloat){
        functionV.frame = CGRect.init(x: 0, y: ScrollImageVHeight, width: SCREEN_WIDTH, height: FuncSizeWidth * layer)
        noticeV.frame = CGRect.init(x: 0, y: ScrollImageVHeight + FuncSizeWidth * layer + ViewGap, width: SCREEN_WIDTH, height: GoodnewsHeight)
        selectV.frame = CGRect.init(x: 0, y: ScrollImageVHeight + FuncSizeWidth * layer + ViewGap * 2 + GoodnewsHeight, width: SCREEN_WIDTH, height: SelectViewHeight)
        gooodnewsV.frame = CGRect.init(x: 0, y: ScrollImageVHeight + FuncSizeWidth * layer + ViewGap * 3 + SelectViewHeight + GoodnewsHeight, width: SCREEN_WIDTH, height: GoodnewsHeight)
        knowledgeVC.view.frame = CGRect.init(x: 0, y: ScrollImageVHeight + FuncSizeWidth * layer + SelectViewHeight + GoodnewsHeight * 2 + ViewGap * 4, width: SCREEN_WIDTH, height: KnownledgeViewHeight)
        
        let headV = tableV.tableHeaderView
        headV?.frame = CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: ScrollImageVHeight + FuncSizeWidth * layer + SelectViewHeight + GoodnewsHeight * 2 + ViewGap * 4 + KnownledgeViewHeight)
        tableV.tableHeaderView = headV
    }
    
    
    @objc func markUnreadNum(){
        HttpRequestManager.shareIntance.HC_unreadNum { [weak self](model, msg) in
            if let m = model {
                self?.messageBtn.number = m.unread?.intValue
            }
        }
    }
    
    @objc func requestData(){
        // 防止401导致未处理
        tableV.mj_header.endRefreshing()
        
        SVProgressHUD.show()
        
        markUnreadNum()
        
        let group = DispatchGroup.init()
        
        group.enter()
        HttpRequestManager.shareIntance.HC_banner { [weak self](success, arr, msg) in
            if success == true{
                self?.picScrollV.dataArr = arr
            }else{
                HCShowError(info: msg)
            }
            group.leave()
        }
        
        group.enter()
        HttpRequestManager.shareIntance.HC_functionList { [weak self](success, arr, msg) in
            if success == true{
                self?.functionV.modelArr = arr
                self?.howManyLayer = CGFloat(((arr?.count)! - 1) / 4 + 1)
            }else{
                HCShowError(info: msg)
            }
            group.leave()
        }
        
        group.enter()
        // 今日知识
        let hospitalId = UserManager.shareIntance.HCUserInfo?.hospitalId?.intValue ?? 0
        HttpRequestManager.shareIntance.HC_knowledgeList(hospitalId: hospitalId) { [weak self](success, arr) in
            if success == true {
                self?.knowledgeVC.modelArr = arr
            }else{
                HCShowError(info: "网络错误")
            }
            group.leave()
        }
        
        group.enter()
        // H5地址
        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "EXPERT_GUIDANCE_2017") { [weak self](success, info) in
            if success == true {
                self?.expertGuidS = info
            }else{
                HCShowError(info: info)
            }
            group.leave()
        }
        
        group.enter()
        // H5地址
        HttpRequestManager.shareIntance.HC_getH5URL(keyCode: "CLASS_ONLINE_2017") { [weak self](success, info) in
            if success == true {
                self?.classOnline = info
            }else{
                HCShowError(info: info)
            }
            group.leave()
        }
        
        //公告
        group.enter()
        HttpRequestManager.shareIntance.HC_notice { [weak self](arr, s) in
            if let modelArr = arr{
                self?.noticeV.modelArr = modelArr
                //添加点击事件
                let tapG = UITapGestureRecognizer.init(target: self, action: #selector(HomeTableViewController.noticeDetail))
                self?.noticeV.addGestureRecognizer(tapG)
            }else{
            }
            group.leave()
        }
        
        group.enter()
        HttpRequestManager.shareIntance.HC_goodnews { [weak self](modelArr, msg) in
            if let arr = modelArr{
                self?.gooodnewsV.modelArr = arr
                //添加点击事件
                let tapG = UITapGestureRecognizer.init(target: self, action: #selector(HomeTableViewController.goodNewsDetail))
                self?.gooodnewsV.addGestureRecognizer(tapG)
            }else{
            }
            group.leave()
        }
        
//        group.enter()
//        HttpRequestManager.shareIntance.HC_findLastestTopics(callback: { [weak self](success, arr, msg) in
//            if success == true {
//                self?.circleArr = arr
//            }else{
//                HCPrint(message: msg)
//            }
//            group.leave()
//        })
        
        group.notify(queue: DispatchQueue.main) {
            SVProgressHUD.dismiss()
        }
        
    }
    
}

extension HomeTableViewController : UIScrollViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//
//        let offsetY = scrollView.contentOffset.y
//
//        if offsetY > 0 {
//            let c = offsetY / 100
//            if c < 1 {
//            }else{
//            }
//        }
//
//    }
}

extension HomeTableViewController {
    
    //专家指导
    @objc func treatFlow(){
        guard let s = expertGuidS else {return}
        if s == "EXPERT_GUIDANCE_2017" {
            let tabVC = UIApplication.shared.keyWindow?.rootViewController as! MainTabBarController
            tabVC.selectedIndex = 1
        }else{
            let webVC = WebViewController()
            webVC.url = expertGuidS!
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    //在线课堂
    @objc func groupDiscuss(){
        guard classOnline != nil else {return}
        if classOnline  == "#" {
            HCShowInfo(info: "功能暂不开放")
        }else{
            let webVC = WebViewController()
            webVC.url = classOnline!
            self.navigationController?.pushViewController(webVC, animated: true)
        }
    }
    
    @objc func gotoGroup(){
        let rootVC = UIApplication.shared.keyWindow?.rootViewController as! UITabBarController
        rootVC.selectedIndex = 3
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            let not = Notification.init(name: NSNotification.Name.init(GO_TO_GROUP), object: nil, userInfo: nil)
            NotificationCenter.default.post(not)
        }
    }
}

//extension HomeTableViewController : UITableViewDataSource, UITableViewDelegate {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return circleArr?.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! treasuryTableViewCell
//        cell.model = circleArr?[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        let contV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 50))
//        contV.backgroundColor = UIColor.white
//
//        let diviV = UIView.init(frame: CGRect.init(x: 0, y: 0, width: SCREEN_WIDTH, height: 3))
//        diviV.backgroundColor = kdivisionColor
//        contV.addSubview(diviV)
//
//        let knowledgeIV = UIImageView()
//        knowledgeIV.image = UIImage.init(named: "标题")
//        knowledgeIV.contentMode = .scaleAspectFit
//        contV.addSubview(knowledgeIV)
//        knowledgeIV.snp.updateConstraints { (make) in
//            make.left.equalTo(contV).offset(20)
//            make.top.equalTo(contV).offset(20)
//            make.width.height.equalTo(20)
//        }
//
//        let knowledgeL = UILabel()
//        knowledgeL.text = "好孕圈子"
//        knowledgeL.font = UIFont.init(name: kReguleFont, size: 16)
//        knowledgeL.textColor = kTextColor
//        contV.addSubview(knowledgeL)
//        knowledgeL.snp.updateConstraints { (make) in
//            make.left.equalTo(knowledgeIV.snp.right).offset(4)
//            make.centerY.equalTo(knowledgeIV)
//        }
//
//        let imgV = UIImageView()
//        imgV.image = UIImage.init(named: "箭头")
//        imgV.contentMode = .right
//        contV.addSubview(imgV)
//        imgV.snp.updateConstraints { (make) in
//            make.right.equalTo(contV).offset(-20)
//            make.centerY.equalTo(knowledgeIV)
//            make.width.height.equalTo(20)
//        }
//
//        let divisionV = UIView()
//        divisionV.backgroundColor = kdivisionColor
//        contV.addSubview(divisionV)
//        divisionV.snp.updateConstraints { (make) in
//            make.left.right.bottom.equalTo(contV)
//            make.height.equalTo(1)
//        }
//
//        let tapG = UITapGestureRecognizer.init(target: self, action: #selector(HomeTableViewController.gotoGroup))
//        contV.addGestureRecognizer(tapG)
//
//        return contV
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 50
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        if let id = circleArr?[indexPath.row].id {
//            guard let bbsToken = UserManager.shareIntance.HCUserInfo?.BBSToken else{
//                HCShowError(info: "没有bbsToken")
//                return
//            }
//            guard let bbsRootUrl = UserManager.shareIntance.HCUserInfo?.bbsFgiUrl else{
//                HCShowError(info: "没有bbsRootUrl")
//                return
//            }
//            let webVC = WebViewController()
//            webVC.url = bbsRootUrl + GROUP_DETAIL_URL + "?bbsToken=" + bbsToken + "&id=" + id
//            self.navigationController?.pushViewController(webVC, animated: true)
//        }
//    }
//}
