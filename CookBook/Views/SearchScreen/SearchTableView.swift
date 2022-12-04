import UIKit

protocol SearchTableViewOutput: AnyObject {
    func didPressedCell(_ indexPath: IndexPath)
}

final class SearchTableView: UITableView {
    
    enum Section: Hashable {
        case main
    }
    
    var output: SearchTableViewOutput!
    var data: [SearchResult]?
    var source: UITableViewDiffableDataSource<Section, SearchResult>?
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private func

private extension SearchTableView {
    func configureDataSource() {
        source = UITableViewDiffableDataSource<Section, SearchResult>(tableView: self, cellProvider: { (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
            let cell = tableView.dequeueCell(type: SearchTableViewMiniCell.self, with: indexPath)
            cell.configure(recipe: self.data?[indexPath.row])
            return cell
        })
        guard let data = data else { return }
        createSnapshot(items: data, toSection: .main)
    }
    
    func setup() {
        backgroundColor = .clear
        estimatedRowHeight = 120
        rowHeight = UITableView.automaticDimension
        keyboardDismissMode = .onDrag
        delegate = self
        translatesAutoresizingMaskIntoConstraints = false
        register(type: SearchTableViewMiniCell.self)
        configureDataSource()
    }
}

// MARK: - Public func

extension SearchTableView {
    func createSnapshot(items: [SearchResult], toSection: Section) {
        data = items
        
        var snapshot = NSDiffableDataSourceSnapshot<Section, SearchResult>()

        snapshot.appendSections([toSection])
        snapshot.appendItems(items, toSection: toSection)

        source?.apply(snapshot, animatingDifferences: true)
    }
}

// MARK: - UITableViewDelegate

extension SearchTableView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        output.didPressedCell(indexPath)
    }
}
