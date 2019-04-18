//
//  BaseNavigationController.swift
//  aileyun
//
//  Created by huchuang on 2017/7/6.
//  Copyright © 2017年 huchuang. All rights reserved.
//

import UIKit

class BaseNavigationController: UINavigationController {
    
    override var childViewControllerForStatusBarStyle: UIViewController?{
        get {
            return self.topViewController
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationBar.shadowImage = UIImage()
        
        self.navigationController?.navigationBar.tintColor = UIColor.white
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]

        //禁用系统原先的侧滑返回功能
        self.interactivePopGestureRecognizer!.isEnabled = false
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if childViewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "返回灰"), style: .plain, target: self, action: #selector(popToParent))
            let target = self.interactivePopGestureRecognizer!.delegate
            let pan = UIPanGestureRecognizer(target:target,
                                             action:Selector("handleNavigationTransition:"))
            viewController.view.addGestureRecognizer(pan)
        }
        super.pushViewController(viewController, animated: true)
    }
}

extension BaseNavigationController {
    @objc fileprivate func popToParent() {
        HttpClient.shareIntance.cancelAllRequest()
        popViewController(animated: true)
    }
}

//extension BaseNavigationController: UINavigationBarDelegate {
//
//    func navigationBar(_ navigationBar: UINavigationBar, shouldPop item: UINavigationItem) -> Bool {
//        let viewControllersCount = self.viewControllers.count
//
//        if viewControllersCount > 0, let vc = topViewController as? WebViewController {
//            if vc.isPopRoot == true {
//                vc.navigationController?.popToRootViewController(animated: true)
//                return false
//            }
//        }
//
//        return true
//    }
//}

//@objc protocol NavigationCustomBack {
//    
//    @objc optional func shouldPopOnBackButtonPress() -> Bool
//}
//
//extension UIViewController: NavigationCustomBack {
//    
//    func shouldPopOnBackButtonPress() -> Bool { return true }
//}


