//
//  CharacterListTableViewCell.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 27.05.24.
//

import UIKit

class CharacterListTableViewCell: UITableViewCell {
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        characterImage.layer.cornerRadius = 25
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    func configure(with name: String, imageUrl: String) {
        self.characterName.text = name
        self.characterImage.loadImage(from: imageUrl, placeholder: UIImage(named: "loading"))
    }
    
}
