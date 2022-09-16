//
//  WatchlistViewController.swift
//  MoviesApp
//
//  Created by Серафима  Татченкова  on 13.09.2022.
//

import Foundation
import UIKit

class WatchlistViewController: UIViewController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientBackground()
        tableViewSetup()
        setupConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.watchlistTableView.reloadData()
    }
    
    private var watchlistTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func tableViewSetup() {
        watchlistTableView.rowHeight = UITableView.automaticDimension
        watchlistTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "CellSearch")
        watchlistTableView.dataSource = self
        watchlistTableView.delegate = self
    }
    private func setupConstraints() {
        view.addSubview(watchlistTableView)
        watchlistTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
 }

extension WatchlistViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieModel.watchlist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSearch", for: indexPath)
        
        let movie = MovieModel.watchlist[indexPath.row]
        
        if let searchCell = cell as? SearchTableViewCell {
            if movie.title != nil {
                searchCell.movieTitle.text = movie.title
            } else {
                searchCell.movieTitle.text = movie.name
            }
            searchCell.movieDescrip.text = movie.overview
            if let posterPath = movie.posterPath {
                TMDBClient.downloadPosterImage(posterPath: posterPath) { (data, error) in
                    guard let data = data else {
                        return
                    }
                    let downloadedImage = UIImage(data: data)
                    searchCell.posterImage.image = downloadedImage
                    cell.setNeedsLayout()
                }
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movie = MovieModel.watchlist[indexPath.row]
        if let movieId = movie.id {
            let detailVC = DetailViewController(movie: movie, movieId:  String(movieId))
            detailVC.movie = movie
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}

