//
//  MovieDetailsViewController.swift
//  Flix
//
//  Created by Renu Bandaru on 10/30/20.
//

import UIKit
import Alamofire

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var backdropImageView: UIImageView!
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    
    
    var movie: [String:Any]!  //property called movie of type dictionary, learn more about the ! or ? in Swift optionals

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //print(movie["title"])
        
        titleLabel.text = movie["title"] as! String //assiging the label text
        titleLabel.sizeToFit()
        
        synopsisLabel.text = movie["overview"] as! String
        synopsisLabel.sizeToFit()
        
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL (string: baseUrl + posterPath) //difference b/w url n string is that url verifies the correct format of the link itself
        
        posterView.af_setImage(withURL: posterUrl!)
    
        
        let backdropPath = movie["backdrop_path"] as! String
        //let backdropPath = movie["poster_path"] as! String
        let backdropUrl = URL (string: "https://image.tmdb.org/t/p/w1280" + backdropPath) //difference b/w url n string is that url verifies the correct format of the link itself
        
        backdropImageView.af_setImage(withURL: backdropUrl!)
        
    }
    
 
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
