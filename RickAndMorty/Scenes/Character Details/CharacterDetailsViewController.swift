//
//  CharacterDetailsViewController.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import UIKit

protocol CharacterDetailsViewControllerProtocol {
    
}

final class CharacterDetailsViewController: UIViewController, CharacterDetailsViewControllerProtocol {
    //MARK: - Outlets

    
    //MARK: - Properties
    var interactor: CharacterDetailsInteractorProtocol?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
