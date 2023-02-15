//
//  ViewsData.swift
//  intro-lab-DmitryGorbunow
//
//  Created by Dmitry Gorbunow on 2/5/23.
//

import Foundation

class DataManager {
    
    static let shared = DataManager()
    
    private let userDefaults = UserDefaults()
    
    private init() {}
    
    func setViews(url: String,  views: Int) {
        userDefaults.set(views, forKey: url)
    }
    
    func getViews(url: String) -> Int {
        userDefaults.integer(forKey: url)
    }
}

