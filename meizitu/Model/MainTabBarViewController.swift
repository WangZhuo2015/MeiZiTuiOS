////
////  MainTabBarViewController.swift
////  meizitu
////
////  Created by WangZhuo on 24/03/2017.
////  Copyright © 2017 SherryTeam. All rights reserved.
////
//
//import UIKit
//
//class MainTabBarViewController: UITabBarController {
//
//    var timer: Timer?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        initIAP()
//        loadAllViewController()
//        if AppManager.appUseCountUp() > 5 && !AppManager.isEvaluated(){
//            reviewThisApp()
//        }
//        if User.sharedUser.userName == nil{
//            self.selectedIndex = (self.viewControllers?.count)! - 1
//        }
//        timer = Timer.scheduledTimer(timeInterval: 1.0*30, target: self, selector: #selector(self.checkNewMessage), userInfo: nil, repeats: true)
//        // Do any additional setup after loading the view.
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        //timer.fireDate = NSDate.distantFuture()
//        timer?.fireDate = Date.distantPast
//        timer!.fire()
//    }
//    
//    deinit{
//        timer?.invalidate()
//        timer = nil
//    }
//    
//    func loadAllViewController(){
//        //获取每个故事版的根视图控制器
//        let matchRootViewController = UIStoryboard(name: "Match", bundle: nil).instantiateInitialViewController() as! UINavigationController
//        
//        let heroRootViewController = UIStoryboard(name: "Hero", bundle: nil).instantiateInitialViewController() as! UINavigationController
//
//        
//        //设置tabbar被选中时的字体颜色
//        let selectedText = [NSForegroundColorAttributeName:UIColor.white]
//        matchRootViewController.tabBarItem.setTitleTextAttributes(selectedText, for: UIControlState.selected)
//        heroRootViewController.tabBarItem.setTitleTextAttributes(selectedText, for: UIControlState.selected)
//        equipmentRootViewController.tabBarItem.setTitleTextAttributes(selectedText, for: UIControlState.selected)
//        personalInfoRootViewController.tabBarItem.setTitleTextAttributes(selectedText, for: UIControlState.selected)
//        
//        //        设置 tabBarItem的一些属性
//        //1
//        
//        matchRootViewController.tabBarItem.title = "战绩"
//        matchRootViewController.tabBarItem.image = UIImage(named: "magical_scroll")
//        matchRootViewController.tabBarItem.selectedImage = UIImage(named: "magical_scroll_filled")
//        
//        //2
//        personalInfoRootViewController.tabBarItem.title = "个人"
//        personalInfoRootViewController.tabBarItem.image = UIImage(named: "user_male_circle")
//        personalInfoRootViewController.tabBarItem.selectedImage = UIImage(named: "user_male_circle_filled")
//        
//        //4
//        heroRootViewController.tabBarItem.title = "英雄"
//        heroRootViewController.tabBarItem.image = UIImage(named: "armored_helmet")
//        heroRootViewController.tabBarItem.selectedImage = UIImage(named: "armored_helmet_filled")
//        
//        
//        equipmentRootViewController.tabBarItem.title = "装备"
//        equipmentRootViewController.tabBarItem.image = UIImage(named: "armored_boot")
//        equipmentRootViewController.tabBarItem.selectedImage = UIImage(named: "armored_boot_filled")
//        
//        
//        dataAnalysisRootViewController.tabBarItem.title = "数据"
//        dataAnalysisRootViewController.tabBarItem.image = UIImage(named: "analyse")
//        dataAnalysisRootViewController.tabBarItem.selectedImage = UIImage(named: "analyse_filled")
//        self.viewControllers = [
//            matchRootViewController,
//            heroRootViewController,
//            equipmentRootViewController,
//            dataAnalysisRootViewController,
//            personalInfoRootViewController
//        ]
//        
//        self.selectedIndex = 0
//    }
//    
//    
//    
//    func reviewThisApp(){
//        let alert = UIAlertController(title: "快来评价吧ヽ(･ω･｡)ﾉ", message: "喜欢这款App吗?来评价一下吧!", preferredStyle: .alert)
//        let goToEvaluate = UIAlertAction(title: "去评价*~(￣▽￣)~*", style: .default) { (action) in
//            self.evaluate()
//        }
//        let refuse = UIAlertAction(title: "残忍地拒绝( •̥́ ˍ •̀)", style: .default) { (action) in
//            AppManager.evaluated()
//        }
//        let cancel = UIAlertAction(title: "以后再说", style: .cancel,handler: nil)
//        alert.addAction(goToEvaluate)
//        alert.addAction(refuse)
//        alert.addAction(cancel)
//        present(alert, animated: true, completion: nil)
//    }
//    
//    
//    
//    func evaluate(){
//        //初始化控制器
//        let storeProductViewContorller = SKStoreProductViewController()
//        //设置代理请求为当前控制器本身
//        storeProductViewContorller.delegate = self
//        //加载一个新的视图展示
//        storeProductViewContorller.loadProduct(withParameters: [SKStoreProductParameterITunesItemIdentifier:"1114391519"]) { (result,error) in
//            if error != nil{
//                print(error ?? "")
//            }else{
//                //模态弹出appstore
//                self.present(storeProductViewContorller, animated: true, completion: nil)
//            }
//        }
//    }
//    
//    //检查反馈新回复
//    func checkNewMessage(){
//        LCUserFeedbackAgent.sharedInstance().countUnreadFeedbackThreads { (number, error) in
//            guard error == nil && number != 0 else{
//                // 网络出错了，不设置红点
//                ((self.viewControllers?.last as! UINavigationController).viewControllers.first as! PersonalInfoViewController).removeNewMessage()
//                self.viewControllers?.last?.tabBarItem.badgeValue = nil
//                return
//            }
//            self.viewControllers?.last?.tabBarItem.badgeValue = "\(number)"
//            ((self.viewControllers?.last as! UINavigationController).viewControllers.first as! PersonalInfoViewController).recieveNewMessage()
//        }
//    }
//    
//    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
//        loadAllViewController()
//        AppManager.evaluated()
//    }}
