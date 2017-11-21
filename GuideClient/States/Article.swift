//
//  Article.swift
//  GuideClient
//
//  Created by thales.garcia on 19/11/17.
//  Copyright © 2017 thales.garcia. All rights reserved.
//

import Foundation

//MARK: - State Article
struct Article {
    var id: Int
    var title: String
    var body: String
    var updatedAt: Date
}

extension Article {
    init(_ values: [String: Any] ) {
        id = values["id"] as? Int ?? 0
        title = values["title"] as? String ?? ""
        body = values["body"] as? String ?? ""
        
        let dateAsString = values["updated_at"] as? String ?? ""
        updatedAt = dateAsString.toDate() ?? Date()
    }
}

//MARK: - State Articles
struct Articles {
    var page: Int
    var nextPage: String?
    var previousPage: String?
    var items: [Article]

}

extension Articles {
    
    init() {
        page = 0
        items = [Article]()
    }
    
    init(_ values: [String: Any], currentArticles:[Article]? = nil) {
        page = values["page"] as? Int ?? 0
        nextPage = values["next_page"] as? String
        previousPage = values["previous_page"] as? String
        
        var articles = [Article]()
        if let articleList = values["articles"] as? [[String: Any]] {
            for item in articleList {
                let article = Article(item)
                articles.append(article)
            }
        }
        
        if let oldArticles = currentArticles {
            items = oldArticles + articles
        } else {
            items = articles
        }
    }
}
