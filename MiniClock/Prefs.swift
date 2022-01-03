//
//  Prefs.swift
//  MiniClock
//
//  Created by Wangyiwei on 2022/1/2.
//

import UIKit

let d = UserDefaults.standard

class Settings: NSObject {
    private override init() {}
    static let shared = Settings()
    
    private var _userLearntLongPress = d.bool(forKey: "_NOT_FIRST_LAUNCH")
    var userLearntLongPress: Bool {
        set {
            if newValue == _userLearntLongPress {return}
            d.set(newValue, forKey: "_NOT_FIRST_LAUNCH")
            _userLearntLongPress = newValue
        }
        get {_userLearntLongPress}
    }
    
    private var _userDefaultClockType = d.integer(forKey: "_DEFAULT_TYPE")
    var userDefaultClockType: Int {
        set {
            if newValue == _userDefaultClockType {return}
            d.set(newValue, forKey: "_DEFAULT_TYPE")
            _userDefaultClockType = newValue
        }
        get {d.integer(forKey: "_DEFAULT_TYPE")}
    }
    
    //analog clock
    
    private var _analogColorIndex = d.integer(forKey: "_ANALOG_COLOR")
    var analogColorIndex: Int {
        set {
            if newValue == _analogColorIndex {return}
            d.set(newValue, forKey: "_ANALOG_COLOR")
            _analogColorIndex = newValue
        }
        get {_analogColorIndex}
    }
    
    private var _analogSpringResonse = d.double(forKey: "_ANALOG_RESPONSE")
    var analogSpringResonse: Double {
        set {
            if newValue == _analogSpringResonse {return}
            d.set(newValue, forKey: "_ANALOG_RESPONSE")
            _analogSpringResonse = newValue
        }
        get {_analogSpringResonse}
    }
    
    private var _analogSpringDamping = d.double(forKey: "_ANALOG_DAMPING")
    var analogSpringDamping: Double {
        set {
            if newValue == _analogSpringDamping {return}
            d.set(newValue, forKey: "_ANALOG_DAMPING")
            _analogSpringDamping = newValue
        }
        get {_analogSpringDamping}
    }
    
    //digitla clock
    
    private var _digitalColorIndex = d.integer(forKey: "_DIGITAL_COLOR")
    var digitalColorIndex: Int {
        set {
            if newValue == _digitalColorIndex {return}
            d.set(newValue, forKey: "_DIGITAL_COLOR")
            _digitalColorIndex = newValue
        }
        get {_digitalColorIndex}
    }
    
    private var _digitalFontIndex = d.integer(forKey: "_DIGITAL_FONT")
    var digitalFontIndex: Int {
        set {
            if newValue == _digitalFontIndex {return}
            d.set(newValue, forKey: "_DIGITAL_FONT")
            _digitalFontIndex = newValue
        }
        get {_digitalFontIndex}
    }
    
    private var _digitalSize = CGFloat(d.double(forKey: "_DIGITAL_SIZE"))
    var digitalSize: CGFloat {
        set {
            if newValue == _digitalSize {return}
            d.set(Double(newValue), forKey: "_DIGITAL_SIZE")
            _digitalSize = newValue
        }
        get {_digitalSize}
    }
}
