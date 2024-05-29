//
//  EpisodeCollectionViewCell.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 28.05.24.
//

import UIKit

class EpisodeCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var characterImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        characterImageView.layer.cornerRadius = 15
    }
    
    func configure(with image: String) {
        characterImageView.loadImage(from: image, placeholder: UIImage(named: "loading"))
    }
}
