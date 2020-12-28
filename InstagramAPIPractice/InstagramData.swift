//
//  instagramData.swift
//  InstagramAPIPractice
//
//  Created by Tai Chin Huang on 2020/12/22.
//

import Foundation

//struct InstagramProfileData: Codable {
//    let graphql: Graphql
//}
//struct Graphql: Codable {
//    let user: User
//}
//struct User: Codable {
//    let biography: String
//    let edge_followed_by: Int
//    let edge_follow: Int
//    let full_name: String
////    let profile_pic_url_hd: URL?
////    let profile_pic_url: URL?
//    let external_url: URL?
//    let username: String
//    let edge_owner_to_timeline_media: TimeLineMedia
//}
//struct TimeLineMedia: Codable {
//    let count: Int
//    let edges: [Edge]
//}
//struct Edge: Codable {
//    let node: Node
//}
//struct Node: Codable {
//    let display_url: URL?
//    let is_video: Bool?
//    let taken_at_timestamp: Date
//    let edge_liked_by: Int
//    let edge_media_to_caption: MediaToCaption
//    let thumbnail_src: URL
//}
//struct MediaToCaption: Codable {
//    let text: String
//}

struct InstagramData: Codable {
    let graphql: Graphql
    struct Graphql: Codable {
        //User information
        let user: User
        struct User: Codable {
            let biography: String //簡介
//            let external_url: URL //外部連結
            let full_name: String //ID名稱
            let profile_pic_url_hd: URL //大頭照
//            let profile_pic_url: URL
            let username: String //ID名稱
            let edge_followed_by: Edge_followed_by//被追蹤數
            struct Edge_followed_by: Codable {
                let count: Int
            }
            let edge_follow: Edge_follow //追蹤數
            struct Edge_follow: Codable {
                let count: Int
            }
            //Post Detail
            let edge_owner_to_timeline_media: Edge_owner_to_timeline_media
            struct Edge_owner_to_timeline_media: Codable {
                let count: Int //貼文數
                let edges: [Edges]
                struct Edges: Codable {
                    let node: Node
                    struct Node: Codable {
                        let shortcode: String?
                        let display_url: URL
                        let thumbnail_src: String? //圖片連結
                        let is_video: Bool?
                        let taken_at_timestamp: Double? //發布時間
                        let edge_media_to_caption: Edge_media_to_caption
                        struct Edge_media_to_caption: Codable {
                            let edges: [Edges]
                            struct Edges: Codable {
                                let node: Node
                                struct Node: Codable {
                                    let text: String //貼文文字內容
                                }
                            }
                        }
                        let edge_media_to_comment: Edge_media_to_comment?
                        struct Edge_media_to_comment: Codable {
                            let count: Int //貼文回文數
                        }
                        let edge_liked_by: Edge_liked_by
                        struct Edge_liked_by: Codable {
                            let count: Int //貼文按讚數
                        }
                    }
                }
            }
            //影片的部分，還沒使用
            let edge_felix_video_timeline: Edge_felix_video_timeline
            struct Edge_felix_video_timeline: Codable {
                let edges: [Edges]
                struct Edges: Codable {
                    let node: Node
                    struct Node: Codable {
                        let display_url: URL
                        let video_url: URL
                    }
                }
            }
        }
    }
}
