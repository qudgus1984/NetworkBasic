//
//  UserDefaultsHelper.swift
//  NetworkBasic
//
//  Created by 이병현 on 2022/08/01.
//

import UIKit

class UserDefaultsHelper {
    
    private init() { }
    // 외부에서 초기화 구문을 실행하지 못하게 설정
    static let standard = UserDefaultsHelper()
    // singleton pattern 자기 자신의 인스턴스를 타입 프로퍼티 형태로 가지고 있음
    
    let userDefault = UserDefaults.standard
    enum Key: String {
        case nickname, age
    }
    var nickname: String {
        get {
            return userDefault.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set { // 연산 프로퍼티 parameter
            userDefault.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    var age: Int {
        get {
            return userDefault.integer(forKey: Key.age.rawValue)
        }
        set {
            userDefault.set(newValue, forKey: Key.age.rawValue)
        }
    }
}
