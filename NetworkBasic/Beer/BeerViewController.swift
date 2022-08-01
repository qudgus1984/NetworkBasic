//
//  BeerViewController.swift
//  NetworkBasic
//
//  Created by 이병현 on 2022/08/01.
//

import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher

class BeerViewController: UIViewController {

    
    @IBOutlet weak var beerImageView: UIImageView!
    @IBOutlet weak var beerTitleLabel: UILabel!
    @IBOutlet weak var explainLabel: UILabel!
    @IBOutlet weak var pairingFoodLabel: UILabel!
    @IBOutlet weak var randomButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        beerTitleLabel.text = "어떤 맥주가 나올까요?"
        explainLabel.numberOfLines = 0
        pairingFoodLabel.numberOfLines = 2
        randomButton.setTitle("랜덤 추천", for: .normal)
        pairingFoodLabel.textAlignment = .center

    }
    
    @IBAction func randomButtonClicked(_ sender: UIButton) {
        randomBeer()
    }
    
    func randomBeer() {
        let url = "https://api.punkapi.com/v2/beers/random"
        AF.request(url, method: .get).validate().responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                // 맥주 이름 설정
                let beerName = json[0]["name"].stringValue
                beerTitleLabel.text = beerName
                
                // 맥주 이미지 설정
                let image = URL(string: json[0]["image_url"].stringValue)
                beerImageView.kf.setImage(with: image)
                
                // 맥주 설명
                let explain = json[0]["description"].stringValue
                explainLabel.text = "맥주 설명 : \(explain)"
                
                // 같이 먹으면 좋은 음식
                let pairingFood = json[0]["food_pairing"][0].stringValue
                pairingFoodLabel.text = "paringFood: \(pairingFood)"
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
}

//let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
//AF.request(url, method: .get).validate().responseJSON { [self] response in
//    switch response.result {
//    case .success(let value):
//        let json = JSON(value)
//        print("JSON: \(json)")
//        let bonus = json["bnusNo"].intValue
//        print(bonus)
//        let date = json["drwNoDate"].stringValue
//        print(date)
//        self.numberTextField.text = date
//        // Label에 각자의 로또 당첨번호 출력
//        for i in 1...7 {
//            switch i {
//            case 1...6 :
//                let lottoNumber = json["drwtNo\(i)"].stringValue
//                lottoNum[i-1].text = "\(lottoNumber)"
//            case 7:
//                let lottoNumber = json["bnusNo"].stringValue
//                lottoNum[6].text = "\(lottoNumber)"
//            default:
//                print("error")
//            }
//
//        }
//    case .failure(let error):
//        print(error)
//    }
