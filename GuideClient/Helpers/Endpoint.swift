//
//  Endpoint.swift
//  GuideClient
//
//  Created by thales.garcia on 20/11/17.
//  Copyright © 2017 thales.garcia. All rights reserved.
//

import Foundation

public struct Endpoint {

    private struct Domain {
        static public var host: String = "https://support.zendesk.com/api/v2/help_center/en-us/sections"
    }
    
    public struct Category {
        static public let announcements: String = Domain.host + "/200623776/articles.json"
    }
    
}
