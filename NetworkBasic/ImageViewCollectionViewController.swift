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
        fetchImage()
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
    
    func fetchImage() {
        let text = "과자".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = EndPoint.imageSearchURL + "query=\(text)&display=30&start=1"
        
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.NAVER_ID, "X-Naver-Client-Secret": APIKey.NAVER_SECRET]
        
        AF.request(url, method: .get, headers: header).validate(statusCode: 200...500).responseJSON {  response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                
                for image in json["items"].arrayValue {
                    
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
