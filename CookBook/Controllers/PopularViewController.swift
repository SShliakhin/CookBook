//
//  ЗщзгдфеМшуцСщтекщддук.swift
//  CookBook
//
//  Created by Alexander Altman on 30.11.2022.
//

import UIKit

final class PopularViewController: UIViewController {
//    private let startButton = UIButton(type: .system)
    
    lazy var headerLabel: UILabel = {
        let label = UILabel()
        label.text = "Sedan Cookbook"
        label.font = .boldSystemFont(ofSize: 40)
        label.textColor = .red
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private var popularCollectionView = PopularCollectionView()
    
    
    override func viewDidLoad() {
        self.navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .systemGray3
        setupViews()
        setConstraints()
        popularCollectionView.setData(cells: PopularRecipe.fetchRecipes())
        
        
        
//        startButton.setTitle("Recipe", for: [])
//        startButton.addTarget(self, action: #selector(startButtonTapped), for: .primaryActionTriggered)
//
//        startButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(startButton)
//
//        NSLayoutConstraint.activate([
//            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
    }
    
//    @objc func startButtonTapped(_ sender: UIButton) {
//        let vc = DetailViewController()
//        navigationController?.pushViewController(vc, animated: true)
//    }
    
    func setupViews() {
        view.addSubview(headerLabel)
        view.addSubview(popularCollectionView)
    }
    
  
}



//MARK: - Set Constraints
extension PopularViewController {
   private func setConstraints() {
        NSLayoutConstraint.activate([
            headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 6)
        ])
       
       NSLayoutConstraint.activate([
        popularCollectionView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
        popularCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        popularCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        popularCollectionView.heightAnchor.constraint(equalToConstant: 450)
       ])
    }
}

//MARK: -Live Preview
#warning("delete before PR")
import SwiftUI
struct ListProvider: PreviewProvider {
    static var previews: some View {
        ContainterView().edgesIgnoringSafeArea(.all)
    }
    
    struct ContainterView: UIViewControllerRepresentable {
        let listVC = PopularViewController()
        func makeUIViewController(context:
                                  UIViewControllerRepresentableContext<ListProvider.ContainterView>) -> PopularViewController {
            return listVC
        }
        
        func updateUIViewController(_ uiViewController:
                                    ListProvider.ContainterView.UIViewControllerType, context:
                                    UIViewControllerRepresentableContext<ListProvider.ContainterView>) {
        }
    }
}
