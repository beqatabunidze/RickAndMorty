//
//  SceneDelegate.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        let storyboard = UIStoryboard(name: "CharacterListViewController", bundle: nil)
        guard let characterListViewController = storyboard.instantiateViewController(withIdentifier: "CharacterListViewController") as? CharacterListViewController else {
            fatalError("CharacterListViewController cannot be instantiated")
        }
        
        let interactor = CharacterListInteractor()
        let presenter = CharacterListPresenter()
        
        characterListViewController.interactor = interactor
        interactor.presenter = presenter
        presenter.characterListViewController = characterListViewController
        
        let navigation = UINavigationController(rootViewController: characterListViewController)
        window?.rootViewController = navigation
        window?.makeKeyAndVisible()
        
    }
}

