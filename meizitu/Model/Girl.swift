//
//	Girl.swift
//  on 31/8/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct Girl{

	var img : String!
	var title : String!
    var index : Int!
    //let regex = try! NSRegularExpression(pattern: "?=<(?=)", options: .caseInsensitive)
	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		img = dictionary["img"] as? String
		title = dictionary["title"] as? String
        
        //index = regex.matches(in: title, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length: title.characters.count))
        index = dictionary["index"] as? Int
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if img != nil{
			dictionary["img"] = img
		}
		if title != nil{
			dictionary["title"] = title
		}
        if index != nil{
            dictionary["index"] = index
        }
		return dictionary
	}

}
