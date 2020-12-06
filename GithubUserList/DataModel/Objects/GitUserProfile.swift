//
//  GitUserProfile.swift
//  GithubUserList
//
//  Created by John Walter Ramos on 12/6/20.
//

import Foundation

// Class Object for Github Users Information
class GitUserProfile: Codable {
    
    var txtLogin: String!
    var intGithubId: Int!
    var txtxNodeId: String!
    var txtAvatarURL: String!
    var txtBlogUrl: String!
    var txtHTMLUrl: String!
    var txtFollowers: Int!
    var txtFollowing: Int!
    var txtCompany: String!
    var txtName: String!
    
    enum GitUsers: String, CodingKey
    {
        case login, id, node_id, blog, avatar_url, html_url, followers, following,name, company
    }
    
    required init (from decoder: Decoder) throws {
        let container =  try decoder.container (keyedBy: GitUsers.self)
        txtLogin = try container.decode (String.self, forKey: .login)
        intGithubId = try container.decode (Int.self, forKey: .id)
        txtxNodeId = try container.decode (String.self, forKey: .node_id)
        txtAvatarURL = try container.decode (String.self, forKey: .avatar_url)
        txtHTMLUrl = try container.decode (String.self, forKey: .html_url)
        txtBlogUrl = try container.decode (String.self, forKey: .blog)
        txtFollowers = try container.decode (Int.self, forKey: .followers)
        txtFollowing = try container.decode (Int.self, forKey: .following)
        txtName = try container.decode (String.self, forKey: .name)
        txtCompany = try container.decode (String.self, forKey: .company)
    }
    
}
