
import UIKit
import SnapKit


class SearchViewController: UIViewController {
    
    var movies = [Movie]()
    var selectedIndex = 0
    var currentSearchTask: URLSessionTask?

    //MARK: - SearchController implementation
    lazy var movieSearchController = UISearchController(searchResultsController: nil)
    
    private var searchBarIsEmpty: Bool {
        guard let text = movieSearchController.searchBar.text else {return false}
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return movieSearchController.isActive && !searchBarIsEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientBackground()
        self.definesPresentationContext = true
        setupNavigationAndSearchBar()
        tableViewSetup()
        setupConstraints()

        searchTableView.reloadData()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        movieSearchController.isActive = false
    }
    
    //MARK: - TableView setup
    let searchTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    private func tableViewSetup() {
        searchTableView.rowHeight = UITableView.automaticDimension
        searchTableView.register(SearchTableViewCell.self, forCellReuseIdentifier: "CellSearch")
        searchTableView.dataSource = self
        searchTableView.delegate = self
    }
    
    private func setupNavigationAndSearchBar() {
        self.navigationItem.titleView = movieSearchController.searchBar
        movieSearchController.searchBar.placeholder = "Search"
        movieSearchController.searchBar.searchTextField.font = .openSans_Regular14
        movieSearchController.hidesNavigationBarDuringPresentation = false
        movieSearchController.obscuresBackgroundDuringPresentation = false
        movieSearchController.searchBar.delegate = self
        navigationController?.hidesBarsOnSwipe = false
    }
    
    func setupConstraints() {
        self.view.addSubview(searchTableView)
        
        searchTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(0)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(-0)
        }
    }
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isFiltering {
            movies.count
        }
            return MovieModel.trending.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if isFiltering {
            return "Search Results"
        } else {
            return "Trending"
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellSearch", for: indexPath)
        
        var movie: Movie
        
        if isFiltering {
            movie = movies[indexPath.row]
        } else {
            movie = MovieModel.trending[indexPath.row]
        }

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
        tableView.deselectRow(at: indexPath, animated: true)
        var movie: Movie
        
        if isFiltering {
            movie = movies[indexPath.row]
        } else {
            movie = MovieModel.trending[indexPath.row]
        }

        if let movieId = movie.id {
            let detailVC = DetailViewController(movie: movie, movieId:  String(movieId))
            detailVC.movie = movie
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 145
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

extension SearchViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        currentSearchTask?.cancel()
        currentSearchTask = TMDBClient.search(query: searchText) { (movieResults, error) in
            self.movies = movieResults
            self.searchTableView.reloadData()
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        self.searchTableView.reloadData()
    }
}
