//
//	GirlAPIBase.swift
//  on 31/8/2016
//	Copyright © 2016. All rights reserved.
//	Model file generated using JSONExport: https://github.com/Ahmed-Ali/JSONExport

import Foundation

struct GirlAPIBase{

	var girls : [Girl]!


	/**
	 * Instantiate the instance using the passed dictionary values to set the properties values
	 */
	init(fromDictionary dictionary: NSDictionary){
		girls = [Girl]()
		if let girlsArray = dictionary["data"] as? [NSDictionary]{
			for dic in girlsArray{
				let value = Girl(fromDictionary: dic)
				girls.append(value)
			}
		}
	}

	/**
	 * Returns all the available property values in the form of NSDictionary object where the key is the approperiate json key and the value is the value of the corresponding property
	 */
	func toDictionary() -> NSDictionary
	{
		let dictionary = NSMutableDictionary()
		if girls != nil{
			var dictionaryElements = [NSDictionary]()
			for girlsElement in girls {
				dictionaryElements.append(girlsElement.toDictionary())
			}
			dictionary["data"] = dictionaryElements
		}
		return dictionary
	}

}