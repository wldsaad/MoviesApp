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

    //MARK: - OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    //MARK: - VARIABLES
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private var favMovies = [MyMovie]()
    
    //MARK: - FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadFavMovies()
        changeCancelButtonTitle()
    }
    
    //CHANGE CANCEL BUTTON LANGUAGE
    private func changeCancelButtonTitle() {
        if let choosenLanguage = UserDefaults.standard.string(forKey: Constants.LANGUAGE_KEY) {
            switch choosenLanguage {
            case Constants.ENGLISH_LANGUAGE:
                changeLanguage(toLanguage: "en")
            case Constants.ARABIC_LANGUAGE:
                changeLanguage(toLanguage: "ar")
            default:
                return
            }
        }
    }
    
    //CHANGE LANGUAGE
    private func changeLanguage(toLanguage language: String) {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle.init(path: path!)
        cancelButton.title = bundle?.localizedString(forKey: "cancelButton", value: nil, table: nil)
    }
    
    //LOAD FAV MOVIES FROM CORE DATA
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

//MARK: - EXTENSIONS
//MARK: - COLLECTIONVIEW DATA SOURCE EXTENSION
extension FavouritedMoviesVC: UICollectionViewDataSource {
    //NUMBER OF ITEMS
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favMovies.count
    }
    
    //CELL
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "favCell", for: indexPath) as? FavCell {
            cell.updateView(movie: favMovies[indexPath.row])
            return cell
        }
        return FavCell()
    }
}

//MARK: - COLLECTIONVIEW FLOWLAYOUT DELEGATE EXTENSION
extension FavouritedMoviesVC: UICollectionViewDelegateFlowLayout {
    //LAYOUT
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width / 2) - 10, height: 200)
    }
}

//MARK: - COLLECTIONVIEW DELEGATE EXTENSION
extension FavouritedMoviesVC: UICollectionViewDelegate {
    //DID SELECT
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedMovie = favMovies[indexPath.row]
        performSegue(withIdentifier: "detailSegueFromFav", sender: selectedMovie)
    }
    //PREPARE FOR SEGUES
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailVC {
            detailVC.navigationItem.title = (sender as! MyMovie).title
            detailVC.updateID(id: (sender as! MyMovie).id!)
        }
   }
}
