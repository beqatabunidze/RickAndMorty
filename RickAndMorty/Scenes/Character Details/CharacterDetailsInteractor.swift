//
//  CharacterDetailsInteractor.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import Foundation

protocol CharacterDetailsInteractorProtocol {
    func requestData()
    func getEpisodes(with urls: [String])
    func getCharactersFromEpisode(episode: [Episode])
}

final class CharacterDetailsInteractor: CharacterDetailsInteractorProtocol {
    //MARK: - Properties
    private var networkManager: NetworkManagerProtocol
    
    var presenter: CharacterDetailsPresenterProtocol?
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getEpisodes(with urls: [String]) {
        networkManager.getCombined(urlStrings: urls, responseType: Episode.self) { [weak self] result in
            self?.presenter?.didFetchEpisodeList(response: result)
        }
    }
    
    func getCharactersFromEpisode(episode: [Episode]) {
        let numberOfEpisodes = episode.count
        
        for number in 0..<numberOfEpisodes {
            guard let url = episode[number].characters else { return }
            
            networkManager.getCombinedCharacters(urlStrings: url, responseType: ResultModel.self) { [weak self] result in
                self?.presenter?.didFetchCharacterFromEpisode(response: result)
            }
        }
    }
    
    func requestData() {
        presenter?.populateData()
    }
}
