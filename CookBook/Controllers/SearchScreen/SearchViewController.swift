import UIKit

final class SearchViewController: UIViewController {
    
    private lazy var tableView: SearchTableView = {
        let view = SearchTableView(frame: view.frame, style: .plain)
        view.tableHeaderView = searchBar
        view.output = self
        return view
    }()
    private lazy var searchBar: UISearchBar = {
        var view = UISearchBar(frame: .zero)
        view.delegate = self
        view.showsCancelButton = false
        view.searchBarStyle = .minimal
        view.backgroundColor = .clear
        view.placeholder = "Search fun recipes"
        view.searchTextField.leftView?.tintColor = Theme.cbYellow50
        view.searchTextField.backgroundColor = Theme.appColor
        return view
    }()
    
    override func viewDidLoad() {
        setup()
    }
}

// MARK: - Private functions

private extension SearchViewController {
    func setup() {
        title = "Discover"
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor)
        ])
    }
}


// MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text else { return }
        let networkClient = NetworkClient()
        networkClient.searchRecipe(with: searchText) { result in
            self.tableView.createSnapshot(items: result.results, toSection: .main)
        }
    }
}

extension SearchViewController: SearchTableViewOutput {
    func didPressedCell(_ indexPath: IndexPath) {
        
    }
}
