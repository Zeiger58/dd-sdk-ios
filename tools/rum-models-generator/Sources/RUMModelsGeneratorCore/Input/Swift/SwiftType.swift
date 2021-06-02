/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at Datadog (https://www.datadoghq.com/).
* Copyright 2019-2020 Datadog, Inc.
*/

import Foundation

/// Type-safe Swift schema.
public protocol SwiftType {}

/// Swift primitive type.
internal protocol SwiftPrimitiveType: SwiftType {}
/// An allowed value of Swift primitive type.
internal protocol SwiftPrimitiveValue {}
/// An allowed default value of Swift property.
internal protocol SwiftPropertyDefaultValue {}

extension Bool: SwiftPrimitiveValue, SwiftPropertyDefaultValue {}
extension Int: SwiftPrimitiveValue, SwiftPropertyDefaultValue {}
extension Int64: SwiftPrimitiveValue, SwiftPropertyDefaultValue {}
extension String: SwiftPrimitiveValue, SwiftPropertyDefaultValue {}
extension Double: SwiftPrimitiveValue, SwiftPropertyDefaultValue {}

/// Represents `Swift.Codable` - we need to define utility type because it cannot be declared as `extension` to `Codable`.
internal struct SwiftCodable: SwiftPrimitiveValue, SwiftPropertyDefaultValue {}

internal struct SwiftPrimitive<T: SwiftPrimitiveValue>: SwiftPrimitiveType {}

internal struct SwiftArray: SwiftType {
    var element: SwiftType
}

internal struct SwiftDictionary: SwiftType {
    let key = SwiftPrimitive<String>()
    var value: SwiftPrimitiveType
}

internal struct SwiftEnum: SwiftType {
    struct Case: SwiftType, SwiftPropertyDefaultValue {
        var label: String
        var rawValue: String
    }

    var name: String
    var comment: String?
    var cases: [Case]
    var conformance: [SwiftProtocol]
}

internal struct SwiftStruct: SwiftType {
    struct Property: SwiftType {
        var name: String
        var comment: String?
        var type: SwiftType
        var isOptional: Bool
        var isMutable: Bool
        var defaultValue: SwiftPropertyDefaultValue?
        var codingKey: String
    }

    var name: String
    var comment: String?
    var properties: [Property]
    var conformance: [SwiftProtocol]
}

internal struct SwiftProtocol: SwiftType {
    var name: String
    var conformance: [SwiftProtocol]
}

/// Reference to any other Swift type.
internal struct SwiftTypeReference: SwiftType {
    var referencedTypeName: String
}

internal let codableProtocol = SwiftProtocol(name: "Codable", conformance: [])

// MARK: - Helpers

extension SwiftType {
    /// The name of this type (or `nil` if this type is unnamed).
    var typeName: String? {
        let `struct` = self as? SwiftStruct
        let `enum` = self as? SwiftEnum
        return `struct`?.name ?? `enum`?.name
    }
}

// MARK: - Equatable

extension SwiftStruct: Equatable {
    static func == (lhs: SwiftStruct, rhs: SwiftStruct) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

extension SwiftEnum: Equatable {
    static func == (lhs: SwiftEnum, rhs: SwiftEnum) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

internal func == (lhs: SwiftType, rhs: SwiftType) -> Bool {
    return String(describing: lhs) == String(describing: rhs)
}

internal func != (lhs: SwiftType, rhs: SwiftType) -> Bool {
    return !(lhs == rhs)
}
