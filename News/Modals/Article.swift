//
//  Article.swift
//  News
//
//  Created by Rajin Gangadharan on 04/02/25.
//

import Foundation

//Article Modal
struct Article: Codable {
    let source: Source
    let title: String
    let description: String?
    let url: String?
    let urlToImage: String?
    let publishedAt: String
}
