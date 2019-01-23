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
    
    private var sections = [
        Section(name: "Popular", isExpanded: true),
        Section(name: "Upcoming", isExpanded: false),
        Section(name: "Now Playing", isExpanded: false),
        Section(name: "Top Rated", isExpanded: false),
        Section(name: "Latest", isExpanded: false)
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = UITableView.automaticDimension
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
            cell.initCollectionView(dataSource: self, delegate: self)
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
}

extension MainVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "movieCell", for: indexPath) as? MovieCell {
            return cell
        }
        return MovieCell()
    }
}

extension MainVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        debugPrint(indexPath)
    }
}

extension MainVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3, height: 140)
    }
}
