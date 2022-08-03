//
//  ImageViewCollectionViewCell.swift
//  NetworkBasic
//
//  Created by 이병현 on 2022/08/04.
//
import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher


class ImageViewCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "ImageViewCollectionViewCell"
    
    @IBOutlet weak var searchImageView: UIImageView!
    
    func fetchImageCell() {
        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=1"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                
                let image = URL(string: json[0][17]["thumbnail"].stringValue)
                searchImageView.kf.setImage(with: image)
                
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
//    func beerCell() {
//        let url = "https://api.punkapi.com/v2/beers/random"
//        AF.request(url, method: .get).validate().responseJSON { [self] response in
//            switch response.result {
//            case .success(let value):
//                let json = JSON(value)
//                print("JSON: \(json)")
//
//                // 맥주 이름 설정
//                let beerTitle = json[0]["name"].stringValue
//                beerName.text = beerTitle
//
//                // 맥주 이미지 설정
//                let image = URL(string: json[0]["image_url"].stringValue)
//                beerImageView.kf.setImage(with: image)
//
//                // 맥주 설명
//                let explain = json[0]["description"].stringValue
//                beerExplain.text = explain
//
//
//            case .failure(let error):
//                print(error)
//            }
//        }
//    }
}

