//
//  Constant.swift
//  NetworkBasic
//
//  Created by 이병현 on 2022/08/01.
//

import Foundation

//enum StoryboardName: String {
//    case Main
//    case Search
//    case Setting
//
//}
//
struct StoryboardName {
    
    private init() {
        
    }
    
    static let main = "Main"
    static let search = "Search"
    static let setting = "Setting"
}

/*
 1. struct type property vs enum type property => 인스턴스 생성 방지
 2. enum case vs enum static => 중복, case 제약 
 */

//enum StoryboardName {
//    static let main = "Main"
//    static let search = "Search"
//    static let setting = "Setting"
//}

//enum FontName {
//    case title = "SanFransico"
//    case body = "SanFransico"
//    case caption = "AppleSandol"
//
//}

enum FontName {
    static let title = "SanFransico"
    static let body = "SanFransico"
    static let caption = "AppleSandol"
    
}
