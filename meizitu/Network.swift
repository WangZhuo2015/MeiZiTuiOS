//
//  Network.swift
//  meizitu
//
//  Created by 王卓 on 16/8/30.
//  Copyright © 2016年 SherryTeam. All rights reserved.
//

import Foundation
import Alamofire
class HttpClient{
    class func invoke (
        _ url:String,
        parameters:[String: Any]? = nil,
        complete:@escaping (_ response: Data?, _ error: Error?) -> Void){
        Alamofire.request(url, method: .get, parameters: parameters, encoding: URLEncoding.default, headers: [:]).responseJSON { (response) in
            complete(response.data,response.result.error)
        }
    }
    class func invokePost (
        _ url:String,
        parameters:[String: Any]? = nil,
        complete:@escaping (_ response: Data?, _ error: Error?) -> Void){
        Alamofire.request(url, method: .post, parameters: parameters, encoding: URLEncoding.httpBody, headers: [:]).responseJSON { (response) in
            complete(response.data,response.result.error)
        }
    }
}

class ServiceProxy {
    internal enum Source {
        case meizitu
        case ljq
    }
    
    fileprivate static var source:Source = .meizitu
    internal static func setSource(_ mySource:Source){
        self.source = mySource
    }
    
    fileprivate static func serviceEndPoint()->String{
        return "http://wzhere.cn:5000/"
    }
    fileprivate static func getListURL()->String{
        switch self.source {
        case .meizitu:
            return serviceEndPoint() + "list"
        case .ljq:
            return serviceEndPoint() + "ljq"
        }
    }
    
    fileprivate static func getSearchURL()->String{
        switch self.source {
        case .meizitu:
            return serviceEndPoint() + "list"
        case .ljq:
            return serviceEndPoint() + "ljq"
        }
    }
    
    fileprivate static func getGirlURL()->String{
        switch self.source {
        case .meizitu:
            return serviceEndPoint() + "girl"
        case .ljq:
            return serviceEndPoint() + "ljq_detail"
        }
    }
    
    //    接口地址 :http://115.159.216.101:5000/list
    //    请求方法 :GET
    //    请求参数(header) :name String
    internal static func getList (
        _ page:Int,
        complete:@escaping (_ list: ListAPIBase?, _ error: NSError?) -> Void){
        HttpClient.invoke(getListURL(),parameters: ["page":page]) { (response, networkError) in
            do{
                if let data = response{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                    complete(ListAPIBase(fromDictionary: json),networkError as NSError?)
                }
            }catch{
                complete(nil, networkError as NSError?)
            }
        }
    }
    
    //    接口地址 :http://115.159.216.101:5000/list
    //    请求方法 :GET
    //    请求参数(header) :name String
    internal static func getList (
        _ title:String,
        _ page:Int,
        complete:@escaping (_ list: ListAPIBase?, _ error: NSError?) -> Void){
        HttpClient.invoke(getSearchURL(),parameters: ["title":title,"page":page]) { (response, networkError) in
            do{
                if let data = response{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                    complete(ListAPIBase(fromDictionary: json),networkError as NSError?)
                }
            }catch{
                complete(nil, networkError as NSError?)
            }
        }
    }
    
    //    接口地址 :http://115.159.216.101:5000/girl
    //    请求方法 :GET
    //    请求参数(header) :name String
    internal static func getGirl (
        _ url:String,
        complete:@escaping (_ girls: GirlAPIBase?, _ error: NSError?) -> Void){
        HttpClient.invoke(getGirlURL(),parameters: ["url":url]) { (response, networkError) in
            do{
                if let data = response{
                    let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as! NSDictionary
                    complete(GirlAPIBase(fromDictionary: json),networkError as NSError?)
                }
            }catch{
                complete(nil, networkError as NSError?)
            }
        }
    }

}
