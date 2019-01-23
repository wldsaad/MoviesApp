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
        // Do any additional setup after loading the view, typically from a nib.
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
        
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Constants.SECTION_HEIGHT
    }
}
