//
//  MovieGridViewController.swift
//  Flix
//
//  Created by Renu Bandaru on 10/30/20.
//

import UIKit
import AlamofireImage

class MovieGridViewController: UIViewController {
   
    @IBOutlet weak var collectionView: UICollectionView!
    
    //variables created at the top are called properties
    var movies = [[String:Any]] () //creating an array of dictionaries; declarations :  dictionary = [String:Any]; array = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        
        /*layout.minimumLineSpacing = 40
        layout.minimumInteritemSpacing = 4
        
        let width = (view.frame.size.width - layout.minimumInteritemSpacing ) / 2
        layout.itemSize = CGSize(width: width, height: width * 1.5)*/

        // Do any additional setup after loading the view.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/297762/similar?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")! //the URL is the imp part which gives us the data to display
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
           // This will run when the network request returns
           if let error = error {
              print(error.localizedDescription)
           } else if let data = data {
              let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] //dataDictionary is the dictionary that has the data fetched from the network
            
            //accessing a particular key inside a dictionary
            //basically saying find the work results in the data dictionary and then remove it
            self.movies = dataDictionary["results"] as! [[String:Any]] //as! [String:Any] - this is casting as an array of dictionaries
            
            self.collectionView.reloadData()
            
            print(self.movies)

           }
        }
        task.resume()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        print("Loading up the details screen")
        
        //Find the selected movie
        let cell = sender as! UICollectionViewCell//casting the sender as a Table view cell
        let indexPath = collectionView.indexPath(for: cell)! //so that table view knows what cell is being accessed
        let movie = movies[indexPath.row] //accessing the movie from the array value
        
        //Pass the selected movie to the MovieDetailsViewController
        
        //the segue knows where it is going, but you need it to cast it because its going to give a
        //generic ui view controller which wont give access to the UI property we created in MovieDetailsViewController
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie //basically similar to calling a variable from another class
        
        collectionView.deselectItem(at: indexPath, animated: true) //basically when the cell is pressed the highligh is brielf there & not after we are back
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
extension MovieGridViewController: UICollectionViewDataSource,UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieGridCell", for: indexPath) as! MovieGridCell
        
        let movie = movies[indexPath.item]
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL (string: baseUrl + posterPath) //difference b/w url n string is that url verifies the correct format of the link itself
        
        cell.posterView.af_setImage(withURL: posterUrl!)
        
        return cell
    }
    
    
    
}
