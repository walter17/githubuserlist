//
//  GitUsers.swift
//  GithubUserList
//
//  Created by John Walter Ramos on 12/3/20.
//

import Foundation
import CoreData

// Class Object for Github Users Information
class GitUsers: Codable {
    var txtLogin: String!
    var txtAvatarURL: String!
    var txtHTMLUrl: String!
    var isSiteAdmin: Bool!
    
    enum GitUsers: String, CodingKey
    {
        case login, site_admin, avatar_url, html_url
    }
    
    
    required init (from decoder: Decoder) throws {
        let container =  try decoder.container (keyedBy: GitUsers.self)
        txtLogin = try container.decode (String.self, forKey: .login)
        txtAvatarURL = try container.decode (String.self, forKey: .avatar_url)
        txtHTMLUrl = try container.decode (String.self, forKey: .html_url)
        isSiteAdmin = try container.decode (Bool.self, forKey: .site_admin)
    }
    
    
   

    
}


