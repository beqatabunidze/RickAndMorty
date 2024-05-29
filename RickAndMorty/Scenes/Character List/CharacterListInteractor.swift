//
//  CharacterListInteractor.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import Foundation

protocol CharacterListInteractorProtocol {
    func getAllCharacters(page: Int?)
    func searchCharacterByName(name: String)
    
    func goToNextPage(page: Int)
    func goToPreviousPage(page: Int)
}

final class CharacterListInteractor: CharacterListInteractorProtocol {
    //MARK: - Properties
    private var networkManager: NetworkManagerProtocol
    var presenter: CharacterListPresenterProtocol?
    
    init(networkManager: NetworkManagerProtocol) {
        self.networkManager = networkManager
    }
    
    func getAllCharacters(page: Int?) {
        networkManager.get(endpoint: CharacterEndpoint.getAllCharacters(page: page), responseType: Character.self) { result in
            self.presenter?.didFetchCharacterList(response: result)
        }
    }
    
    func searchCharacterByName(name: String) {
        networkManager.get(endpoint: CharacterEndpoint.searchCharacters(name: name), responseType: Character.self) { result in
            self.presenter?.didSearchCharactersWithName(response: result)
        }
    }
    
    func goToNextPage(page: Int) {
        getAllCharacters(page: page)
        presenter?.goToNextPage()
    }
    
    func goToPreviousPage(page: Int) {
        getAllCharacters(page: page)
        presenter?.goToPreviousPage()
    }
}
