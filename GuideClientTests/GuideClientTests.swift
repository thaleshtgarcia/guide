//
//  GuideClientTests.swift
//  GuideClientTests
//
//  Created by thales.garcia on 19/11/17.
//  Copyright © 2017 thales.garcia. All rights reserved.
//

import XCTest
@testable import GuideClient
@testable import Suas

class GuideClientTests: XCTestCase {
    
    var articles: Articles = ArticleReducer().initialState
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func test_RefreshArticles() {
        
        let expectation = self.expectation(description: "Refresh Articles")

        let store = Suas.createStore(reducer: ArticleReducer(), middleware: AsyncMiddleware()+LoggerMiddleware())
        _ = store.addListener(forStateType: Articles.self)  { [weak self] state in
            self?.articles = state
            guard let items = self?.articles.items else { return }
            XCTAssert(items.count > 0 , "Return items from request")
            expectation.fulfill()
        }
        store.dispatch(action:RefreshArticles(withCurrentState: self.articles))
        
        waitForExpectations(timeout: 5.0) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }

    func test_RefreshArticlesNextPage() {
        let articleList: [String: Any] = ["id" : 115015372868,
                                         "title" : "Minor UI design update for the Guide article editor",
                                         "body":  "<p><span style=\"font-weight: 400;\">Today we are releasing some minor UI changes to the Guide article editor. The overall functionality remains the same. </span><span style=\"font-weight: 400;\">We are releasing this update to pave the way for upcoming features that are planned for the article editor and knowledge base.</span></p>\n<p><span style=\"font-weight: 400;\">Here’s the new look for article editing.</span></p>\n<p><img src=\"https://support.zendesk.com/hc/article_attachments/115026127648/hc_article_editor_ui_update.png\" alt=\"hc_article_editor_ui_update.png\" /></p>\n<h2><strong>New button to save, publish, and unpublish</strong></h2>\n<p><span style=\"font-weight: 400;\">We’ve introduced a new, larger button that enables you to easily save your changes. The button also consolidates the ability to switch between a draft and a published article. Simply select “Publish” in a draft to publish it or select “Unpublish” in a published article to make it a draft.</span></p>\n<p><img src=\"https://support.zendesk.com/hc/article_attachments/115026127668/hc_article_editor_ui_update_button.png\" alt=\"hc_article_editor_ui_update_button.png\" /></p>\n<h2><strong>More space for authoring and editing</strong></h2>\n<p><span style=\"font-weight: 400;\">We\'ve expanded </span><span style=\"font-weight: 400;\">the white “paper” background in the article editor. This gives you more room for authoring and editing content so you can focus on the content writing experience.</span></p>",
                                         "updated_at" : "2017-11-20 21:28:53 +0000"]
        let articlesJSON: [String: Any] = ["page": 1,
                                           "next_page": "https://support.zendesk.com/api/v2/help_center/en-us/sections/200623776/articles.json?page=2&per_page=30",
                                           "previous_page": "",
                                           "articles": [articleList]]
        
        
        self.articles = Articles(articlesJSON)
        let expectation = self.expectation(description: "Refresh Articles Next Page")

        let store = Suas.createStore(reducer: ArticleReducer(), middleware: AsyncMiddleware())
        _ = store.addListener(forStateType: Articles.self)  { [weak self] state in
            self?.articles = state
            guard let items = self?.articles.items else { return }
            XCTAssert(items.count > 30 , "Return items from request")
            expectation.fulfill()
        }
        store.dispatch(action:RefreshArticles(withCurrentState: self.articles))

        waitForExpectations(timeout: 5.0) { (error) in
            if let error = error {
                XCTFail(error.localizedDescription)
            }
        }
    }
    
}
