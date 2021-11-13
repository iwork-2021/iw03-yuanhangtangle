//
//  NewsItem.swift
//  ITSC
//
//  Created by yuanhang on 2021/11/9.
//

import UIKit

class NewsItem: NSObject {
    var title: String
    var date: String
    var url: String
    var text: String
    
    init(title: String="", date: String="", url:String="", text:String=""){
        self.title = title
        self.date = date
        self.url = url
        self.text = text
    }

}
