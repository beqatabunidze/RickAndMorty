//
//  CharacterDetailsPresenter.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import Foundation

protocol CharacterDetailsPresenterProtocol {
    var characterDetailsViewCntroller: CharacterDetailsViewControllerProtocol? { get set }
    
    func populateData()
    func didFetchEpisodeList(response: Result<[Episode], NetworkError>)
    func didFetchCharacterFromEpisode(response: Result<[ResultModel], NetworkError>)
}

final class CharacterDetailsPresenter: CharacterDetailsPresenterProtocol {
    //MARK: - Properties
    var characterDetailsViewCntroller: CharacterDetailsViewControllerProtocol?
    
    private var data: ResultModel
    
    init(data: ResultModel) {
        self.data = data
    }
    
    func didFetchEpisodeList(response: Result<[Episode], NetworkError>) {
        characterDetailsViewCntroller?.startActivityIndicator()
        
        switch response {
        case .success(let episodes):
            characterDetailsViewCntroller?.episodes = episodes
            characterDetailsViewCntroller?.requestCharactersFromEpisode(episodes: episodes)
        case .failure(let error):
            characterDetailsViewCntroller?.handleError(errorMessage: error.localizedDescription)
            characterDetailsViewCntroller?.stopActivityIndicator()
        }
        characterDetailsViewCntroller?.stopActivityIndicator()
        characterDetailsViewCntroller?.refreshData()
    }
    
    func didFetchCharacterFromEpisode(response: Result<[ResultModel], NetworkError>) {
        characterDetailsViewCntroller?.startActivityIndicator()
        
        switch response {
        case .success(let characters):
            characterDetailsViewCntroller?.episodeCharacters = characters
            characterDetailsViewCntroller?.refreshData()
            characterDetailsViewCntroller?.stopActivityIndicator()
        case .failure:
            characterDetailsViewCntroller?.stopActivityIndicator()
        }
    }
    
    func populateData() {
        characterDetailsViewCntroller?.requestEpisodeFromUrl(urls: data.episode ?? [])
        characterDetailsViewCntroller?.setData(data: data)
        characterDetailsViewCntroller?.refreshData()
    }
}
