//
//  CharacterListViewController.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import UIKit

protocol CharacterListViewControllerProtocol {
    
}

final class CharacterListViewController: UIViewController, CharacterListViewControllerProtocol {
    //MARK: - Outlets

    
    //MARK: - Properties
    var interactor: CharacterListInteractorProtocol?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}
