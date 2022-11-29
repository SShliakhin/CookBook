//
//  PopularCollectionView.swift
//  CookBook
//
//  Created by Alexander Altman on 30.11.2022.
//

import UIKit

class PopularCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    var cells = [PopularRecipe]()

     init() {
        let layout = UICollectionViewFlowLayout()
         layout.scrollDirection = .horizontal
         super.init(frame: .zero, collectionViewLayout: layout)
         
         backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
         delegate = self
         dataSource = self
         register(PopularCollectionViewCell.self, forCellWithReuseIdentifier: PopularCollectionViewCell.reuseId)
         translatesAutoresizingMaskIntoConstraints = false
    }
    
    func setData(cells: [PopularRecipe]) {
        self.cells = cells
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: PopularCollectionViewCell.reuseId, for: indexPath) as! PopularCollectionViewCell
        cell.mainImageView.image = cells[indexPath.row].image
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 300, height: 300)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
