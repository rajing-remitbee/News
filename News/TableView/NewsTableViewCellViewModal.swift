//
//  NewsTableViewCellViewModal.swift
//  News
//
//  Created by Rajin Gangadharan on 04/02/25.
//

import Foundation

//NewsTable ViewModel Class
class NewsTableViewCellViewModel {
    
    let title: String
    let subtitle: String
    let imageURL: URL?
    var imageData: Data? = nil
    
    //Constructor
    init(title: String, subtitle: String, imageURL: URL?) {
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
    }
}
