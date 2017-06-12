//
//  Model.swift
//  PEExam
//
//  Created by 王卓 on 16/6/17.
//  Copyright © 2016年 SherryTeam. All rights reserved.
//

import Foundation
import Alamofire
class Model {
    static let model = Model()
    var delegate: AutoAnswerDelegate?
    var paperID:Int = 0
    var examId:Int = 0
    var delay = true
    func decodeQuestionData(_ data:String)->QuestionData?{
        do{
            let json = try JSONSerialization.jsonObject( with: data.data(using: String.Encoding.utf8)! , options: .mutableContainers) as! NSDictionary
            return QuestionData(fromDictionary: json)
        }catch{
            return nil
        }
    }
    
    func autoAnswer(_ token:String,uid:String,paperID:Int,questionData:QuestionData){
        var count = 1
        questionData.dtos.forEach { (item) in
            var answer = ""
            item.answers.forEach({ (item) in
                answer += item.optionValue + ","
            })
            answer = answer.substring(to: answer.characters.index(before: answer.endIndex))
            let URL = "http://appsrv.ihodoo.com"+("/auth/exam/select/" + "\(paperID)") + "/\(item.subId)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
            
            let _: TimeInterval = 2.0
            _ = 1//DispatchTime.now() + Double(Int64(time * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)*UInt64(random()%10)
            if self.delay{
                //DispatchQueue.main.asyncAfter(deadline: TimeInterval(delay)) {
                    Alamofire.request(URL,method: .get, parameters: ["selectOptions":answer,"token":token,"uid":uid],headers: [:])
                        .validate(statusCode: 200...300).responseJSON(completionHandler: { (response) in
                            //self.delegate?.printLog(String(data: response.data!, encoding: NSUTF8StringEncoding)!)
                            print(response.result.value as! String)
                            let json = try! JSONSerialization.jsonObject( with: response.data!, options: .mutableContainers) as! NSDictionary
                            guard QuestionRes(fromDictionary: json).isSuccess! else{
                                self.delegate?.printLog("提交失败")
                                return
                            }
                            self.delegate?.printLog("已经提交了\(count)题")
                            if count == 50{
                                self.submit(token,uid: uid,paperID: paperID)
                            }
                            count += 1
                        })
                //}
            }else{
            Alamofire.request(URL,method: .get, parameters: ["selectOptions":answer,"token":token,"uid":uid], headers: [:])
                .validate(statusCode: 200...300)
                //.responseJSON(completionHandler: { (response) in
                .responseString(completionHandler: { (response) in
                    print(response.result.value)
                    
                    self.delegate?.printLog(String(data: response.data!, encoding: String.Encoding.utf8)!)
                    let json = try! JSONSerialization.jsonObject( with: response.data!, options: .mutableContainers) as! NSDictionary
                    guard QuestionRes(fromDictionary: json).isSuccess! else{
                        self.delegate?.printLog("提交失败")
                        return
                    }
                    self.delegate?.printLog("已经提交了\(count)题")
                    if count == 50{
                        self.submit(token,uid: uid,paperID: paperID)
                    }
                    count += 1
                })
            }
            self.delegate?.printLog("第\(count)题的答案是:")
            self.delegate?.printLog(answer)
        }
    }
    
    func submit(_ token:String,uid:String,paperID:Int){
        let URL = "http://appsrv.ihodoo.com/auth/exam/submit/\(paperID)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        Alamofire.request( URL,method: .get, parameters: ["token":token,"uid":uid], headers: [:]).responseJSON(completionHandler: { (response) in
            do{
                let json = try JSONSerialization.jsonObject( with: response.data! , options: .mutableContainers) as! NSDictionary
                let result = ExamRes(fromDictionary: json)
                print("分数\(result.score)")
                print("排名\(result.rankMessage)")
                self.delegate?.printLog("分数\(result.score)")
                self.delegate?.printLog("排名\(result.rankMessage)")
            }catch{
                //self.delegate?.printLog(error)
                self.delegate?.printLog(response.description)
                self.delegate?.error()
            }
        })
    }
    
    func login(_ uid:String,password:String,completeHandle:@escaping ()->Void){
        let URL = "http://appsrv.ihodoo.com/login"
        Alamofire.request(URL, method: .post, parameters: ["username":uid,"password":password], headers: [:]).responseJSON(completionHandler: { (response) in
            do{
                guard response.result.isSuccess else{
                    self.delegate?.printLog("账号或密码错误")
                    return
                }
                let json = try JSONSerialization.jsonObject( with: response.data! , options: .mutableContainers) as! NSDictionary
                let result = UserAPIBase(fromDictionary: json)
                print("token\(result.token)")
                print("uid\(result.uid)")
                User.sharedUser.token = result.token
                User.sharedUser.uid = result.uid
                completeHandle()
            }catch{
                self.delegate?.printLog("账号或密码错误")
                return
            }
        })
    }
    
    //    GET /auth/exam/enterIndex?token=a994e10e-465a-4169-82ae-062e3414dd7d&uid=
    //    HTTP/1.1
    //    Host: appsrv.ihodoo.com
    //    Accept-Encoding: gzip, deflate
    //    Accept: */*
    // Accept-Language: zh-Hans-US;q=1, en;q=0.9
    // Connection: keep-alive
    // User-Agent: hdxm/1 (iPhone; iOS 10.0; Scale/2.00)
    
    func getPaper(_ uid:String,token:String,completeHandle:@escaping (_ data:ExamDataAPIBase)->Void){
        let URL = "http://appsrv.ihodoo.com/auth/exam/enterIndex"
        Alamofire.request(URL,method: .get, parameters: ["token":token,"uid":uid], headers: [:]).responseJSON { (response) in
            do{
                let json = try JSONSerialization.jsonObject( with: response.data! , options: .mutableContainers) as! NSDictionary
                let result = ExamDataAPIBase(fromDictionary: json)
                guard result.isAllowExam == true else{
                    throw ExamError.error(result.message)
                }
                self.examId = result.id
                self.paperID = result.examPaperId
                self.delegate?.printLog("试卷已获取")
                completeHandle(result)
            }
            catch ExamError.error(let message){
                self.delegate?.printLog(message)
            }catch{
                print("error")
                fatalError()
            }
        }
    }
    enum ExamError: Error {
        case error(String)
    }
    
    
    //    GET /auth/exam/start/10/338880?token=89532dc4-35d0-4464-a89e-982eef21e0c8&totalCount=50&uid= HTTP/1.1
    //    token	89532dc4-35d0-4464-a89e-982eef21e0c8
    //    totalCount	50
    //    uid	手机号
    //开始考试
    func startExam(_ uid:String,token:String,id:Int,paperID:Int,completeHandle:@escaping (_ data:QuestionData)->Void){
        let URL = "http://appsrv.ihodoo.com/auth/exam/start/\(id)/" + "\(paperID)"
        Alamofire.request(URL,method: .get, parameters: ["token":token,"uid":uid,"totalCount":50], headers: [:])
            .responseString(completionHandler: { (response) in
            //.responseJSON(completionHandler: { (response) in
            do{
                print(response.value ?? "")
                let json = try JSONSerialization.jsonObject( with: response.data! , options: .mutableContainers) as! NSDictionary
                let result = QuestionData(fromDictionary: json)
                completeHandle(result)
            }catch{
                print(error)
                fatalError()
            }
        })
    }
}
protocol AutoAnswerDelegate {
    func printLog(_ log: String)
    func error()
}
