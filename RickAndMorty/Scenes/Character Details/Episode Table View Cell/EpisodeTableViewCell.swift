//
//  EpisodeTableViewCell.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 28.05.24.
//

import UIKit

class EpisodeTableViewCell: UITableViewCell {
    @IBOutlet weak var episodeNameLabel: UILabel!
    @IBOutlet weak var episodeSubtitleLabel: UILabel!
    @IBOutlet weak var episodeDateLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var characters: [ResultModel] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setupCollectionView()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    private func setupCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "EpisodeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EpisodeCollectionViewCell")
    }
    
    func configure(episodeData: Episode) {
        DispatchQueue.main.async {
            self.episodeNameLabel.text = episodeData.name
            self.episodeSubtitleLabel.text = episodeData.episode
            self.episodeDateLabel.text = episodeData.airDate
        }
    }
    
    func configure(characterData: [ResultModel]) {
        DispatchQueue.main.async {
            self.characters = characterData
            self.collectionView.reloadData()
        }
    }
}

extension EpisodeTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        characters.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCollectionViewCell", for: indexPath) as? EpisodeCollectionViewCell else {
            fatalError("EpisodeCollectionViewCell cannot be dequeued")
        }
        
        cell.configure(with: characters[indexPath.item].image ?? "")
        
        return cell
    }
}

extension EpisodeTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "CharacterDetailsViewController", bundle: nil)
        guard let characterDetailsVC = storyboard.instantiateViewController(withIdentifier: "CharacterDetailsViewController") as? CharacterDetailsViewController else {
            fatalError("CharacterDetailsViewController cannot be instantiated")
        }
        
        let characterData = characters[indexPath.item]
        
        let networkManager = NetworkManager()
        let detailsPresenter = CharacterDetailsPresenter(data: characterData)
        let detailsInteractor = CharacterDetailsInteractor(networkManager: networkManager)
        
        characterDetailsVC.interactor = detailsInteractor
        detailsInteractor.presenter = detailsPresenter
        detailsPresenter.characterDetailsViewCntroller = characterDetailsVC
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first,
               let rootViewController = window.rootViewController {
                if let navigationController = rootViewController.navigationController {
                    navigationController.pushViewController(characterDetailsVC, animated: true)
                } else {
                    rootViewController.present(characterDetailsVC, animated: true, completion: nil)
                }
            } else {
                fatalError("No window or root view controller found")
            }
        }
    }
}

extension EpisodeTableViewCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 100, height: 100)
    }
}
