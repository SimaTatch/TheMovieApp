
import UIKit
import SnapKit

class HomeViewController: UIViewController {

    var avatar = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientBackground()
        navigationController?.setNavigationBarHidden(true, animated: true)
        tableViewSetup()
        setupConstraints()

        moviesTableView.reloadData()
    }
    
    override func viewDidLayoutSubviews(){
        super.viewDidLayoutSubviews()
        TMDBClient.downloadAvatarImage(avatarPath: TMDBClient.Auth.avatarPath) { data, error in
            guard let data = data else {
                return
            }
            let defaultAvatar = UIImage(systemName: "person.badge.plus")!
            let downloadedAvatar = UIImage(data: data) ?? defaultAvatar
            self.tabBarController?.addSubviewToLastTabItem(downloadedAvatar)
        }
    }
    

    //MARK: - TableView
    private func tableViewSetup() {
        moviesTableView.rowHeight = UITableView.automaticDimension
        moviesTableView.register(MovieTableViewCell.self, forCellReuseIdentifier: "Cell")
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
    }
    
    let moviesTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    fileprivate func setupConstraints(){
        view.addSubview(moviesTableView)

        moviesTableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(10)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.bottom.equalTo(-0)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MovieCategories.popularCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let movieCategory = MovieCategories.popularCategories[indexPath.row]
        if let movieCell = cell as? MovieTableViewCell {
            movieCell.movieCellCollectionView.tag = indexPath.row
            movieCell.movieCellLabel.text = movieCategory
            movieCell.movieCellCollectionView.reloadData()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 345
    }
}

