/*
* Unless explicitly stated otherwise all files in this repository are licensed under the Apache License Version 2.0.
* This product includes software developed at Datadog (https://www.datadoghq.com/).
* Copyright 2019-2020 Datadog, Inc.
*/

import Foundation

/// Type-safe JSON schema.
internal protocol JSONType {}

internal enum JSONPrimitive: String, JSONType {
    case bool
    case double
    case integer
    case string
    /// A `bool`, `double`, `integer` or `string`
    case any
}

internal struct JSONArray: JSONType {
    let element: JSONType
}

internal struct JSONEnumeration: JSONType {
    let name: String
    let comment: String?
    let values: [String]
}

internal struct JSONObject: JSONType {
    struct Property: JSONType {
        enum DefaultValue {
            case integer(value: Int)
            case string(value: String)
        }

        let name: String
        let comment: String?
        let type: JSONType
        let defaultValue: DefaultValue?
        let isRequired: Bool
        let isReadOnly: Bool
    }

    struct AdditionalProperties: JSONType {
        let comment: String?
        let type: JSONPrimitive
        let isReadOnly: Bool
    }

    let name: String
    let comment: String?
    let properties: [Property]
    let additionalProperties: AdditionalProperties?

    init(name: String, comment: String?, properties: [Property], additionalProperties: AdditionalProperties? = nil) {
        self.name = name
        self.comment = comment
        self.properties = properties.sorted { property1, property2 in property1.name < property2.name }
        self.additionalProperties = additionalProperties
    }
}

// MARK: - Equatable

extension JSONObject: Equatable {
    static func == (lhs: JSONObject, rhs: JSONObject) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}
