//
//  CharacterListViewController.swift
//  RickAndMorty
//
//  Created by Beqa Tabunidze on 23.05.24.
//

import UIKit

protocol CharacterListViewControllerProtocol {
    var searchedData: Character? { get set }
    
    func setData(data: Character)
    func getCurrentPage(page: Int)
    func buttonStates(isNextButtonEnabled: Bool, isPreviousButtonEnabled: Bool)
    func handleError(errorMessage: String)
    func refreshData()
    func startActivityIndicator()
    func stopActivityIndicator()
}

final class CharacterListViewController: UIViewController, CharacterListViewControllerProtocol {
    //MARK: - Outlets
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var previousBarButton: UIBarButtonItem!
    @IBOutlet weak var nextBarButton: UIBarButtonItem!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    //MARK: - Properties
    var interactor: CharacterListInteractorProtocol?
    
    private var currentPage: Int = 1
    private var data: Character?
    
    var searchedData: Character?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupTableView()
        
        interactor?.getAllCharacters(page: currentPage)
    }
    
    //MARK: - UI
    private func setupUI() {
        title = "Rick & Morty"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.layer.cornerRadius = 24
        
        tableView.register(UINib(nibName: "CharacterListTableViewCell", bundle: nil), forCellReuseIdentifier: "CharacterListTableViewCell")
    }
    
    //MARK: - Helpers
    func buttonStates(isNextButtonEnabled: Bool, isPreviousButtonEnabled: Bool) {
        DispatchQueue.main.async {
            self.nextBarButton.isEnabled = isNextButtonEnabled
            self.previousBarButton.isEnabled = isPreviousButtonEnabled
        }
    }
    
    func setData(data: Character) {
        DispatchQueue.main.async {
            self.data = data
        }
    }
    
    func getCurrentPage(page: Int) {
        DispatchQueue.main.async {
            self.currentPage = page
        }
    }
    
    func handleError(errorMessage: String) {
        presentAlert(title: "Error", message: errorMessage)
    }
    
    func refreshData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func startActivityIndicator() {
        DispatchQueue.main.async {
            self.spinner.startAnimating()
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.spinner.stopAnimating()
        }
    }
    
    private func presentAlert(title: String, message: String) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            
            self.present(alert, animated: true)
        }
    }
    
    //MARK: - Actions
    @IBAction func onTapPrevious(_ sender: Any) {
        interactor?.goToPreviousPage(page: currentPage)
    }
    
    @IBAction func onTapNext(_ sender: Any) {
        interactor?.goToNextPage(page: currentPage)
    }
}

//MARK: - Table view data source
extension CharacterListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchedData?.results?.count ?? data?.results?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CharacterListTableViewCell", for: indexPath) as? CharacterListTableViewCell else {
            fatalError("CharacterListTableViewCell cannot be dequed")
        }
        
        let character = searchedData?.results?[indexPath.row] ?? data?.results?[indexPath.row]
        
        let name = character?.name ?? ""
        let imageUrl = character?.image ?? ""
        
        cell.configure(with: name, imageUrl: imageUrl)
        
        return cell
    }
}

//MARK: - Table view delegate
extension CharacterListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "CharacterDetailsViewController", bundle: nil)
        guard 
            let characterDetailsVC = storyboard.instantiateViewController(withIdentifier: "CharacterDetailsViewController") as? CharacterDetailsViewController
        else {
            fatalError("CharacterDetailsViewController cannot be instantiated")
        }
        
        let character = searchedData?.results?[indexPath.row] ?? data?.results?[indexPath.row]
        guard let characterData = character else { return }
        
        let networkManager = NetworkManager()
        let detailsPresenter = CharacterDetailsPresenter(data: characterData)
        let detailsInteractor = CharacterDetailsInteractor(networkManager: networkManager)
        
        characterDetailsVC.interactor = detailsInteractor
        detailsInteractor.presenter = detailsPresenter
        detailsPresenter.characterDetailsViewCntroller = characterDetailsVC
        
        navigationController?.pushViewController(characterDetailsVC, animated: true)
    }
}

//MARK: - Search bar delegate
extension CharacterListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        interactor?.searchCharacterByName(name: searchText)
    }
}
