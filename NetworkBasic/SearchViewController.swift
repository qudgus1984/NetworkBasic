//
//  SearchViewController.swift
//  NetworkBasic
//
//  Created by 이병현 on 2022/07/27.
//

import UIKit

import Alamofire
import SwiftyJSON

/*
 Swift Protocol
 - Delegate
 - Datasource
 
 1. 왼팔 / 오른팔
 2. 테이블뷰 아웃렛 연결
 3. 1 + 2
 */

/*
 각 json value -> list -> 테이블뷰 갱신
 서버의 응답이 몇개인 지 모를 경우에는?

 let movieNm1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
 let movieNm2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
 let movieNm3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue

 // list 배열에 데이터 추가
 self.list.append(movieNm1)
 self.list.append(movieNm2)
 self.list.append(movieNm3)

 // 테이블뷰 갱신
 self.searchTableView.reloadData()
 */

extension UIViewController {
    func setBackground() {
        view.backgroundColor = .red
    }
}

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {


    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var searhBar: UISearchBar!

    // BoxOffice 배열
    var list: [BoxOfficeModel] = []


    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.backgroundColor = .clear
        // 연결고리 작업 : 테이블뷰가 해야 할 역할 > 뷰 컨트롤러에게 요청
        searchTableView.delegate = self
        searchTableView.dataSource = self
        // 테이블뷰가 사용할 테이블 뷰 셀(XIB) 등록
        //XIB: xml interface builder <= NIB
        searchTableView.register(UINib(nibName: ListTableViewCell.reuseIdentifier, bundle: nil), forCellReuseIdentifier: ListTableViewCell.reuseIdentifier)

        searhBar.delegate = self
        requestBoxOffice(text: "20220801")

    }

    func configureView() {
        searchTableView.backgroundColor = .clear
        searchTableView.separatorColor = .clear
        searchTableView.rowHeight = 80

    }

    func requestBoxOffice(text: String) {

        self.list.removeAll()

        let url = "\(EndPoint.boxOfficeURL)key=\(APIKey.BOXOFFICE)&targetDt=\(text)"
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")


                for movie in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {

                    let movieNm = movie["movieNm"].stringValue
                    let openDt = movie["openDt"].stringValue
                    let audiAcc = movie["audiAcc"].stringValue

                    let data = BoxOfficeModel(movieTitle: movieNm, releaseDate: openDt, totalCount: audiAcc)

                    self.list.append(data)

                }
                print(self.list)



                // 테이블뷰 갱신
                self.searchTableView.reloadData()

            case .failure(let error):
                print(error)
            }
        }
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.reuseIdentifier, for: indexPath) as? ListTableViewCell else { return UITableViewCell() }

        cell.backgroundColor = .clear
        cell.titleLabel.font = .boldSystemFont(ofSize: 22)
        cell.titleLabel.text = "\(list[indexPath.row].movieTitle): \(list[indexPath.row].releaseDate)"

        return cell
    }


}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        requestBoxOffice(text: searchBar.text ?? "8글자 날짜 변경")
    }
}
