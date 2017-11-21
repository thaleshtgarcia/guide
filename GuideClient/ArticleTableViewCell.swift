//
//  ArticleTableViewCell.swift
//  GuideClient
//
//  Created by thales.garcia on 19/11/17.
//  Copyright © 2017 thales.garcia. All rights reserved.
//

import UIKit
import WebKit

class ArticleTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var lastUpdateLabel: UILabel!
    @IBOutlet weak var bodyWebView: WKWebView!
    
    
    func setup(withArticle article:Article) {
        self.bodyWebView.loadEmpty()
        self.titleLabel.text = article.title
        self.lastUpdateLabel.text = article.updatedAt.toString(withFormat: "E, d MMM yyyy HH:mm")
        self.bodyWebView.loadHTMLString(article.body, baseURL: nil)
        
    }
    
    override func awakeFromNib() {
        self.bodyWebView.scrollView.isScrollEnabled = false
        self.bodyWebView.scrollView.bouncesZoom = false
    }
}

