//
//  OptionalExtensions.swift
//  Achievements
//
//  Created by Yuki Takahashi on 27/01/2021.
//

import Foundation

extension Optional where Wrapped == String {
    var _bounds: String? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var bounds: String {
        get {
            return _bounds ?? ""
        }
        set {
            _bounds = newValue.isEmpty ? nil : newValue
        }
    }
}

extension Optional where Wrapped == Date {
    var _boundd: Date? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var boundd: Date {
        get {
            return _boundd ?? Date()
        }
        set {
            _boundd = newValue
        }
    }
}

extension Optional where Wrapped == Int16 {
    var _boundi: Int16? {
        get {
            return self
        }
        set {
            self = newValue
        }
    }
    public var boundi: Int16 {
        get {
            return _boundi ?? 0
        }
        set {
            _boundi = newValue
        }
    }
}
