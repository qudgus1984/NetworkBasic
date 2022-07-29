//
//  LottoViewController.swift
//  NetworkBasic
//
//  Created by 이병현 on 2022/07/28.
//

import UIKit

class LottoViewController: UIViewController {
    

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
        numberTextField.text = "\(numberList[row])회차"
        view.endEditing(true)

    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numberList[row])회차"
    }
    
}


