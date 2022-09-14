
import UIKit
import Foundation
import SnapKit

class MovieTableViewCell: UITableViewCell {
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        self.backgroundColor = .clear
        setupCollectionView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupCollectionView() {
        movieCellCollectionView.register(MovieCollectionViewCell.self, forCellWithReuseIdentifier: MovieCollectionViewCell.reuseId)
        movieCellCollectionView.dataSource = self
        movieCellCollectionView.delegate = self
    }
    
    //MARK: - UI
    let movieCellLabel: UILabel = {
      let label = UILabel()
        label.font = .openSans_SemiBold18
        label.textColor = .black
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
//    let movieCellSegmentControll: OYSegmentControl = {
//        let items = ["Streaming","On TV","For Rent","In Theaters"]
//        let sc = OYSegmentControl(items: items)
////        sc.addTarget(self, action: #selector(indexChanged), for: .valueChanged)
//        sc.removeDividerLine()
//        sc.selectedSegmentIndex = 0
//        sc.translatesAutoresizingMaskIntoConstraints = false
//        return sc
//    }()
    
    let movieCellCollectionView: UICollectionView = {
        // init the layout
        let layout = UICollectionViewFlowLayout()
        // set the direction to be horizontal
        layout.scrollDirection = .horizontal
        // the instance of collectionView
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        cv.showsVerticalScrollIndicator = false
        // Activate constaints
        cv.translatesAutoresizingMaskIntoConstraints = false
        return cv
    }()
    
    func setupConstraints() {
        addSubview(movieCellLabel)
        addSubview(movieCellCollectionView)
        
        movieCellLabel.snp.makeConstraints { make in
            make.top.equalTo(self.snp.top).inset(5)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(25)
        }

        movieCellCollectionView.snp.makeConstraints { make in
            make.top.equalTo(movieCellLabel.snp.bottom).inset(-7)
            make.left.equalTo(5)
            make.right.equalTo(-5)
            make.height.equalTo(250)
        }
    }
}

extension MovieTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch movieCellCollectionView.tag {
        case 0: return MovieModel.popular.count
        case 1: return MovieModel.topRated.count
        case 2: return MovieModel.nowPlaying.count
        case 3: return MovieModel.trending.count
        default:
            return  MovieModel.popular.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCollectionViewCell.reuseId, for: indexPath) as! MovieCollectionViewCell
        var movie: Movie
        switch movieCellCollectionView.tag {
        case 0: movie = MovieModel.popular[indexPath.row]
        case 1: movie = MovieModel.topRated[indexPath.row]
        case 2: movie = MovieModel.nowPlaying[indexPath.row]
        case 3: movie = MovieModel.trending[indexPath.row]
        default:
            movie = MovieModel.popular[indexPath.row]
        }
        guard let voteAve = movie.voteAverage else {return cell}
        let voteAverageValue = Float((voteAve * 10).rounded())
        let voteAverageString = String(voteAverageValue.clean)
        
        if movie.title != nil {
            cell.movieTitle.text = movie.title
        } else {
            cell.movieTitle.text = movie.name
        }
        cell.progressView.progress = Float(voteAve/10)
        cell.progressValueLabel.text = "\(voteAverageString) %"
        

        if let posterPath = movie.posterPath {
            TMDBClient.downloadPosterImage(posterPath: posterPath) { (data, error) in
                guard let data = data else {
                    return
                }
                let downloadedImage = UIImage(data: data)
                cell.posterImage.image = downloadedImage
                cell.setNeedsLayout()
            }
        }
        return cell
    }
}

extension MovieTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.movieCellCollectionView.frame.width/3, height: self.movieCellCollectionView.frame.height)
    }
}
