//
//  MoviesViewController.swift
//  Flix
//
//  Created by Renu Bandaru on 10/22/20.
//

import UIKit
import AlamofireImage

class MoviesViewController: UIViewController{
   
    

    //creating outlet
    @IBOutlet weak var tableView: UITableView!
    
    
    //variables created at the top are called properties
    var movies = [[String:Any]] () //creating an array of dictionaries; declarations :  dictionary = [String:Any]; array = []
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 200
        
        
        //pasting the snippet from the assignment page - Week 1
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/now_playing?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")! //the URL is the imp part which gives us the data to display
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
            
            //reloading the data of the table view
            self.tableView.reloadData()
            
            //printing data dictionary just for display
            print(dataDictionary)
            
            
              // TODO: Get the array of movies
              // TODO: Store the movies in a property to use elsewhere
              // TODO: Reload your table view data

           }
        }
        task.resume()
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    // when you are leaving one screen, you need to prepare the next screen
    //sender is the cell you have tapped on
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        
        print("Loading up the details screen")
        
        //Find the selected movie
        let cell = sender as! UITableViewCell //casting the sender as a Table view cell
        let indexPath = tableView.indexPath(for: cell)! //so that table view knows what cell is being accessed
        let movie = movies[indexPath.row] //accessing the movie from the array value
        
        //Pass the selected movie to the MovieDetailsViewController
        
        //the segue knows where it is going, but you need it to cast it because its going to give a
        //generic ui view controller which wont give access to the UI property we created in MovieDetailsViewController
        let detailsViewController = segue.destination as! MovieDetailsViewController
        detailsViewController.movie = movie //basically similar to calling a variable from another class 
        
        tableView.deselectRow(at: indexPath, animated: true) //basically when the cell is pressed the highligh is brielf there & not after we are back
    }
    

}
//creating an extension for the required functions of Table view
extension MoviesViewController: UITableViewDataSource, UITableViewDelegate
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as! MovieCell //recycling the cells and memory in order to save space
        
        let movie = movies[indexPath.row]
        let title = movie["title"] as! String
        let synopsis = movie["overview"] as! String
        
        cell.titleLabel.text = title
        cell.synopsisLabel.text = synopsis
        
        let baseUrl = "https://image.tmdb.org/t/p/w780"
        
        let posterPath = movie["poster_path"] as! String
        let posterUrl = URL (string: baseUrl + posterPath) //difference b/w url n string is that url verifies the correct format of the link itself
        
        cell.posterView.af_setImage(withURL: posterUrl!) 
        
        
        
        return cell;
    }
}
