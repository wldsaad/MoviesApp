//
//  ViewController.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/23/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private var headerView: HeaderXibView?
    
    //Popular
    //https://api.themoviedb.org/3/movie/popular?api_key=0dc10071306ea9f2cc725427fb124f8a&language=en-US&page=1
    
    
    //Upcoming
    //https://api.themoviedb.org/3/movie/upcoming?api_key=0dc10071306ea9f2cc725427fb124f8a&language=en-US&page=1
    

    private let popularURLString = "https://api.themoviedb.org/3/movie/popular?api_key=\(Constants.API_KEY)&language=en-US&page=1"
    private let upcomingURLString = "https://api.themoviedb.org/3/movie/upcoming?api_key=\(Constants.API_KEY)&language=en-US&page=1"

    private var sections = [
        Section(name: "Popular", isExpanded: true, movies: [Movie]()),
        Section(name: "Upcoming", isExpanded: false, movies: [Movie]()),
        Section(name: "Now Playing", isExpanded: false, movies: [Movie]()),
        Section(name: "Top Rated", isExpanded: false, movies: [Movie]()),
        Section(name: "Latest", isExpanded: false, movies: [Movie]())
    ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        getPopularMovies()
        getUpcomingMovies()
        
    }
    
    private func getPopularMovies(){
        FetchMovies().getMovies(withURL: popularURLString) { (movies) in
            let section = 0
            self.sections[section].movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(arrayLiteral: section), with: .left)
            }
        }
    }
    
    private func getUpcomingMovies(){
        FetchMovies().getMovies(withURL: upcomingURLString) { (movies) in
            let section = 1
            self.sections[section].movies = movies
            DispatchQueue.main.async {
                self.tableView.reloadSections(IndexSet(arrayLiteral: section), with: .left)
            }
        }
    }


}

extension MainVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections[section].isExpanded {
            return 1
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "myRowCell", for: indexPath) as? MyTableRowCell {
            
            return cell
        }
        return MyTableRowCell()
    }
    
}

extension MainVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return initSectionHeaderView(withSection: section)
    }
    
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
    
    @objc private func expandToggle(expandButton: UIButton){
        let currentSection = expandButton.tag
        let indexPath = IndexPath(row: 0, section: currentSection)
        sections[currentSection].isExpanded = !sections[currentSection].isExpanded
        if !sections[currentSection].isExpanded {
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else {
            tableView.insertRows(at: [indexPath], with: .fade)
        }
        let currentIndexSet = IndexSet(arrayLiteral: currentSection)
        tableView.reloadSections(currentIndexSet, with: .none)
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.SECTION_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tableViewCell = cell as? MyTableRowCell else {
            return
            
        }
        tableViewCell.initCollectionView(dataSource: self, delegate: self, forSection: indexPath.section)
    }
}

extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView.tag == 0 {
            return sections[0].movies.count
        } else if collectionView.tag == 1 {
            return sections[1].movies.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieCell {
            if collectionView.tag == 0 {
                cell.updateCellView(movie: sections[0].movies[indexPath.row])
            } else if collectionView.tag == 1 {
                cell.updateCellView(movie: sections[1].movies[indexPath.row])
            }
            
            return cell
        }
        return MovieCell()
    }
}

extension MainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint(collectionView.tag)
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3, height: 140)
    }
}
