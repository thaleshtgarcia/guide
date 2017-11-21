//
//  WebViewKit.swift
//  GuideClient
//
//  Created by thales.garcia on 20/11/17.
//  Copyright © 2017 thales.garcia. All rights reserved.
//

import WebKit

extension WKWebView {
    public func loadEmpty() {
        let emptyHTML = ""
        self.loadHTMLString(emptyHTML, baseURL: nil)
    }
}
