
import UIKit
import SnapKit
import SDWebImage

class DetailViewController: UIViewController {
    
    var contentSize: CGSize{
        CGSize(width: view.frame.width, height: view.frame.height)
    }
    let largeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .light, scale: .small)
    
    var movieId: String
    var movie: Movie
    
    var isWatchlist: Bool {
        return MovieModel.watchlist.contains(movie)
    }
    
    var isFavorite: Bool {
        return MovieModel.favorites.contains(movie)
    }
    
    init(movie: Movie, movieId: String) {
        self.movie = movie
        self.movieId = movieId
        if movie.title != nil {
            self.movieTitle.text = movie.title
        } else {
            self.movieTitle.text = movie.name
        }
        self.movieDescription.text = movie.overview
//        if let runtime = movie.runtime {
//            self.movieRuntime.text = String("\(runtime)m")
//        }
        if let voteAve = movie.voteAverage {
            let voteAverageValue = Float((voteAve * 10).rounded())
            let voteAverageString = String(voteAverageValue.clean)
            self.progressView.progress = Float(voteAve/10)
            self.progressValueLabel.text = "\(voteAverageString) %"
        }
        super.init(nibName: nil, bundle: nil)
//        self.navigationController?.navigationBar.topItem?.title = details.title
//        if let posterPath = movie.posterPath {
//            TMDBClient.downloadPosterImage(posterPath: posterPath) { (data, error) in
//                guard let data = data else {
//                    return
//                }
//                let downloadedImage = UIImage(data: data)
//                self.posterImage.image = downloadedImage
//            }
//        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.setGradientBackground()
        setupCollectionView()
        setupViews()
        
        toggleWatchButton(self.watchlistButton, isSaved: isWatchlist)
        toggleFavButton(self.favoriteButton, isSaved: isFavorite)
        
        TMDBClient.downloadPosterImage(posterPath: movie.posterPath!, completion: handleDownloadImageResponse(data:error:))
        
        TMDBClient.getCast(movie_id: movieId) { cast, error in
            MovieCast.castList = cast
            DispatchQueue.main.async {
                self.castCollectionView.reloadData()
            }
        }
    }
    
    override func viewWillLayoutSubviews(){
        super.viewWillLayoutSubviews()
        scrollView.contentSize = contentSize
        castCollectionView.isUserInteractionEnabled = true
    }
    
    //MARK: - Handle responces
    func handleWatchlistResponses(success: Bool, error: Error?) {
        if success {
            if isWatchlist {
                MovieModel.watchlist = MovieModel.watchlist.filter() {
                    $0 != self.movie
                }
            } else {
                MovieModel.watchlist.append(movie)
            }
            toggleWatchButton(watchlistButton, isSaved: isWatchlist)
        } else {
            showMarkFailure(message: error?.localizedDescription ?? "")
        }
    }
    func handleFavoriteListResponse(success: Bool, error: Error?) {
        if success {
            if isFavorite {
                MovieModel.favorites = MovieModel.favorites.filter() {
                    $0 != self.movie
                }
            } else {
                MovieModel.favorites.append(movie)
            }
            toggleFavButton(favoriteButton, isSaved: isFavorite)
        } else  {
            showMarkFailure(message: error?.localizedDescription ?? "")
        }
    }
    func handleDownloadImageResponse(data: Data?, error: Error?) {
        if let data = data {
            let downloadedImage = UIImage(data: data)
            DispatchQueue.main.async {
                self.posterImage.image = downloadedImage
            }
        }
    }
    @objc func buttonTaped(sender: UIButton) {
        switch sender.currentTitle{
        case "Favorite":
            TMDBClient.markFavorite(movieId: Int(movieId) ?? 0, favorite: isFavorite, completion: handleFavoriteListResponse(success:error:))
        case "Watchlist":
            TMDBClient.markWatchlist(movieId: Int(movieId) ?? 0, watchlist: isWatchlist, completion: handleWatchlistResponses(success:error:))
        default:
            return
        }
    }
    func showMarkFailure(message: String) {
        let alertVC = UIAlertController(title: "Sorry, you can't mark this movie. Please, login first.", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        self.present(alertVC, animated: true, completion: nil)
    }
    //MARK: - Set buttons' color
    func toggleFavButton(_ button: UIButton, isSaved: Bool) {
        if isSaved {
            let image = UIImage(systemName: "heart.fill", withConfiguration: largeConfig)!
            button.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "heart", withConfiguration: largeConfig)!
            button.setImage(image, for: .normal)
        }
    }
    func toggleWatchButton(_ button: UIButton, isSaved: Bool) {
        if isSaved {
            let image = UIImage(systemName: "bookmark.fill", withConfiguration: largeConfig)!
            button.setImage(image, for: .normal)
        } else {
            let image = UIImage(systemName: "bookmark", withConfiguration: largeConfig)!
            button.setImage(image, for: .normal)
        }
    }
    
    //MARK: - Setup UIs
    let movieTitle: UILabel = {
      let label = UILabel()
        label.font = .openSans_SemiBold18
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var progressView: CircularProgressView = {
        var progressView = CircularProgressView(frame: CGRect(x: 5, y: 6, width: 18, height: 18), lineWidth: 3, rounded: true)
        progressView.backgroundColor = .clear
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    var progressValueLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        label.font = .openSans_Regular14
        label.numberOfLines = 1
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    public let progressStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    let movieRuntime: UILabel = {
      let label = UILabel()
        label.font = .openSans_Regular14
        label.textColor = .customGray
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 0
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var movieDescription: UILabel = {
        var label = UILabel()
        label.textColor = .customDarkGray
        label.font = .openSans_Regular14
        label.numberOfLines = 0
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var favoriteButton: UIButton =  {
        let button = UIButton(type: .system)
        button.customButtonExtension()
        button.setTitle("Favorite", for: .normal)
        let largeBoldDoc = UIImage(systemName: "heart", withConfiguration: largeConfig)
        button.setImage(largeBoldDoc, for: .normal)
        button.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    lazy var watchlistButton: UIButton =  {
        let button = UIButton(type: .system)
        button.customButtonExtension()
        button.setTitle("Watchlist", for: .normal)
        let largeBoldDoc = UIImage(systemName: "bookmark", withConfiguration: largeConfig)
        button.setImage(largeBoldDoc, for: .normal)
        button.addTarget(self, action: #selector(buttonTaped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    public let buttonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 3
        stackView.isUserInteractionEnabled = true
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    let seriesCastLabel: UILabel = {
      let label = UILabel()
        label.font = .openSans_SemiBold18
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Series Cast"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let castCollectionView: UICollectionView = {
        // init the layout
        let layout = UICollectionViewFlowLayout()
        // set the direction to be horizontal
        layout.scrollDirection = .horizontal
        // the instance of collectionView
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
//        cv.isUserInteractionEnabled = true
        // Activate constaints
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsHorizontalScrollIndicator = false
        scroll.isUserInteractionEnabled = true
        scroll.translatesAutoresizingMaskIntoConstraints = false
        return scroll
    }()
    let scrollViewContainer: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 10
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    //MARK: - Setup CastCollectionView
    func setupCollectionView() {
        castCollectionView.register(CastCollectionViewCell.self, forCellWithReuseIdentifier: CastCollectionViewCell.reuseId)
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
    }

    //MARK: - AddSubviews and makeConstraints
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(scrollViewContainer)
        scrollViewContainer.addSubview(movieTitle)
        scrollViewContainer.addSubview(progressStackView)
        progressStackView.addArrangedSubview(progressView)
        progressStackView.addArrangedSubview(progressValueLabel)
        scrollViewContainer.addSubview(movieRuntime)
        scrollViewContainer.addSubview(posterImage)
        scrollViewContainer.addSubview(movieDescription)
        scrollViewContainer.addSubview(buttonsStackView)
        buttonsStackView.addArrangedSubview(favoriteButton)
        buttonsStackView.addArrangedSubview(watchlistButton)
        scrollViewContainer.addSubview(seriesCastLabel)
        scrollViewContainer.addSubview(castCollectionView)
   
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(5)
            make.left.equalTo(view.safeAreaLayoutGuide.snp.left)
            make.right.equalTo(view.safeAreaLayoutGuide.snp.right)
            make.bottom.equalTo(view.snp.bottom)
        }
        scrollViewContainer.snp.makeConstraints { make in
            make.top.equalTo(scrollView.snp.top)
            make.left.equalTo(scrollView.snp.left)
            make.right.equalTo(scrollView.snp.right)
            make.bottom.equalTo(scrollView.snp.bottom)
            make.height.equalTo(scrollView.snp.height)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width)
        }
        movieTitle.snp.makeConstraints { make in
            make.top.equalTo(scrollViewContainer.snp.top)
            make.left.equalTo(scrollViewContainer.snp.left).inset(5)
            make.right.equalTo(scrollViewContainer.snp.right)
            make.height.equalTo(50)
        }
        progressStackView.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom)
            make.left.equalTo(scrollViewContainer.snp.left)
            make.width.equalTo(70)
            make.height.equalTo(30)
        }
        progressView.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(0)
            make.width.equalTo(25)
            make.height.equalTo(progressStackView.snp.height)
        }
        progressValueLabel.snp.makeConstraints { make in
            make.top.equalTo(0)
            make.left.equalTo(progressView.snp.right).inset(-5)
            make.right.equalTo(0)
            make.height.equalTo(progressStackView.snp.height)
        }
        movieRuntime.snp.makeConstraints { make in
            make.top.equalTo(movieTitle.snp.bottom)
            make.right.equalTo(scrollViewContainer.snp.right).inset(10)
            make.left.equalTo(progressStackView.snp.right)
            make.height.equalTo(progressStackView.snp.height)
        }
        posterImage.snp.makeConstraints { make in
            make.top.equalTo(progressStackView.snp.bottom)
            make.left.equalTo(scrollViewContainer.snp.left)
            make.right.equalTo(scrollViewContainer.snp.right)
            make.height.equalTo(250)
        }
        movieDescription.snp.makeConstraints { make in
            make.top.equalTo(posterImage.snp.bottom)
            make.left.equalTo(scrollViewContainer.snp.left).inset(10)
            make.right.equalTo(scrollViewContainer.snp.right).inset(10)
            make.height.equalTo(70)
        }
        buttonsStackView.snp.makeConstraints { make in
            make.top.equalTo(movieDescription.snp.bottom)
            make.centerX.equalTo(scrollViewContainer.snp.centerX)
            make.width.equalTo(175)
            make.height.equalTo(70)
        }
        seriesCastLabel.snp.makeConstraints { make in
            make.top.equalTo(favoriteButton.snp.bottom)
            make.right.equalTo(scrollViewContainer.snp.right).inset(10)
            make.left.equalTo(scrollViewContainer.snp.left).inset(10)
            make.height.equalTo(30)
        }
        castCollectionView.snp.makeConstraints { make in
            make.top.equalTo(seriesCastLabel.snp.bottom)
            make.left.equalTo(scrollViewContainer.snp.left).inset(5)
            make.right.equalTo(scrollViewContainer.snp.right).inset(-5)
            make.height.equalTo(195)
        }
    }
}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        MovieCast.castList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCollectionViewCell.reuseId, for: indexPath) as! CastCollectionViewCell
        let cast = MovieCast.castList[indexPath.row]
        
        cell.castName.text = cast.name
        cell.characterName.text = cast.character
        if let profilePath = cast.profilePath {
            TMDBClient.downloadPosterImage(posterPath: profilePath) { (data, error) in
                guard let data = data else {
                    return
                }
                let downloadedImage = UIImage(data: data)
                cell.castImage.image = downloadedImage
                cell.setNeedsLayout()
            }
        }
        return cell
    }
    
}

extension DetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.castCollectionView.frame.width/4, height: self.castCollectionView.frame.height)
    }
}
