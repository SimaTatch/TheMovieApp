
import Foundation
import UIKit
import SnapKit

class FavoriteViewController: UIViewController {

    var selectedIndex = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientBackground()
        tableViewSetup()
        setupConstraints()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.favsTableView.reloadData()
    }
    
    private var favsTableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private func tableViewSetup() {
        favsTableView.rowHeight = UITableView.automaticDimension
        favsTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "CellSearch")
        favsTableView.dataSource = self
        favsTableView.delegate = self
    }
    private func setupConstraints() {
        view.addSubview(favsTableView)
        favsTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieModel.favorites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSearch", for: indexPath)
        
        let movie = MovieModel.favorites[indexPath.row]
        
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
        let movie = MovieModel.favorites[indexPath.row]
        if let movieId = movie.id {
            let detailVC = DetailViewController(movie: movie, movieId:  String(movieId))
            detailVC.movie = movie
//            navigationController?.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
}
