//
//  NewsTableViewCell.swift
//  News
//
//  Created by Rajin Gangadharan on 03/02/25.
//

import UIKit

//News ItemView Cell
class NewsTableViewCell: UITableViewCell {
    
    //Identifier for reusing cell
    static let identifier = "NewsTableViewCell"
    
    //Title label component
    private let newsTitleLabel: UILabel = {
        let label = UILabel() //Initialize
        label.numberOfLines = 0 //Number of lines
        label.font = .systemFont(ofSize: 20, weight: .semibold) //Font properties
        return label
    }()
    
    //Subtitle label component
    private let newsSubTitleLabel: UILabel = {
        let label = UILabel() //Initialize
        label.numberOfLines = 0 //Number of lines
        label.font = .systemFont(ofSize: 17, weight: .light) //Font Properties
        return label
    }()
    
    //ImageView component
    private let newsImageView: UIImageView = {
        let imageView = UIImageView() //Initialize
        imageView.backgroundColor = .secondarySystemBackground //Background Color
        imageView.clipsToBounds = true //Hide exceeding contents
        imageView.layer.cornerRadius = 6 //Corner Radius
        imageView.layer.masksToBounds = true //Clip the content to the boundary
        imageView.contentMode = .scaleAspectFill //Apply Fit to scale
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //Add subviews - Title, Subtitle and ImageView
        contentView.addSubview(newsTitleLabel)
        contentView.addSubview(newsSubTitleLabel)
        contentView.addSubview(newsImageView)
    }
    
    //Required constructor for UITableViewCell
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    //LayoutSubviews method
    override func layoutSubviews() {
        super.layoutSubviews()
        //Title view properties
        newsTitleLabel.frame = CGRect(
            x: 10,
            y: 0,
            width: contentView.frame.size.width - 170,
            height: 70
        )
        //Subtitle properties
        newsSubTitleLabel.frame = CGRect(
            x: 5,
            y: 70,
            width: contentView.frame.size.width - 170,
            height: contentView.frame.size.height / 2
        )
        //Imageview properties
        newsImageView.frame = CGRect(
            x: contentView.frame.size.width - 160,
            y: 5,
            width: 140,
            height: contentView.frame.size.height - 10
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //Prepare for reuse
        newsTitleLabel.text = nil
        newsSubTitleLabel.text = nil
        newsImageView.image = nil
    }
    
    //Configure components in each cell using viewmodel
    func configure(with viewModel: NewsTableViewCellViewModel) {
        //Title field
        newsTitleLabel.text = viewModel.title
        //Subtitle field
        newsSubTitleLabel.text = viewModel.subtitle
        //Image Data
        if let data = viewModel.imageData {
            //If data available -> Display
            newsImageView.image = UIImage(data: data)
        } else if let url = viewModel.imageURL {
            //Else fetch the data from API
            URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
                guard let data = data, error == nil else {
                    return
                }
                //Update in viewmodal
                viewModel.imageData = data
                //Update in Main UI
                DispatchQueue.main.async {
                    self?.newsImageView.image = UIImage(data: data)
                }
            }.resume()
        }
    }
}
