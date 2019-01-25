//
//  FavouritedMovies.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/24/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import UIKit
import CoreData

class FavouritedMoviesVC: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var favMovies = [MyMovie]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavMovies()
    }
    
    private func loadFavMovies() {
        let fetchRequest: NSFetchRequest<MyMovie> = MyMovie.fetchRequest()
        do {
            self.favMovies = try context.fetch(fetchRequest)
            self.collectionView.reloadData()
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}

extension FavouritedMoviesVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as? FavCell {
            cell.updateView(movie: favMovies[indexPath.row])
            return cell
        }
        return FavCell()
    }
}

extension FavouritedMoviesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2) - 10, height: 200)
    }
}

extension FavouritedMoviesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = favMovies[indexPath.row]
        performSegue(withIdentifier: "detailSegueFromFav", sender: selectedMovie)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailVC {
            detailVC.navigationItem.title = (sender as! MyMovie).title
            detailVC.updateID(id: (sender as! MyMovie).id!)
        }
   }
}
