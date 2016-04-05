//
//  SwiftJSONDeserialization.swift
//  SwiftJSONParser
//
//  Created by Riven on 16/4/5.
//  Copyright © 2016年 Riven. All rights reserved.
//

import Foundation

// Mark: - Protocol
/// User for Class, Nested Type
protocol SwiftJSONDeserializable {
    init(json: SwiftJSONDictionary)
}

/// Use for Primitive Type
protocol SwiftJSONConvertible {
    static func convert(json: SwiftJSONObject) -> Self?
}

// Mark: - Deserialization
struct SwiftJSONDeserialization {
    // Mark: - Utils

    // Convert Object to nil if is NULL
    private static func convertNullToNil(object: SwiftJSONObject?) -> SwiftJSONObject? {
        return object is NSNull ? nil : object
    }
    
    // Mark: - SwiftJSONConvertible Type Deserialization
    static func convertAndAssign<T: SwiftJSONConvertible>(inout property: T?, fromJSONObject jsonObject: SwiftJSONObject?) -> T? {
        if let data: SwiftJSONObject = convertNullToNil(jsonObject), convertedValue = T.convert(data) {
            property = convertedValue
        }
        else {
            property = nil
        }
        
        return property
    }
    
//    static func convertAndAssign<T: SwiftJSONConvertible>(inout property: T, fromJSONObject jsonObject: SwiftJSONObject?) -> T {
//        var newValue: T?
//        SwiftJSONDeserialization.convertAndAssign(&newValue, fromJSONObject: jsonObject)
//        if let newValue = newValue {
//            property = newValue
//        }
//        
//        return property
//    }
    
    static func convertAndAssign<T: SwiftJSONConvertible>(inout properties:[T]?, fromJSONObject jsonObject: SwiftJSONObject?) -> [T]? {
        if let dataArray = convertNullToNil(jsonObject) as? [SwiftJSONObject] {
            properties = [T]()
            for data in dataArray {
                if let property = T.convert(data) {
                    properties?.append(property)
                }
            }
        }
        else {
            properties = nil
        }
        
        return properties
    }
    
    // Mark: - Custom Type Deserialization
    static func convertAndAssign<T: SwiftJSONDeserializable>(inout instance: T?, fromJSONObject jsonObject: SwiftJSONObject?) -> T? {
        if let data = convertNullToNil(jsonObject) as? SwiftJSONDictionary {
            instance = T(json: data)
        }
        else {
            instance = nil
        }
        
        return instance
    }
    
    static func convertAndAssign<T: SwiftJSONDeserializable>(inout array: [T]?, fromJSONObject jsonObject: SwiftJSONObject?) -> [T]? {
        if let dataArray: [SwiftJSONDictionary] = convertNullToNil(jsonObject) as? [SwiftJSONDictionary] {
            array = [T]()
            for data in dataArray {
                array?.append(T(json: data))
            }
        }
        else {
            array = nil
        }
        
        return array
    }
    
    // Mark: Custom Value Converter
    static func convertAndAssign<T>(inout property: T?, fromJSONObject bundle:(SwiftJSONObject?,(SwiftJSONObject) -> T?)) -> T? {
        if let data: SwiftJSONObject = convertNullToNil(bundle.0), convertedValue = bundle.1(data) {
            property = convertedValue
        }
        
        return property
    }
    
    // Mark: - Custom Map Deserialization
    static func convertAndAssign<T, U where T: SwiftJSONConvertible, U: SwiftJSONConvertible, U: Hashable>(inout map: [U: T]?, fromJSONObject jsonObject: SwiftJSONObject?) -> [U: T]? {
        if let dataMap = convertNullToNil(jsonObject) as? SwiftJSONDictionary {
            map = [U: T]()
            
            for (key, data) in dataMap {
                if  let convertedKey = U.convert(key), convertedValue = T.convert(data) {
                    map![convertedKey] = convertedValue
                }
            }
        }
        else {
            map = nil
        }
        
        return map
    }
    
    static func convertAndAssign<T, U where T: SwiftJSONDeserializable, U: SwiftJSONConvertible, U: Hashable>(inout map: [U: T]?, fromJSONObject jsonObject: SwiftJSONObject?) -> [U: T]? {
        if let dataMap = convertNullToNil(jsonObject) as? [String: SwiftJSONDictionary] {
            map = [U: T]()
            for (key, data) in dataMap {
                if let convertedKey = U.convert(key) {
                    map![convertedKey] = T(json: data)
                }
            }
        }
        else {
            map = nil
        }
        
        return map
    }
    
    // Mark: - Raw Value Representable (Enum) 
    static func convertAndAssign<T: RawRepresentable where T.RawValue: SwiftJSONConvertible>(inout property: T?, fromJSONObject jsonObject: SwiftJSONObject?) -> T? {
        var newEnumValue: T?
        var newRawEnumValue: T.RawValue?
        
        SwiftJSONDeserialization.convertAndAssign(&newRawEnumValue, fromJSONObject: jsonObject)
        if let unwrappedNewRawEnumValue = newRawEnumValue {
            if let enumVale = T(rawValue: unwrappedNewRawEnumValue) {
                newEnumValue = enumVale
            }
        }
        
        property = newEnumValue
        
        return property
    }
    
    static func convertAndAssign<T: RawRepresentable where T.RawValue: SwiftJSONConvertible>(inout array: [T]?, fromJSONObject jsonObject: SwiftJSONObject?) -> [T]? {
        if let dataArray = convertNullToNil(jsonObject) as? [SwiftJSONObject] {
            array = [T]()
            for data in dataArray {
                var newValue: T?
                SwiftJSONDeserialization.convertAndAssign(&newValue, fromJSONObject: data)
                if let newValue = newValue {
                    array!.append(newValue)
                }
            }
        }
        else {
            array = nil
        }
        
        return array
    }
}

// Mark: - Operator for user in deserialization operations.
infix operator <-- { associativity right  precedence 150 }
func <-- <T: SwiftJSONConvertible>(inout property: T?, jsonObject: SwiftJSONObject?) -> T? {
    return SwiftJSONDeserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

func <-- <T: SwiftJSONConvertible>(inout array: [T]?, jsonObject: SwiftJSONObject?) -> [T]? {
    return SwiftJSONDeserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

func <-- <T: SwiftJSONDeserializable>(inout instance: T?, jsonObject: SwiftJSONObject?) -> T? {
    return SwiftJSONDeserialization.convertAndAssign(&instance, fromJSONObject: jsonObject)
}

func <-- <T: SwiftJSONDeserializable>(inout array: [T]?, jsonObject: SwiftJSONObject?) -> [T]? {
    return SwiftJSONDeserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}

func <-- <T>(inout property: T?, bundle:(jsonObject: SwiftJSONObject?, converter: (SwiftJSONObject) -> T?)) -> T? {
    return SwiftJSONDeserialization.convertAndAssign(&property, fromJSONObject: bundle)
}

// MARK: - Custom Map Deserialiazation
func <-- <T, U where T: SwiftJSONConvertible, U: SwiftJSONConvertible, U: Hashable>(inout map: [U: T]?, jsonObject: SwiftJSONObject?) -> [U: T]? {
    return SwiftJSONDeserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

func <-- <T, U where T: SwiftJSONDeserializable, U: SwiftJSONConvertible, U: Hashable>(inout map: [U: T]?, jsonObject: SwiftJSONObject?) -> [U: T]? {
    return SwiftJSONDeserialization.convertAndAssign(&map, fromJSONObject: jsonObject)
}

// MARK: - Raw Value Representable (Enum) Deserialization

func <-- <T: RawRepresentable where T.RawValue: SwiftJSONConvertible>(inout property: T?, jsonObject: SwiftJSONObject?) -> T? {
    return SwiftJSONDeserialization.convertAndAssign(&property, fromJSONObject: jsonObject)
}

func <-- <T: RawRepresentable where T.RawValue: SwiftJSONConvertible>(inout array: [T]?, jsonObject: SwiftJSONObject?) -> [T]? {
    return SwiftJSONDeserialization.convertAndAssign(&array, fromJSONObject: jsonObject)
}