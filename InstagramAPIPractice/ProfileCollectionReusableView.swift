//
//  ProfileCollectionReusableView.swift
//  InstagramAPIPractice
//
//  Created by Tai Chin Huang on 2020/12/23.
//

import UIKit

class ProfileCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postsNumLabel: UILabel!
    @IBOutlet weak var followersNumLabel: UILabel!
    @IBOutlet weak var followingNumLabel: UILabel!
    @IBOutlet weak var profileName: UILabel!
    @IBOutlet weak var biographyLabel: UILabel!
}
