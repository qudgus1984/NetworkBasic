//
//  TranslateViewController.swift
//  NetworkBasic
//
//  Created by 이병현 on 2022/07/28.
//

import UIKit

import Alamofire
import SwiftyJSON

class TranslateViewController: UIViewController {
    
    //UIButton, UITextField > Action
    //UITextView, UISearchBar, UIPickerView > X
    //UIControl
    //UIResponderChain > resignFirstResponder() > becomeFirstResponder()
    
    @IBOutlet weak var userInputTextView: UITextView!
    @IBOutlet weak var translateLabel: UILabel!
    
    let textViewPlaceholderText = "번역하고 싶은 문장을 작성해보세요."
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userInputTextView.delegate = self
        
        userInputTextView.text = textViewPlaceholderText
        userInputTextView.textColor = .lightGray
        
        userInputTextView.font = UIFont(name: "KOTRA_BOLD-Bold", size: 17)
        
        requestTranslateData()
        
        // 우선권을 부여하는 것 -> 오늘 공부해보기
        //        userInputTextView.resignFirstResponder()
        //        userInputTextView.becomeFirstResponder()
        
    }
    
    func requestTranslateData() {
        let url = EndPoint.translateURL
        let translatetext = self.userInputTextView.text ?? textViewPlaceholderText

        var parameter = ["source": "ko", "target": "en", "text": "\(translatetext)"]
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]

        AF.request(url, method: .post, parameters: parameter , headers: header).validate(statusCode: 200...500).responseData { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let statusCode = response.response?.statusCode ?? 500
                
                
                if statusCode == 200 {
                    parameter.updateValue(translatetext, forKey: "text")
                } else {
                    self.userInputTextView.text = json["errorMessage"].stringValue
                }
                
                let translatedtext = json["message"]["result"]["translatedText"].stringValue
                self.translateLabel.text = translatedtext
                
            case .failure(let error):
                print(error)
                
            }
        }
    }
}



extension TranslateViewController: UITextViewDelegate {
    // 텍스트뷰의 텍스트가 변할 때마다 호출
    func textViewDidChange(_ textView: UITextView) {
        print(textView.text.count)
        requestTranslateData()
    }
    
    // 편집이 시작될 때 -> 커서가 깜빡이기 시작할 때
    // 텍스트뷰 글자: 플레이스 홀더랑 글자가 같으면 clear, color
    func textViewDidBeginEditing(_ textView: UITextView) {
        print("Begin")
        if textView.textColor == .lightGray {
            textView.text = nil
            textView.textColor = .black
        }
    }
    
    // 편집이 끝났을 때 -> 커서가 없어지는 순간
    // 텍스트뷰 글자: 사용자가 아무 글자도 안 썼으면 플레이스 홀더 글자 보이게 해!
    func textViewDidEndEditing(_ textView: UITextView) {
        print("End")
        if textView.text.isEmpty {
            userInputTextView.text = textViewPlaceholderText
            userInputTextView.textColor = .lightGray
            
            
        }
    }
    
}
