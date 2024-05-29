//
//  CharacterDetailsInteractor.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import Foundation

protocol CharacterDetailsInteractorProtocol {
    func requestCharacterData()
    func getEpisodes(with urls: [String])
    func getCharactersFromEpisode()
}

final class CharacterDetailsInteractor: CharacterDetailsInteractorProtocol {
    //MARK: - Properties
    private var networkManager: NetworkManagerProtocol
    private var episodeCharacters: [String] = []
    
    var presenter: CharacterDetailsPresenterProtocol?
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getEpisodes(with urls: [String]) {
        for url in urls {
            guard let url = URL(string: url) else { return }
            
            networkManager.get(url: url, responseType: Episode.self) { result in
                self.presenter?.didFetchEpisodeList(response: result)
                
                switch result {
                case .success(let success):
                    guard let urls = success.characters else { return }
                    
                    self.episodeCharacters = urls
                case .failure(let failure):
                    print(failure.localizedDescription)
                }
            }
        }
    }
    
    func getCharactersFromEpisode() {
        for url in episodeCharacters {
            guard let characterUrl = URL(string: url) else { return }
            
            networkManager.get(url: characterUrl, responseType: ResultModel.self) { result in
                self.presenter?.didFetchCharacterFromEpisode(response: result)
            }
        }
    }
    
    func requestCharacterData() {
        presenter?.setData()
    }
}
