//
//  ApiClient.swift
//  Animation
//
//  Created by Казюка Руслан Сергеевич on 10.01.18.
//  Copyright © 2018 Казюка Руслан Сергеевич. All rights reserved.
//
import Foundation
import Alamofire

class ApiClient {
    
    static let sharedInstance = ApiClient()
    
    func getAnimationByInputString( completion : @escaping ([NSDictionary]) -> (),  error:@escaping (String)->()) {
        
        Alamofire.request("http://api.giphy.com/v1/gifs/search?q=funny+cat&api_key=\(ApiConstants.apiKey)", method: .get, parameters: nil, encoding: JSONEncoding.default)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
            }.validate().responseJSON { (response) in
                
                switch response.result {
                    
                case .success:
                    let dictionary = try! JSONSerialization.jsonObject(with: response.data!, options: []) as? NSDictionary
                    let animationsArray = dictionary!["data"] as! [NSDictionary]
                    completion(animationsArray)
                    break
                    
                case .failure( _):
                    error(response.debugDescription)
                }
        }
    }
}
