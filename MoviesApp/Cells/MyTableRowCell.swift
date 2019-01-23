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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func initCollectionView<DataSource: UICollectionViewDataSource, Delegate: UICollectionViewDelegate>(dataSource: DataSource, delegate: Delegate) {
        collectionView.dataSource = dataSource
        collectionView.delegate = delegate
    }
}
