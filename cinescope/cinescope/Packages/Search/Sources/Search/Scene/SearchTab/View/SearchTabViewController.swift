//
//  SearchTabViewController.swift
//  
//
//  Created by Ozan Barış Günaydın on 19.08.2024.
//

import Components
import UIKit

// MARK: - DetailViewProtocol
protocol SearchTabViewProtocol: AnyObject  {
    var presenter: SearchTabPresenterProtocol? { get set }
}

// MARK: - SearchTabViewController
final class SearchTabViewController: BaseViewController, SearchTabViewProtocol {
    // MARK: - Outlets
    @IBOutlet private weak var searchBackgroundView: UIView!
    @IBOutlet private weak var searchBar: UISearchBar!
    
    // MARK: - Components
    var presenter: SearchTabPresenterProtocol? {
        get { return basePresenter as? SearchTabPresenterProtocol }
        set { basePresenter = newValue }
    }

    // MARK: - Life Cycles
    override public func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Interface Configuration
    override func configureInterface() {
        super.configureInterface()
        configureNavigationBar()
    }
    
    // MARK: - Observe
    override func observeContent() {
        super.observeContent()
        configureNavigationBar()
        configureContainerView()
        configureSearchBar()
    }
    
    // MARK: - Init
    public init() {
        super.init(nibName: String(describing: Self.self), bundle: Bundle.module)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Interface Configuration
private extension SearchTabViewController {
    final func configureNavigationBar() {
        shouldShowNavigationBar = false
    }
    
    final func configureContainerView() {
        view.backgroundColor = .black
    }
    
    final func configureSearchBar() {
        searchBar.delegate = self
        searchBar.placeholder = L10nSearch.searchPlaceholder.localized()
        
        searchBackgroundView.backgroundColor = .primaryColor
        searchBar.barTintColor = .primaryColor
        searchBar.searchTextField.textColor = .white
    }
}

// MARK: - Interface Configuration
extension SearchTabViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("⭕️ \(searchText.lowercased())")
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let keyword = searchBar.text,
              !keyword.isEmpty else { return }
        presenter?.routeToSearch(with: keyword)
    }
}
