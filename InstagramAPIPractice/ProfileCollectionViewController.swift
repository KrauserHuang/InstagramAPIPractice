//
//  ProfileCollectionViewController.swift
//  InstagramAPIPractice
//
//  Created by Tai Chin Huang on 2020/12/22.
//

import UIKit

private let reuseIdentifier = "\(PostGridCollectionViewCell.self)"

class ProfileCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    struct PropertyKeys {
        static let header = "ProfileCollectionReusableView"
        static let imageCell = "PostGridCollectionViewCell"
    }
    //定義變數遵守InstagramData.swift設定的型別
    var igdata: InstagramData!
    var igposts = [InstagramData.Graphql.User.Edge_owner_to_timeline_media.Edges]()
    
    func fetchData() {
//        if let urlStr = "https://www.instagram.com/scottcbakken/?__a=1".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
//           let url = URL(string: urlStr) {
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                if let data = data {
//                    let decoder = JSONDecoder()
//                    decoder.dateDecodingStrategy = .secondsSince1970
//                    do {
//                        let instagramData = try decoder.decode(InstagramData.self, from: data)
//                        self.igdata = instagramData
//                        self.igposts = instagramData.graphql.user.edge_owner_to_timeline_media.edges
//                        DispatchQueue.main.async {
//                            self.collectionView.reloadData()
//                        }
//                    } catch  {
//                        print("error")
//                    }
//                }
//            }.resume()
//        }
        //使用URLSession來抓取需要的資料
        let urlStr = "https://www.instagram.com/scottcbakken/?__a=1"
        if let url = URL(string: urlStr) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                if let data = data,
                   let renderData = try? decoder.decode(InstagramData.self, from: data) {
                    self.igdata = renderData
                    self.igposts = renderData.graphql.user.edge_owner_to_timeline_media.edges
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }.resume()
        }
    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        return UIEdgeInsets(top: 463, left: 0, bottom: 0, right: 0)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
//        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
        fetchData()
        collectionViewLayout()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return igposts.count
    }
    //照片牆部分
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PropertyKeys.imageCell, for: indexPath) as! PostGridCollectionViewCell
        // Configure the cell
//        let post = igposts[indexPath.item]
//        URLSession.shared.dataTask(with: post.node.thumbnail_src) { (data, response, error) in
//            if let data = data {
//                DispatchQueue.main.async {
//                    cell.postGridImageView.image = UIImage(data: data)
//                }
//            }
//        }
        //將圖片透過data抓下來變成image再回傳給cell
        if let postImageURL = igposts[indexPath.item].node.thumbnail_src,
           let url = URL(string: postImageURL) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.postGridImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
        return cell
    }
    //個人介紹、貼文數、被追蹤數、追蹤數
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let reusableCell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PropertyKeys.header, for: indexPath) as! ProfileCollectionReusableView
        reusableCell.profileImageView.layer.cornerRadius = reusableCell.profileImageView.frame.height / 2
        
        if igdata != nil {
            reusableCell.profileName.text = igdata.graphql.user.full_name
//            reusableCell.postsNumLabel.text = "\(igdata.graphql.user.edge_owner_to_timeline_media.count)"
            reusableCell.postsNumLabel.text = postsNumConvert(igdata.graphql.user.edge_owner_to_timeline_media.count)
//            reusableCell.followersNumLabel.text = "\(igdata.graphql.user.edge_followed_by.count)"
            reusableCell.followersNumLabel.text = followerNumConvert(igdata.graphql.user.edge_followed_by.count)
//            reusableCell.followingNumLabel.text = "\(igdata.graphql.user.edge_follow.count)"
            reusableCell.followingNumLabel.text = followingNumConvert(igdata.graphql.user.edge_follow.count)
            reusableCell.biographyLabel.text = igdata.graphql.user.biography
            //抓圖的部分都移至main thread
            URLSession.shared.dataTask(with: igdata.graphql.user.profile_pic_url_hd) { (data, response, error) in
                if let data = data {
                    DispatchQueue.main.async {
                        reusableCell.profileImageView.image = UIImage(data: data)
                    }
                }
            }.resume()
        }
//        let urlStr = "https://www.instagram.com/scottcbakken/?__a=1"
//        if let url = URL(string: urlStr) {
//            URLSession.shared.dataTask(with: url) { (data, response, error) in
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//                if let data = data,
//                   let image = UIImage(data: data),
//                   let instagramData = try? decoder.decode(InstagramData.self, from: data) {
//                    let profileData = instagramData.graphql.user
//                    DispatchQueue.main.async {
//                        reusableCell.profileName.text = profileData.full_name
//                        reusableCell.postsNumLabel.text = "\(profileData.edge_owner_to_timeline_media.count)"
////                        reusableCell.postsNumLabel.text = self.followerNumConvert(profileData.edge_owner_to_timeline_media.count)
//                        reusableCell.followersNumLabel.text = "\(profileData.edge_followed_by.count)"
////                        reusableCell.followersNumLabel.text = self.followerNumConvert(profileData.edge_followed_by)
//                        reusableCell.followingNumLabel.text = "\(profileData.edge_follow.count)"
//                        reusableCell.biographyLabel.text = profileData.biography
//                        reusableCell.profileImageView.image = UIImage(data: profileData.profile_pic_url_hd)
//                    }
//                }
//            }.resume()
//        }
        return reusableCell
    }
    //調整照片牆的擺放
    func collectionViewLayout() {
        let flowLayout = collectionViewLayout as? UICollectionViewFlowLayout
        let itemSpace: CGFloat = 1
        let columeCount: CGFloat = 3
        let itemWidth = floor((collectionView.bounds.width-itemSpace*(columeCount-1))/columeCount)
        flowLayout?.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout?.estimatedItemSize = .zero
        flowLayout?.minimumInteritemSpacing = itemSpace
        flowLayout?.minimumLineSpacing = itemSpace
    }
    //被追蹤數轉換
    func followerNumConvert(_ num: Int) -> String {
        if num > 1000000 {
            return "\(num / 1000000)M"
        } else if num > 1000 {
            return "\(num / 1000)K"
        } else {
            return String(num)
        }
    }
    func postsNumConvert(_ num: Int) -> String {
        if num > 1000 {
            return "\(num / 1000),"+"\(num % 1000)"
        } else {
            return String(num)
        }
    }
    func followingNumConvert(_ num: Int) -> String {
        if num > 1000 {
            return "\(num / 1000),"+"\(num % 1000)"
        } else {
            return String(num)
        }
    }
    //將collectionView的資料傳送到PostTableViewController顯示
    @IBSegueAction func showPost(_ coder: NSCoder) -> PostTableViewController? {
        guard let item = collectionView.indexPathsForSelectedItems?.first else { return nil }
        let controller = PostTableViewController(coder: coder)
        controller?.igdata = igdata
        controller?.igposts = igposts
        controller?.indexPath = item
        return controller
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
