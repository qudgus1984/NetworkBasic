//
//  BeerCollectionViewCell.swift
//  NetworkBasic
//
//  Created by 이병현 on 2022/08/02.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class BeerCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerName: UILabel!
    @IBOutlet weak var beerExplain: UILabel!
    
    func beerCell() {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url, method: .get).validate().responseData { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                // 맥주 이름 설정
                let beerTitle = json[0]["name"].stringValue
                beerName.text = beerTitle
                
                // 맥주 이미지 설정
                let image = URL(string: json[0]["image_url"].stringValue)
                beerImageView.kf.setImage(with: image)
                
                // 맥주 설명
                let explain = json[0]["description"].stringValue
                beerExplain.text = explain
                

            case .failure(let error):
                print(error)
            }
        }
    }
    
}
