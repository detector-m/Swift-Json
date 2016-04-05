//
//  SwiftJSONSerializable.swift
//  SwiftJSONParser
//
//  Created by Riven on 16/4/5.
//  Copyright © 2016年 Riven. All rights reserved.
//

import Foundation

extension Int: SwiftJSONSerializable {
    func toJSONObject() -> SwiftJSONObject {
        return self
    }
}

extension String: SwiftJSONSerializable {
    func toJSONObject() -> SwiftJSONObject {
        return self
    }
}

extension Double: SwiftJSONSerializable {
    func toJSONObject() -> SwiftJSONObject {
        return self
    }
}

extension Float: SwiftJSONSerializable {
    func toJSONObject() -> SwiftJSONObject {
        return self
    }
}

extension Bool: SwiftJSONSerializable {
    func toJSONObject() -> SwiftJSONObject {
        return self
    }
}

extension String: CustomStringConvertible {
    public var description: String {
        return self
    }
}
