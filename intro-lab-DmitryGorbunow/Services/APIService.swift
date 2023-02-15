//
//  NetworkManager.swift
//  intro-lab-DmitryGorbunow
//
//  Created by Dmitry Gorbunow on 2/3/23.
//

import Foundation

class APIService: NSObject {
    
    func getDataWith(page: Int, completion: @escaping (Result<[[String: AnyObject]]>) -> Void) {
        guard let url = URL(string: "https://newsapi.org/v2/everything?q=tinkoff&apiKey=\(APIKey.key)&pageSize=20&page=\(page)" ) else { return completion(.Error("Invalid URL, we can't update your feed")) }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return completion(.Error(error!.localizedDescription)) }
            guard let data = data else { return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    guard let itemsJsonArray = json["articles"] as? [[String: AnyObject]] else {
                        return completion(.Error(error?.localizedDescription ?? "There are no new Items to show"))
                    }
                    DispatchQueue.main.async {
                        completion(.Success(itemsJsonArray))
                    }
                }
            } catch let error {
                return completion(.Error(error.localizedDescription))
            }
        }.resume()
    }
}

enum Result <T>{
    case Success(T)
    case Error(String)
}
