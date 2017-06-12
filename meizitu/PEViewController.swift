//
//  PEViewController.swift
//  meizitu
//
//  Created by WangZhuo on 06/06/2017.
//  Copyright © 2017 SherryTeam. All rights reserved.
//

import UIKit
import SnapKit
class PEViewController: UIViewController,AutoAnswerDelegate {
    var model = Model.model
    
    @IBOutlet weak var begin : UIButton!
    @IBOutlet weak var passWordText : UITextField!
    @IBOutlet weak var logArea : UITextView!
    @IBOutlet weak var uidText : UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        model.delegate = self
        view.addSubview(begin)
        view.addSubview(passWordText)
        view.addSubview(logArea)
        view.addSubview(uidText)
        // Do any additional setup after loading the view.
        uidText.placeholder = "账号"
//        uidText.snp.makeConstraints { (make) in
//            make.top.equalTo(view.snp.top).of
//            make.left.equalTo(view.snp.left)
//            make.right.equalTo(view.snp.right)
//        }
        passWordText.placeholder = "密码"
//        passWordText.snp.makeConstraints { (make) in
//            make.top.equalTo(uidText)
//            make.left.equalTo(view)
//            make.right.equalTo(view)
//        }
        begin.titleLabel?.text = "开始答题"
//        begin.snp.makeConstraints { (make) in
//            make.top.equalTo(uidText)
//            make.left.equalTo(view)
//            make.right.equalTo(view)
//            make.height.equalTo(30)
//        }
        begin.addTarget(self, action: Selector("start"), for: .touchUpInside)
        
//        logArea.snp.makeConstraints { (make) in
//            make.top.equalTo(begin)
//            make.left.equalTo(view)
//            make.right.equalTo(view)
//            make.bottom.equalTo(view)
//        }

        

    }
    
    func start(){
        model.delay = false//shouldDelay.state == 0
        let uid = uidText.text!
        let password = passWordText.text!
        Model.model.login(uid, password: password) {
            Model.model.getPaper(User.sharedUser.uid, token: User.sharedUser.token, completeHandle: { (data) in
                Model.model.startExam(User.sharedUser.uid, token: User.sharedUser.token, id: Model.model.examId, paperID: Model.model.paperID, completeHandle: { (data) in
                    Model.model.autoAnswer(User.sharedUser.token, uid: User.sharedUser.uid, paperID: Model.model.paperID, questionData: data)
                })
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    var lines = 0
    func printLog(_ log: String) {
        logArea.text = ((logArea.text) ?? "") + log + "\n"
        lines+=1
//        logArea.scrollto
//        if (_arrdata.count != 0) {
//            [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:_arrdata.count-1 inSection:0]
//                animated:YES
//                scrollPosition:UITableViewScrollPositionMiddle];
//        }
    }
    func error() {
        fatalError()
    }
}
