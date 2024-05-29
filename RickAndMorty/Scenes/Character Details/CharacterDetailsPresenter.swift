//
//  CharacterDetailsPresenter.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import Foundation

protocol CharacterDetailsPresenterProtocol {
    var characterDetailsViewCntroller: CharacterDetailsViewControllerProtocol? { get set }
    
    func setData()
    func didFetchEpisodeList(response: Result<Episode, NetworkError>)
    func didFetchCharacterFromEpisode(response: Result<ResultModel, NetworkError>)
}

final class CharacterDetailsPresenter: CharacterDetailsPresenterProtocol {
    //MARK: - Properties
    var characterDetailsViewCntroller: CharacterDetailsViewControllerProtocol?
    
    private var data: ResultModel
    
    init(data: ResultModel) {
        self.data = data
    }
    
    func didFetchEpisodeList(response: Result<Episode, NetworkError>) {
        characterDetailsViewCntroller?.startActivityIndicator()
        
        switch response {
        case .success(let episode):
            characterDetailsViewCntroller?.episodes.append(episode)
            characterDetailsViewCntroller?.refreshData()
            characterDetailsViewCntroller?.stopActivityIndicator()
        case .failure(let failure):
            print(failure.localizedDescription)
            characterDetailsViewCntroller?.stopActivityIndicator()
        }
    }
    
    func didFetchCharacterFromEpisode(response: Result<ResultModel, NetworkError>) {
        characterDetailsViewCntroller?.startActivityIndicator()
        
        switch response {
        case .success(let success):
            characterDetailsViewCntroller?.episodeCharacters.append(success)
            characterDetailsViewCntroller?.refreshData()
            characterDetailsViewCntroller?.stopActivityIndicator()
        case .failure(let failure):
            print(failure.localizedDescription)
            characterDetailsViewCntroller?.stopActivityIndicator()
        }
    }
    
    func setData() {
        characterDetailsViewCntroller?.setData(data: data)
        characterDetailsViewCntroller?.refreshData()
    }
}
