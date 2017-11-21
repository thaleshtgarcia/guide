//
//  ArticleActions.swift
//  GuideClient
//
//  Created by thales.garcia on 19/11/17.
//  Copyright © 2017 thales.garcia. All rights reserved.
//

import Foundation
import Suas

struct RefreshArticles: AsyncAction {
    
    var currentState: Articles
    var isLoading: Bool = false
    
    init(withCurrentState state: Articles) {
        self.currentState = state
    }
    
    func execute(getState: @escaping GetStateFunction, dispatch: @escaping DispatchFunction) {
        
        var urlString: String?
        if self.currentState.page == 0 {
            urlString = Endpoint.Category.announcements
        } else if let nextPage = self.currentState.nextPage {
            urlString = nextPage
        }
        
        if let string = urlString, let url = URL(string: string) {
            self.request(withURL: url, currentState: self.currentState, getState: getState, dispatch: dispatch)
        }
    }
    
    private func request(withURL url: URL, currentState: Articles, getState: @escaping GetStateFunction, dispatch: @escaping DispatchFunction) {
        DispatchQueue.global().async {
            URLSession(configuration: .default).dataTask(with: url) { data, response, error in
                
                let responseSerialized = try! JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                
                if !currentState.items.isEmpty {
                    let articleList = Articles(responseSerialized, currentArticles: currentState.items)
                    dispatch(RefreshTableView(newItems: articleList))
                } else {
                    let articleList = Articles(responseSerialized)
                    dispatch(RefreshTableView(newItems: articleList))
                }
                }.resume()
        }
    }
}

struct RefreshTableView: Action {
    let newItems: Articles
}
