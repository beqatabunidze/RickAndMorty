//
//  CharacterListInteractorTests.swift
//  RickAndMortyTests
//
//  Created by Beqa Tabunidze on 29.05.24.
//

import XCTest
@testable import RickAndMorty

class CharacterListInteractorTests: XCTestCase {

    class MockNetworkManager: NetworkManagerProtocol {
        var getCharactersCalled = false
        var successResponse: Result<Character, NetworkError>?
        
        func get<T: Decodable>(endpoint: Endpoint, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {
            getCharactersCalled = true
            if let successResponse = successResponse as? Result<T, NetworkError> {
                completion(successResponse)
            }
        }
        
        func get<T: Decodable>(url: URL, responseType: T.Type, completion: @escaping (Result<T, NetworkError>) -> Void) {}
    }
    
    var interactor: CharacterListInteractor!
    var mockNetworkManager: MockNetworkManager!
    var mockPresenter: CharacterListPresenterProtocol!
    
    override func setUp() {
        super.setUp()
        mockNetworkManager = MockNetworkManager()
        interactor = CharacterListInteractor(networkManager: mockNetworkManager)
        mockPresenter = MockCharacterListPresenter()
        interactor.presenter = mockPresenter
    }
    
    override func tearDown() {
        mockNetworkManager = nil
        interactor = nil
        mockPresenter = nil
        super.tearDown()
    }
    
    func testGetAllCharacters() {
        let mockCharacter = Character(/* Initialize your mock Character object */)
        mockNetworkManager.successResponse = .success(mockCharacter)
        
        interactor.getAllCharacters(page: 1)

        XCTAssertTrue(mockNetworkManager.getCharactersCalled)
    }
    
    class MockCharacterListPresenter: CharacterListPresenterProtocol {
        var characterListViewController: RickAndMorty.CharacterListViewControllerProtocol?
        
        var didFetchCharacterListCalled = false
        var didSearchCharacterWithNameCalled = false
        var goToNextPageCalled = false
        var goToPreviousPageCalled = false
        
        func didFetchCharacterList(response: Result<Character, NetworkError>) {
            didFetchCharacterListCalled = true
        }
        
        func didSearchCharactersWithName(response: Result<RickAndMorty.Character, RickAndMorty.NetworkError>) {
            didSearchCharacterWithNameCalled = true
        }
        
        func goToNextPage() {
            goToNextPageCalled = true
        }
        
        func goToPreviousPage() {
            goToPreviousPageCalled = true
        }
    }
}
