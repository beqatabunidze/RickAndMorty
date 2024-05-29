//
//  CharacterListPresenter.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import Foundation

protocol CharacterListPresenterProtocol {
    var characterListViewController: CharacterListViewControllerProtocol? { get set }
    
    func didFetchCharacterList(response: Result<Character, NetworkError>)
    func didSearchCharactersWithName(response: Result<Character, NetworkError>)
    func goToNextPage()
    func goToPreviousPage()
}

final class CharacterListPresenter: CharacterListPresenterProtocol {
    // MARK: - Properties
    var characterListViewController: CharacterListViewControllerProtocol?
    private var currentPage: Int = 1
    
    // MARK: - Presenter Methods
    func didFetchCharacterList(response: Result<Character, NetworkError>) {
        characterListViewController?.startActivityIndicator()
        
        switch response {
        case .success(let character):
            guard let totalPage = character.info?.pages else { return }
            
            characterListViewController?.setData(data: character)
            characterListViewController?.getCurrentPage(page: currentPage)
            characterListViewController?.buttonStates(isNextButtonEnabled: currentPage < totalPage, isPreviousButtonEnabled: currentPage > 1)
            characterListViewController?.stopActivityIndicator()
            characterListViewController?.refreshData()
        case .failure(let failure):
            characterListViewController?.handleError(errorMessage: failure.localizedDescription)
            characterListViewController?.stopActivityIndicator()
        }
    }
    
    func didSearchCharactersWithName(response: Result<Character, NetworkError>) {
        characterListViewController?.startActivityIndicator()
        
        switch response {
        case .success(let success):
            characterListViewController?.searchedData = success
            characterListViewController?.stopActivityIndicator()
            characterListViewController?.refreshData()
        case .failure(let failure):
            characterListViewController?.handleError(errorMessage: failure.localizedDescription)
        }
    }
    
    func goToNextPage() {
        currentPage += 1
        characterListViewController?.startActivityIndicator()
    }
    
    func goToPreviousPage() {
        if currentPage > 1 {
            currentPage -= 1
        }
        characterListViewController?.startActivityIndicator()
    }
}
