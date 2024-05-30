//
//  CharacterDetailsViewController.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import UIKit

protocol CharacterDetailsViewControllerProtocol {
    var episodes: [Episode] { get set }
    var episodeCharacters: [ResultModel] { get set }
    
    func setData(data: ResultModel)
    func handleError(errorMessage: String)
    func requestEpisodeFromUrl(urls: [String])
    func requestCharactersFromEpisode(episodes: [Episode])
    func refreshData()
    func startActivityIndicator()
    func stopActivityIndicator()
}

final class CharacterDetailsViewController: UIViewController, CharacterDetailsViewControllerProtocol {

    //MARK: - Outlets
    @IBOutlet weak var characterImage: UIImageView!
    @IBOutlet weak var characterGender: UILabel!
    @IBOutlet weak var characterStatus: UILabel!
    @IBOutlet weak var characterSpecie: UILabel!
    @IBOutlet weak var characterOrigin: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: - Properties
    var interactor: CharacterDetailsInteractorProtocol?
    var episodes: [Episode] = []
    var episodeCharacters: [ResultModel] = []
    
    private var expandedIndex: Int?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        interactor?.requestData()
        setupTableView()
    }
    
    func setData(data: ResultModel) {
        DispatchQueue.main.async {
            self.characterImage.loadImage(from: data.image ?? "")
            self.characterGender.text = data.gender
            self.characterStatus.text = data.status
            self.characterSpecie.text = data.species
            self.characterOrigin.text = data.origin?.name
            
            self.title = data.name
        }
    }
    
    func requestCharactersFromEpisode(episodes: [Episode]) {
        self.interactor?.getCharactersFromEpisode(episode: episodes)
    }
    
    func requestEpisodeFromUrl(urls: [String]) {
        interactor?.getEpisodes(with: urls)
    }
    
    func handleError(errorMessage: String) {
        presentAlert(title: "Error", message: errorMessage)
    }
    
    func refreshData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func startActivityIndicator() {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.register(UINib(nibName: "EpisodeTableViewCell", bundle: nil), forCellReuseIdentifier: "EpisodeTableViewCell")
    }
}

extension CharacterDetailsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell", for: indexPath) as? EpisodeTableViewCell else {
            fatalError("EpisodeTableViewCell cannot be dequeued")
        }
        
        cell.configure(episodeData: episodes[indexPath.row])
        
        if !episodeCharacters.isEmpty {
            cell.configure(characterData: episodeCharacters)
        }
        
        cell.collectionView.isHidden = indexPath.row != expandedIndex
        
        return cell
    }
}

extension CharacterDetailsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return indexPath.row == expandedIndex ? 200 : 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.beginUpdates()
        
        if let expandedIndex = expandedIndex, expandedIndex != indexPath.row {
            self.expandedIndex = nil
            tableView.reloadRows(at: [IndexPath(row: expandedIndex, section: 0)], with: .automatic)
        }
        
        if expandedIndex == indexPath.row {
            expandedIndex = nil
        } else {
            expandedIndex = indexPath.row

        }
        
        tableView.endUpdates()

        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
