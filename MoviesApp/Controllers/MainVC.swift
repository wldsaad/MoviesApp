//
//  ViewController.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/23/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    //MARK:- OUTLETS
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changeLanguageButton: UIBarButtonItem!
    @IBOutlet weak var favoritesButton: UIBarButtonItem!
    //UNWIND SEGUE TO MAIN VC
    @IBAction func UNWIND(segue: UIStoryboardSegue) {
    }
    //MARK:- VARIABLES
    private var errorAlert: UIAlertController?
    private var headerView: HeaderXibView?
    private var fetchMovies = FetchMovies()
    private var isArabic = false
    private let popularURLString = "https://api.themoviedb.org/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1"
    private let upcomingURLString = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1"
    private let nowPlayingURLString = "https://api.themoviedb.org/3/movie/now_playing?api_key=\(Constants.API_KEY)&language=en-US&page=1"
    private let topRatedURLString = "https://api.themoviedb.org/3/movie/top_rated?api_key=\(Constants.API_KEY)&language=en-US&page=1"
    private let latestURLString = "https://api.themoviedb.org/3/movie/latest?api_key=\(Constants.API_KEY)&language=en-US"
    private var sections = [
        Section(name: "Popular", isExpanded: true, movies: [Movie]()),
        Section(name: "Upcoming", isExpanded: false, movies: [Movie]()),
        Section(name: "Now Playing", isExpanded: false, movies: [Movie]()),
        Section(name: "Top Rated", isExpanded: false, movies: [Movie]()),
        Section(name: "Latest", isExpanded: false, movies: [Movie]())
    ]

    //MARK:- FUNCTIONS
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if Reachability.isConnectedToNetwork() {
            getPopularMovies()
            getUpcomingMovies()
            getNowPlayingMovies()
            getTopRatedMovies()
            getLatestMovie()
        } else {
            showAlertError(withTitle: Constants.NO_INTERNET_CONNECTION_TITLE, withMessageToShow: Constants.NO_INTERNET_CONNECTION_MESSAGE)
        }
        
    }
    
    //Alert error dialog
    private func showAlertError(withTitle title: String, withMessageToShow message: String){
        errorAlert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let retryAction = UIAlertAction(title: "RETRY", style: .default) { (UIAlertAction) in
            self.errorAlertBackgroundTapped()
        }
        errorAlert?.addAction(retryAction)
        //        present(errorAlert, animated: true, completion: nil)
        present(errorAlert!, animated: true) {
            // Enabling Interaction for Transperent Full Screen Overlay
            self.errorAlert?.view.superview?.subviews.first?.isUserInteractionEnabled = true
            
            // Adding Tap Gesture to Overlay
            self.errorAlert?.view.superview?.subviews.first?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.errorAlertBackgroundTapped)))
        }
    }
    
    @objc func errorAlertBackgroundTapped() {
        if Reachability.isConnectedToNetwork() {
            errorAlert?.dismiss(animated: true, completion: nil)
            getPopularMovies()
            getUpcomingMovies()
            getNowPlayingMovies()
            getTopRatedMovies()
            getLatestMovie()
        } else {
            errorAlert?.dismiss(animated: true, completion: nil)
            showAlertError(withTitle: Constants.NO_INTERNET_CONNECTION_TITLE, withMessageToShow: Constants.NO_INTERNET_CONNECTION_MESSAGE)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let choosenLanguage = UserDefaults.standard.string(forKey: Constants.LANGUAGE_KEY) {
            switch choosenLanguage {
            case Constants.ENGLISH_LANGUAGE:
                self.changeLanguage(toLanguage: "en")
            case Constants.ARABIC_LANGUAGE:
                self.changeLanguage(toLanguage: "ar")
            default:
                return
            }
        }
    }
    //CHANGE ITEMS LANGUAGE BASED ON SAVE USER DEFAULTS
    private func changeLanguage(toLanguage language: String) {
        let path = Bundle.main.path(forResource: language, ofType: "lproj")
        let bundle = Bundle.init(path: path!)
        changeLanguageButton.title = bundle!.localizedString(forKey: "changeLanguage", value: nil, table: nil)
        favoritesButton.title = bundle!.localizedString(forKey: "favorites", value: nil, table: nil)
    }
    
    //GO TO SETTINGS VC
    @IBAction func changeLanguageAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "settingsSegue", sender: nil)
    }
    
    //GET POPULAR MOVIES
    private func getPopularMovies(){
        fetchMovies.getMovies(withURL: popularURLString) { (movies) in
            let section = 0
            self.sections[section].movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(arrayLiteral: section), with: .none)
            }
        }
    }
    
    //GET UPCOMING MOVIES
    private func getUpcomingMovies(){
        fetchMovies.getMovies(withURL: upcomingURLString) { (movies) in
            let section = 1
            self.sections[section].movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(arrayLiteral: section), with: .none)
            }
        }
    }

    //GET NOW PLAYING MOVIES
    private func getNowPlayingMovies(){
        fetchMovies.getMovies(withURL: nowPlayingURLString) { (movies) in
            let section = 2
            self.sections[section].movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(arrayLiteral: section), with: .none)
            }
        }
    }
    
    //GET TOP RATED MOVIES
    private func getTopRatedMovies(){
        fetchMovies.getMovies(withURL: topRatedURLString) { (movies) in
            let section = 3
            self.sections[section].movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(arrayLiteral: section), with: .none)
            }
        }
    }
    
    //GET LATEST MOVIE
    private func getLatestMovie(){
        fetchMovies.getLatestMovie(withURL: latestURLString) { (movie) in
            let section = 4
            self.sections[section].movies.append(movie)
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(arrayLiteral: section), with: .none)
            }
        }
    }
    
    //GO TO FAVORITE VC
    @IBAction func showFavoritesAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "favSegue", sender: nil)
    }
    
    //PREPARE FOR SEQUES
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let detailVC = segue.destination as? DetailVC {
            detailVC.navigationItem.title = (sender as! Movie).original_title
            detailVC.updateID(id: "\((sender as! Movie).id!)")
        } else if let settingsVC = segue.destination as? SettingsVC {
            settingsVC.navigationItem.title = "Settings"
        }
    }
    
}

//MARK: - EXTENSIONS
//MARK: - TABLE VIEW DATA SOURCE EXTENSION
extension MainVC: UITableViewDataSource {
    //NUMBER OF SECTIONS
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    //NUMBER OF ROWS
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section].isExpanded {
            return 1
        }
        return 0
    }
    //CELL FOR ROW
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myRowCell", for: indexPath) as? MyTableRowCell {
            return cell
        }
        return MyTableRowCell()
    }
    
}
//MARK: - TABLE VIEW DELEGATE EXTENSION
extension MainVC: UITableViewDelegate {
    //VIEW FOR HEADER
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return initSectionHeaderView(withSection: section)
    }
    
    //INITIALIZE HEADER VIEW
    private func initSectionHeaderView(withSection section: Int) -> UIView{
        headerView = Bundle.main.loadNibNamed("HeaderXib", owner: self, options: nil)?.first as? HeaderXibView
        headerView?.nameLabel.text = sections[section].name
        headerView?.expandButton.tag = section
        headerView?.expandButton.imageView?.image = sections[section].isExpanded ? UIImage(named: "up_arrow") : UIImage(named: "down_arrow")
        headerView?.expandButton.addTarget(self, action: #selector(expandToggle(expandButton:)), for: .touchUpInside)
        if headerView != nil {
            return headerView!
        }
        return HeaderXibView()
    }
    
    //HANDLE EXPAND/COLLAPSE TOGGLE
    @objc private func expandToggle(expandButton: UIButton){
        let currentSection = expandButton.tag
        let indexPath = IndexPath(row: 0, section: currentSection)
        sections[currentSection].isExpanded = !sections[currentSection].isExpanded
        if !sections[currentSection].isExpanded {
            tableView.deleteRows(at: [indexPath], with: .right)
        } else {
            tableView.insertRows(at: [indexPath], with: .left)
        }
        let currentIndexSet = IndexSet(arrayLiteral: currentSection)
        tableView.reloadSections(currentIndexSet, with: .none)
    }
    
    //HEIGHT FOR HEADER
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.SECTION_HEIGHT
    }
    
    //WILL DISPLAY CELL
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? MyTableRowCell else {
            return
            
        }
        tableViewCell.initCollectionView(dataSource: self, delegate: self, forSection: indexPath.section)
    }
}

//MARK: - COLLECTION VIEW DATA SOURCE EXTENSION
extension MainVC: UICollectionViewDataSource {
    
    //NUMBER OF ITEMS IN EACH SECTION
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return sections[0].movies.count
        } else if collectionView.tag == 1 {
            return sections[1].movies.count
        } else if collectionView.tag == 2 {
            return sections[2].movies.count
        } else if collectionView.tag == 3 {
            return sections[3].movies.count
        } else if collectionView.tag == 4 {
            return sections[4].movies.count
        } else {
            return 0
        }
    }
    
    //CELL
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieCell {
            if collectionView.tag == 0 {
                cell.updateCellView(movie: sections[0].movies[indexPath.row])
            } else if collectionView.tag == 1 {
                cell.updateCellView(movie: sections[1].movies[indexPath.row])
            } else if collectionView.tag == 2 {
                cell.updateCellView(movie: sections[2].movies[indexPath.row])
            } else if collectionView.tag == 3 {
                cell.updateCellView(movie: sections[3].movies[indexPath.row])
            } else if collectionView.tag == 4 {
                cell.updateCellView(movie: sections[4].movies[indexPath.row])
            }
            
            return cell
        }
        return MovieCell()
    }
}

//MARK: - COLLECTION VIEW DELEGATE EXTENSION
extension MainVC: UICollectionViewDelegate {
    
    //DID SELECT
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = sections[collectionView.tag].movies[indexPath.row]
        performSegue(withIdentifier: "detailSegue", sender: movie)
    }
}

//MARK: - COLLECTION VIEW FLOWLAYOUT DELEGATE EXTENSION
extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3, height: 140)
    }
}
