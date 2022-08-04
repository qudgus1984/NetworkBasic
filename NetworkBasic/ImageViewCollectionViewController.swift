//
//  ImageViewCollectionViewController.swift
//  NetworkBasic
//
//  Created by 이병현 on 2022/08/04.
//
import UIKit

import Alamofire
import SwiftyJSON
import Kingfisher



class ImageViewCollectionViewController: UICollectionViewController {
    
    var list: [imageModel] = []
    
    //네트워크 요청할 시작 페이지 넘버
    var startPage = 1
    var totalCount = 0

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        let width = UIScreen.main.bounds.width - (spacing * 3)
        
        layout.itemSize = CGSize(width: width / 2, height: (width / 2) * 1.2 )
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing
        
        collectionView.collectionViewLayout = layout
        collectionView.prefetchDataSource = self
        searchBar.delegate = self
    
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageViewCollectionViewCell.identifier, for: indexPath) as! ImageViewCollectionViewCell
        
        let url = URL(string: list[indexPath.row].imageUrl)
        cell.searchImageView.kf.setImage(with: url)
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    //페이지네이션 방법1. 컬렉션뷰가 특정 셀을 그리려는 시점에 호출되는 메서드
    //마지막 셀에 사용자가 위치해있는 지 명확하게 확인하기 어려움
    //권장하는 방식 x
//    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
//        <#code#>
//    }
//
    //페이지네이션 방법2. UIScrollViewDelegateProtocol
    //테이블뷰/컬렉션뷰 스크롤뷰를 상속받고 있어서, 스크롤뷰 프로토콜을 사용할 수 있음
//    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print(scrollView.contentOffset)
//    }
    
    
    func fetchImage(query: String) {
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=\(startPage)"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseData {  response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                self.totalCount = json["total"].intValue
                
                
                for image in json["items"].arrayValue {
                    
                    //셀에서 URL, UIImage 변환을 할 건지
                    //서버통신받는 시점에서 URL, UIImage 변환을 할 건지 -> 시간 오래걸림
                    
                    let imageUrl = image["thumbnail"].stringValue
                    
                    let data = imageModel(imageUrl: imageUrl)
                    
                    self.list.append(data)
                }
                
                self.collectionView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

extension ImageViewCollectionViewController: UISearchBarDelegate {
    
    //검색 버튼 클릭 시 실행. 검색 단어가 바뀔 수 있음
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            list.removeAll()
            startPage = 1
            fetchImage(query: text)
        }
    }
    //취소 버튼 눌렀을 때 실행
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        list.removeAll()
        collectionView.reloadData()
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
    }
    
    //서치바에 커서가 깜빡이기 시작할 때 실행
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
    }
}

//페이지네이션 방법3. 용량이 큰 이미지를 다운받아 셀에 보여주려고 하는 경우에 효과적
//셀이 화면에 보이기 전에 미리 필요한 리소스를 다운받을 수도 있고, 필요하지 않다면 데이터를 취소할 수도 있음
//iOS10 이상, 스크롤 성능 향상
extension ImageViewCollectionViewController: UICollectionViewDataSourcePrefetching {
    
    //셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 가능
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for indexPath in indexPaths {
            if list.count - 1 == indexPath.item && list.count < totalCount {
                startPage += 30
                fetchImage(query: searchBar.text!)

            }
        }
        
        print("===\(indexPaths)")
    }
    
    //취소: 직접 취소하는 기능을 구현해야 함
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("===취소\(indexPaths)")
    }
}
