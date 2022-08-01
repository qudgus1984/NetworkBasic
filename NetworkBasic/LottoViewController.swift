//
//  LottoViewController.swift
//  NetworkBasic
//
//  Created by 이병현 on 2022/07/28.
//

import UIKit
//1. 임포트
import Alamofire
import SwiftyJSON

class LottoViewController: UIViewController {
    
    @IBOutlet var lottoNum: [UILabel]!
    
    
    @IBOutlet weak var numberTextField: UITextField!
    // @IBOutlet weak var lottoPickerView: UIPickerView!
    var lottoPickerView = UIPickerView()
    // 코드로 뷰를 만드는 기능이 훨씬 더 많이 남아있음!!
    
    let numberList: [Int] = Array(1...1025).reversed()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //인증번호 날라오면 자동으로 입력해주는 기능!!
        numberTextField.textContentType = .oneTimeCode
        
        numberTextField.inputView = lottoPickerView
        
        lottoPickerView.delegate = self
        lottoPickerView.dataSource = self
        
        requestLotto(number: 1025)
    }
    
    func requestLotto(number: Int) {
        
        //AF: 200~299 status code
        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(number)"
        AF.request(url, method: .get).validate().responseJSON { [self] response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let bonus = json["bnusNo"].intValue
                print(bonus)
                
                
                let date = json["drwNoDate"].stringValue
                print(date)
                
                self.numberTextField.text = date
                
                // Label에 각자의 로또 당첨번호 출력
                for i in 1...7 {
                    switch i {
                    case 1...6 :
                        let lottoNumber = json["drwtNo\(i)"].stringValue
                        lottoNum[i-1].text = "\(lottoNumber)"
                    case 7:
                        let lottoNumber = json["bnusNo"].stringValue
                        lottoNum[6].text = "\(lottoNumber)"
                    default:
                        print("error")
                    }

                }
                
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    @IBAction func tapGesture(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
}

extension LottoViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return numberList.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        requestLotto(number: numberList[row])
        //        numberTextField.text = "\(numberList[row])회차"
        view.endEditing(true)
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
    
}


