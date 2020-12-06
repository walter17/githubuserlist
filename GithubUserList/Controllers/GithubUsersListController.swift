//
//  GithubUsersListController.swift
//  GithubUserList
//
//  Created by John Walter Ramos on 12/3/20.
//

import UIKit

// Custom Class of TableViewCell
class GithubUserTableCell: UITableViewCell {
    @IBOutlet weak var UserImg: UIImageView!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDetail: UILabel!
    @IBOutlet weak var imgStatsIcon: UIImageView!
}

class GithubUsersListController: UITableViewController {
    private var gitUsers: Array<GitUsers>?
    private var apiError: NSError?
    private var listPage: Int?
    private var selectedUser: GitUsers?
    private var loadingOnFooterView: UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        listPage = 0 // Start with Page 0
        
        loadingOnFooterView = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 50)) // Initiate activity indicator
        
        reloadPage() // Initial call
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.gitUsers?.count ?? 0
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellValue = self.gitUsers?[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "UsersCell", for: indexPath) as! GithubUserTableCell
        
        cell.lblTitle?.text = cellValue?.txtLogin ?? ""
        cell.lblDetail?.text = cellValue?.txtHTMLUrl ?? ""
        
        if (!(cellValue?.isSiteAdmin)!) {
            cell.imgStatsIcon.isHidden = true
        }
        // Load url to imageview
        GitAPI.loadFrom(url: URL(string: cellValue?.txtAvatarURL ?? "")!) { image in
            cell.UserImg.image = image
        }
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let totalRows = self.gitUsers!.count
        let currentRow : Int = indexPath.row
        
        if(currentRow >= totalRows - 4){
            self.loadingOnFooterView?.startAnimating()
            listPage = listPage! + 1
            reloadPage()
        }
        else{
            self.loadingOnFooterView?.stopAnimating()
        }
    }
    
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return self.loadingOnFooterView
    }

    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedUser = self.gitUsers?[indexPath.row]
        self.performSegue(withIdentifier: "ShowProfile", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if segue.identifier == "ShowProfile" {
            let controller = segue.destination as! GithubUserProfileViewController
            controller.githubUsername = selectedUser?.txtLogin
               
            
        }
    }
    // Functions
    // Retrieve Github Users to List
   func reloadPage(){
        GitAPI().fetchGithubUsers(page: self.listPage!) { [weak self] (apiGitUsers, apiErrorThrow) in
            
            // Store mutated values over a variable
            var mutArr: Array<GitUsers> = self?.gitUsers ?? []
            mutArr.append(contentsOf: apiGitUsers) // Run append
            
            self?.gitUsers = mutArr
            self?.apiError = apiErrorThrow
            DispatchQueue.main.async {
              self?.tableView.reloadData()
            }
          }
    }    

}
