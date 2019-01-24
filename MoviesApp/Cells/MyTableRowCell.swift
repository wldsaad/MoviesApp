//
//  MyTableRowCell.swift
//  MoviesApp
//
//  Created by Waleed Saad on 1/23/19.
//  Copyright © 2019 Waleed Saad. All rights reserved.
//

import UIKit

class MyTableRowCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    

    func initCollectionView<DataSource: UICollectionViewDataSource, Delegate: UICollectionViewDelegate>(dataSource: DataSource, delegate: Delegate, forSection section: Int) {
        
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
        collectionView.tag = section
        collectionView.reloadData()
    }
}
