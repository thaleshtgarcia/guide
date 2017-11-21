//
//  ArticleReducer.swift
//  GuideClient
//
//  Created by thales.garcia on 19/11/17.
//  Copyright © 2017 thales.garcia. All rights reserved.
//

import Foundation
import Suas

struct ArticleReducer: Reducer {
    
    typealias StateType = Articles
    
    var initialState: Articles = Articles()
    
    func reduce(state: ArticleReducer.StateType, action: Action) -> ArticleReducer.StateType? {
    
        if let action = action as? RefreshTableView {
            return action.newItems
        }
        return nil
    }
}
