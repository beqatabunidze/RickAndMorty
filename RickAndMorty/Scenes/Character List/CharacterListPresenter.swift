//
//  CharacterListPresenter.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import Foundation

protocol CharacterListPresenterProtocol {
    var characterListViewController: CharacterListViewControllerProtocol? { get set }
}

final class CharacterListPresenter: CharacterListPresenterProtocol {
    //MARK: - Properties
    var characterListViewController: CharacterListViewControllerProtocol?
    
}
