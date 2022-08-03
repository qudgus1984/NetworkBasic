//
//  ImageSearchViewController.swift
//  NetworkBasic
//
//  Created by 이병현 on 2022/08/03.
//

import UIKit

import Alamofire
import SwiftyJSON

class ImageSearchViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchImage()
    }
    
    
    //fetch, requestImage, callRequestImage, getImage...> responese에 따라 네이밍을 설정해주기도 함
    //내일 페이지네이션에 대한 기능 구현
    // pagenation - offsetPagenation : 요소가 잘 변하지 않을 때 -> 하루 정도에 업데이트 되는 것들
    //                                 1~30번이 있다고 한다면 31~60번을 보여줌
    //            - cursorPagenation : 계속 새로운 요소가 들어와 중복데이터가 만들어질 때 -> 트위터 / 핫한 게시물 등
    //                                 마지막 데이터 기준으로 호출 : 데이터 중복 방지
    func fetchImage() {
        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=1"
                
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]

        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
              
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
}
