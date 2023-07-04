//
//  MovieListTableViewCell.swift
//  MovieApp
//
//  Created by Ahmed medo 04/07/2023.
//

import UIKit
import Kingfisher

class MovieListTableViewCell: UITableViewCell {

    // MARK: - IBOutlets.
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieGenres: UILabel!
    @IBOutlet weak var movieRating: UILabel!

    static let identifire = "movieCell"
    
    static func nib() ->UINib{
        return UINib(nibName: "MovieListTableViewCell", bundle: nil)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initDesign()
    }
    
        
    func initDesign(){
        self.cellBackgroundView.layer.cornerRadius = 25
        self.cellBackgroundView.layer.borderWidth = 1.5
        self.cellBackgroundView.layer.borderColor = #colorLiteral(red: 0.4156862745, green: 0.7529411765, blue: 0.2705882353, alpha: 1)
        self.cellBackgroundView.clipsToBounds = true
    }
    
    func configure(with data: Movie){
        self.movieTitle.text = data.title
        self.movieRating.text = "⭐️ \(data.popularity ?? 0.0) / 10"
        self.movieGenres.text = data.originalLanguage ?? ""
        guard let imgURL = URL(string: data.posterPath ?? "" ) else { return  }
         let recource = ImageResource(downloadURL: imgURL)

        self.movieImage.kf.setImage(with: recource)
        self.selectionStyle = .none
    }

    
}


