//
//  GitAPI.swift
//  GithubUserList
//
//  Created by John Walter Ramos on 12/3/20.
//

import Foundation
import UIKit


final class GitAPI: Decodable {
    
    
    // API Function that retrieves User List
    public func fetchGithubUsers(page: Int,completionHandler: @escaping (_ result: Array<GitUsers>, _ apiError: NSError) -> Void) {
        let domainURL = Constants.API_BASEURL.appending("users?since=\(page)")
        var request = URLRequest(url: URL(string: domainURL)!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared

        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
      
            do {
                // Retrieve Data and return array results
                let gitUsersDecoded = try JSONDecoder().decode(Array<GitUsers>.self, from: data!)
                
                completionHandler(gitUsersDecoded, NSError(domain: domainURL, code: 200, userInfo: [NSLocalizedDescriptionKey : "Error not Found!"]))
                
                TempStorage().SaveUserInfoToDB(entityValues: gitUsersDecoded, entityName: "GithubUser")
              
                
            } catch {
                // Something went wrong
                completionHandler([], NSError(domain: domainURL, code: 500, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription]))
            }
        })

        task.resume()
       
    }
    
    
    // API Function that retrieves User Profile
    public func fetchUserProfile(username: String,completionHandler: @escaping (_ result: AnyObject, _ apiError: NSError) -> Void) {
        let domainURL = Constants.API_BASEURL.appending("users/\(username)")
        var request = URLRequest(url: URL(string: domainURL)!)
        request.httpMethod = "GET"
        
        let session = URLSession.shared

        let task = session.dataTask(with: request, completionHandler: { data, response, error -> Void in
      
            do {
                // Retrieve Data and return array results
                let gitUserProfileDecoded = try JSONDecoder().decode(GitUserProfile.self, from: data!)
                
                completionHandler(gitUserProfileDecoded, NSError(domain: domainURL, code: 200, userInfo: [NSLocalizedDescriptionKey : "Error not Found!"]))
            } catch {
                // Something went wrong
                completionHandler(NSError(), NSError(domain: domainURL, code: 500, userInfo: [NSLocalizedDescriptionKey : error.localizedDescription]))
            }
        })

        task.resume()
       
    }
    
    
    
    // Image Downloader
    public static func loadFrom(url: URL, completion: @escaping (_ image: UIImage?) -> ()) {
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                DispatchQueue.main.async {
                    completion(UIImage(data: data))
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    

}

