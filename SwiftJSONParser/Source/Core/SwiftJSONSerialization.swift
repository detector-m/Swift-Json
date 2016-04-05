//
//  SwiftJSONSerialization.swift
//  SwiftJSONParser
//
//  Created by Riven on 16/4/5.
//  Copyright © 2016年 Riven. All rights reserved.
//

import Foundation

// Mark: - Protocol
/// convert to JSON object
protocol SwiftJSONSerializable {
    func toJSONObject() -> SwiftJSONObject
}

// Mark: - Serialization
struct SwiftJSONSerialization {
    // Mark: - General Type Serialization
    static func convertAndAssign<T: SwiftJSONSerializable>(property: T?, inout toJSONObject jsonObject: SwiftJSONObject?) -> SwiftJSONObject? {
        if let property = property {
            jsonObject = property.toJSONObject()
        }
        
        return jsonObject
    }
    
    // Mark: - Array Serialization
    static func convertAndAssign<T: SwiftJSONSerializable>(properties: [T]?, inout toJSONObject jsonObject: SwiftJSONObject?) -> SwiftJSONObject? {
        if let properties = properties {
            jsonObject = properties.map {
                p in
                p.toJSONObject()
            }
        }
        
        return jsonObject
    }
    
    // Mark: - Map Serialization
    static func convertAndAssign<T: SwiftJSONSerializable, U: protocol<CustomStringConvertible, Hashable>>(map: [U: T]?, inout toJSONObject jsonObject: SwiftJSONObject?) -> SwiftJSONObject? {
        if let jsonMap = map {
            var json = SwiftJSONDictionary()
            for (key, value) in jsonMap {
                json[key.description] = value.toJSONObject()
            }
            jsonObject = json
        }
        
        return jsonObject
    }
    
    // Mark: - Raw Respresentable (Enum) Serialization
    static func convertAndAssign<T: RawRepresentable where T.RawValue: SwiftJSONSerializable>(property: T?, inout toJSONObject jsonObject: SwiftJSONObject?) -> SwiftJSONObject? {
        if let value: SwiftJSONObject = property?.rawValue.toJSONObject() {
            jsonObject = value
        }
        
        return jsonObject
    }
    
    static func convertAndAssign<T where T: RawRepresentable, T.RawValue: SwiftJSONSerializable>(properties: [T]?, inout toJSONObject jsonObject: SwiftJSONObject?) -> SwiftJSONObject? {
        if let properties = properties {
            jsonObject = properties.map {
                p in
                p.rawValue.toJSONObject()
            }
        }
        
        return jsonObject
    }
}

// Mark: - Operator for use in serialization
infix operator --> { associativity right precedence 150 }
func --> <T: SwiftJSONSerializable>(property: T?, inout jsonObject: SwiftJSONObject?) -> SwiftJSONObject? {
    return SwiftJSONSerialization.convertAndAssign(property, toJSONObject: &jsonObject)
}

func --> <T: SwiftJSONSerializable>(properties: [T]?, inout jsonObject: SwiftJSONObject?) -> SwiftJSONObject? {
    return SwiftJSONSerialization.convertAndAssign(properties, toJSONObject: &jsonObject)
}

func --> <T, U where T: SwiftJSONSerializable, U: CustomStringConvertible, U: Hashable>(map: [U: T]?, inout jsonObject: SwiftJSONObject?) -> SwiftJSONObject? {
    return SwiftJSONSerialization.convertAndAssign(map, toJSONObject: &jsonObject)
}

func --> <T: RawRepresentable where T.RawValue: SwiftJSONSerializable>(property: T?, inout jsonObject: SwiftJSONObject?) -> SwiftJSONObject? {
    return SwiftJSONSerialization.convertAndAssign(property, toJSONObject: &jsonObject)
}

func --> <T: RawRepresentable where T.RawValue: SwiftJSONSerializable>(properties: [T]?, inout jsonObject: SwiftJSONObject?) -> SwiftJSONObject? {
    return SwiftJSONSerialization.convertAndAssign(properties, toJSONObject: &jsonObject)
}
