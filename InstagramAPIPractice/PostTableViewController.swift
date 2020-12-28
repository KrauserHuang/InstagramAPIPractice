//
//  PostTableViewController.swift
//  InstagramAPIPractice
//
//  Created by Tai Chin Huang on 2020/12/28.
//

import UIKit

class PostTableViewController: UITableViewController {
    
    @IBOutlet var tableViewSection: UITableView!
    var igdata: InstagramData!
    var igposts = [InstagramData.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    var indexPath: IndexPath!
    var isShow = false
    struct PropertyKey {
        static let postCell = "PostTableViewCell"
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if isShow == false {
            tableViewSection.scrollToRow(at: indexPath, at: .top, animated: false)
            isShow = true
        }
//        tableViewSection.scrollToRow(at: indexPath, at: UITableView.ScrollPosition.top, animated: false)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return igposts.count
    }
    //將所有資料顯示在tableView上
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: PropertyKey.postCell, for: indexPath) as! PostTableViewCell
        let postData = igposts[indexPath.row]
        cell.profileName.text = igdata.graphql.user.full_name
        cell.likedByLabel.text = "\(postData.node.edge_liked_by.count) likes"
        cell.postTextLabel.text = postData.node.edge_media_to_caption.edges[0].node.text
        //時間需要透過DateFormatter()轉換
        let timestamp = postData.node.taken_at_timestamp
        let timetaken = Date(timeIntervalSince1970: timestamp!)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        let dateString = dateFormatter.string(from: timetaken)
        cell.postTimeLabel.text = dateString
        //postImageURL是String所以要再轉一次
        if let postImageURL = postData.node.thumbnail_src,
           let url = URL(string: postImageURL) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.postImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        URLSession.shared.dataTask(with: igdata.graphql.user.profile_pic_url_hd) { (data, response, error) in
            if let data = data {
                DispatchQueue.main.async {
                    cell.profileImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        // Configure the cell...

        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
