//
//  ViewController.swift
//  GithubUserList
//
//  Created by John Walter Ramos on 12/3/20.
//

import UIKit

class GithubUserProfileViewController: UITableViewController {
    @IBOutlet weak var imgAvatar: UIImageView!
    @IBOutlet weak var lblFollowers: UILabel!
    
    @IBOutlet weak var navLabel: UINavigationItem!
    @IBOutlet weak var txtNotes: UITextView!
    @IBOutlet weak var lblBlogURL: UILabel!
    @IBOutlet weak var lbCompanty: UILabel!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblFollowing: UILabel!
    
    public var githubUsername: String!
    private var userProfileInfo: GitUserProfile!
    private var apiError: NSError?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Load initial data
        self.navLabel.title = githubUsername ?? ""
        self.lblFollowers.text = ""
        self.lblFollowing.text = ""
        self.lblName.text = ""
        self.lbCompanty.text = ""
        self.lblBlogURL.text = ""
        self.txtNotes.text = ""
        
        self.imgAvatar.image = UIImage (named: "avatarPlaceholder")
        
        // Call api and configure data
        GitAPI().fetchUserProfile(username: githubUsername ?? "") { [weak self] (apiUserProfile, apiErrorThrow) in
            
            if (apiErrorThrow.code == 200) { // Means, Success
                print(apiUserProfile)
                self?.userProfileInfo = apiUserProfile as? GitUserProfile
                if (self?.userProfileInfo != nil) {
                    GitAPI.loadFrom(url: URL(string: self?.userProfileInfo.txtAvatarURL ?? "")!) { image in
                        self?.imgAvatar.image = image
                    }
                    self?.loadDataProfile(info: apiUserProfile as! GitUserProfile)
                   
                    
                }
            }else{ // Something went wrong
                self?.apiError = apiErrorThrow
                
                let alert = UIAlertController(title: "Something went wrong!", message: apiErrorThrow.localizedDescription, preferredStyle: .alert)

                alert.addAction(UIAlertAction(title: "Got It!", style: .cancel, handler: nil))
  

                self?.present(alert, animated: true)
            }
          }
        
    }
    
    func loadDataProfile(info: GitUserProfile){
        self.lblFollowers.text = "Followers: \(info.txtFollowers ?? 0)"
        self.lblFollowing.text = "Following: \(info.txtFollowing ?? 0)"
        
        self.lblName.text = "Name: \(String(describing: info.txtName))"
        self.lbCompanty.text = "Company: \(String(describing: info.txtCompany))"
        self.lblBlogURL.text = "Blog: \(String(describing: info.txtBlogUrl))"
        
    }
    
    
    // Button Action to Save Notes
    @IBAction func notesOnSave(_ sender: UIButton) {
        
    }
    

}

