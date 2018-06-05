//
//  ViewController.swift
//  GuessNumber
//
//  Created by t19960804 on 2018/6/2.
//  Copyright © 2018年 t19960804. All rights reserved.
//

import UIKit
import SwifterSwift
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
//        if let urlStr = "http://data.ntpc.gov.tw/api/v1/rest/datastore/382000000A-000139-001".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr) {
//            let task = URLSession.shared.dataTask(with: url) { (data, response , error) in
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .iso8601
//                if let data = data, let object = try?
//                    decoder.decode(Object.self, from: data)
//                {
//                    for records in
//                    {
//                        print("名稱:",records.title)
//                    }
//                }
//                else {
//                    print("error")
//                }
//            }
//            task.resume()
//        }
        if let urlStr = "https://itunes.apple.com/search?term=薛之謙&media=music".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: urlStr) {
            let task = URLSession.shared.dataTask(with: url) { (data, response , error) in
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                if let data = data, let songResults = try?
                    decoder.decode(SongResults.self, from: data)
                {
                    for song in songResults.results {
                        print(song.trackName)
                    }
                } else {
                    print("error")
                }
            }
            task.resume()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

//    struct Object : Codable {
//
//        struct results : Codable {
//            var records : eachdata
//            struct eachdata : Codable{
//                var title :String
//                var address : String
//            }
//
//        }
//    }
    
}
struct SongResults: Codable {
    struct Song: Codable {
        var artistName: String
        var trackName: String
        var collectionName: String?
        var previewUrl: URL
        var artworkUrl100: URL
        var trackPrice: Double?
        var releaseDate: Date
        var isStreamable: Bool?
    }
    var resultCount: Int
    var results: [Song]
}
