//
//  SwiftConvertible.swift
//  SwiftJSONParser
//
//  Created by Riven on 16/4/5.
//  Copyright © 2016年 Riven. All rights reserved.
//

import Foundation
extension Int: SwiftJSONConvertible {
    static func convert(json: SwiftJSONObject) -> Int? {
        if let int = json as? Int {
            return int
        }
        else if let str = json as? String, int = Int(str) {
            return int
        }
        
        return nil
    }
}

extension String: SwiftJSONConvertible {
    static func convert(json: SwiftJSONObject) -> String? {
        return json as? String
    }
}

extension Double: SwiftJSONConvertible {
    static func convert(json: SwiftJSONObject) -> Double? {
        return json as? Double
    }
}

extension Float: SwiftJSONConvertible {
    static func convert(json: SwiftJSONObject) -> Float? {
        return json as? Float
    }
}

extension Bool: SwiftJSONConvertible {
    static func convert(json: SwiftJSONObject) -> Bool? {
       return json as? Bool
    }
}

extension NSURL: SwiftJSONConvertible {
    static func convert(json: SwiftJSONObject) -> Self? {
        if let str = json as? String, url = self.init(string: str) {
            return url
        }
        
        return nil
    }
}

extension NSDate: SwiftJSONConvertible {
    static func convert(json: SwiftJSONObject) -> Self? {
        if let timestamp = json as? Int {
            return self.init(timeIntervalSince1970: Double(timestamp))
        }
        else if let timestamp = json as? Double {
            return self.init(timeIntervalSince1970: timestamp)
        }
        else if let timestamp = json as? NSNumber {
            return self.init(timeIntervalSince1970: timestamp.doubleValue)
        }
        
        return nil
    }
}

func DateFormatConverter(dateFormat: String) -> (SwiftJSONObject) -> NSDate? {
    return {
        // data in
        if let dateString = $0 as? String {
            let dateForMatter = NSDateFormatter()
            dateForMatter.dateFormat = dateFormat
            if let date = dateForMatter.dateFromString(dateString) {
                return date
            }
        }
        
        return nil
    }
}