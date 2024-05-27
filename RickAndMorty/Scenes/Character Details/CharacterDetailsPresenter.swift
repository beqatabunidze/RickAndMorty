//
//  CharacterDetailsPresenter.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import Foundation

protocol CharacterDetailsPresenterProtocol {
    var characterDetailsViewCntroller: CharacterDetailsViewControllerProtocol? { get set }
}

final class CharacterDetailsPresenter: CharacterDetailsPresenterProtocol {
    //MARK: - Properties
    var characterDetailsViewCntroller: CharacterDetailsViewControllerProtocol?
}
