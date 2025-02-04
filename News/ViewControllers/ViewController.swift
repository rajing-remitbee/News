//
//  ViewController.swift
//  News
//
//  Created by Rajin Gangadharan on 03/02/25.
//

import UIKit
import SafariServices

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {

    //Implement tableview
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(NewsTableViewCell.self, forCellReuseIdentifier: NewsTableViewCell.identifier)
        return table
    }()
    
    //Implement SearchController
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchBar.placeholder = "Search..."
        searchController.obscuresBackgroundDuringPresentation = false
        return searchController
    }()
    
    private var articles = [Article]() //Store articles
    private var viewModels = [NewsTableViewCellViewModel]() //Store viewmodel data
    private var filteredViewModels = [NewsTableViewCellViewModel]() //Store filtered viewmodel data

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "News" //Title
        
        view.addSubview(tableView) //Add tableview
        tableView.delegate = self //Set table delegate
        tableView.dataSource = self //Set table source
        view.backgroundColor = .systemBackground //Set background
        
        navigationItem.searchController = searchController
        searchController.searchResultsUpdater = self
        
        fetchNews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        //Set table to fill entire view
        tableView.frame = view.bounds
    }
    
    //Method which fetch the news
    func fetchNews() {
        //Fetch data from API
        APICaller.shared.getTopStories { [weak self] result in
            switch result {
                //Success
            case .success(let articles):
                //Setup articles
                self?.articles = articles
                //Setup viewmodals
                self?.viewModels = articles.compactMap({
                    //Viewmodal object
                    NewsTableViewCellViewModel(
                        title: $0.title,
                        subtitle: $0.description ?? "No Description",
                        imageURL: URL(string: $0.urlToImage ?? "")
                    )
                })
                //Update filtered viewmodel
                self?.filteredViewModels = self?.viewModels ?? []
                
                //Update in mainUI
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                //Failure
            case .failure(let error):
                print("Error: \(error)")
            }
        
        }
    }
    
    //Table RowCount Method
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredViewModels.count //Viewmodel size
    }
    
    //Table Cell-Row Configuration Method
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Fetch cell at specific position
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NewsTableViewCell.identifier, for: indexPath) as? NewsTableViewCell else {
            fatalError()
        }
        //Configure the cell with the corresponsing viewmodel
        cell.configure(with: filteredViewModels[indexPath.row])
        return cell
    }
    
    //Table Row-Selection Method
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Get article data at position when clicked
        tableView.deselectRow(at: indexPath, animated: true)
        let article = articles[indexPath.row]
        guard let url = URL(string: article.url ?? "") else {
            return
        }
        //Open safari browser to view the news detailed
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true)
    }
    
    //Table Row-Height Method
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    
    //SearchController - Update SearchResults Method
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text, !searchText.isEmpty else {
            filteredViewModels = viewModels
            tableView.reloadData()
            return
        }
        filteredViewModels = viewModels.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        tableView.reloadData()
    }

}

