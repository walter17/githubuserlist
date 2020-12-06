//
//  ErrorWatch.swift
//  GithubUserList
//
//  Created by John Walter Ramos on 12/5/20.
//

import UIKit
import Foundation
import CoreData

let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

class TempStorage: NSObject {
    
    override init() {
        super.init()
    }
    
    func SaveUserInfoToDB(entityValues: Array<GitUsers>, entityName: String) -> Void {
       
        let entity = NSEntityDescription.entity(forEntityName: entityName, in: context)
        let newUser = NSManagedObject(entity: entity!, insertInto: context)
        
        for item in entityValues{
            newUser.setValue(item.txtLogin ?? "", forKey: "login")
            newUser.setValue(item.isSiteAdmin ?? false, forKey: "site_admin")
            newUser.setValue(item.txtHTMLUrl ?? "", forKey: "html_url")
            newUser.setValue(item.txtAvatarURL ?? "", forKey: "avatar_url")
            
            do {
               try context.save()
              } catch {
               print("Failed saving")
            }
        }
        
        
    }
    
    func GetSavedInfoFromDb(entityName: String, completionHandler: @escaping (_ resultArr: Array<GitUsers>) -> Void) {
    
        var userInfoArr: Array<GitUsers>?
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
                request.returnsObjectsAsFaults = false
        
                do {
                    let result = try context.fetch(request)
                 
                    for data in result as! [NSManagedObject] {
                        userInfoArr?.append(GitUsers(
                                                login: (data.value(forKey: "login") as? String)!,
                                                avatarUrl: (data.value(forKey: "avatar_url") as? String)!,
                                                HtmlURl: (data.value(forKey: "html_url") as? String)!,
                                                siteAdmin: (data.value(forKey: "site_admin") as? Bool)!))
                        
                    }
                    completionHandler(userInfoArr ?? [])
                    
                } catch {
                    
                    completionHandler([])
                }
        
        
       
    }
}
