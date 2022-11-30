//
//  OnboardingViewController.swift
//  CookBook
//
//  Created by SERGEY SHLYAKHIN on 28.11.2022.
//

import UIKit

protocol OnboardingViewControllerDelegate: AnyObject {
    func didFinishOnboarding()
}

final class OnboardingViewController: UIViewController {

    private let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = UIImage()
        return imageView
    }()
    private let startButton = UIButton(type: .system)
    
    weak var delegate: OnboardingViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        applyStyle()
        applyLayout()
    }
}

extension OnboardingViewController {
    private func setup() {
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .primaryActionTriggered)
    }
    
    private func applyStyle() {
        view.backgroundColor = .systemBackground
        startButton.setTitle("Start", for: [])
    }
    
    private func applyLayout() {
        [backgroundImageView, startButton].forEach { item in
            item.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(item)
        }
        
        NSLayoutConstraint.activate([
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
}

// MARK: - Actions
extension OnboardingViewController {
    @objc func startButtonTapped(_ sender: UIButton) {
        
        let dataProvider = RecipesProviderImpl()
        dataProvider.loadRecipes { result in
            switch result {
            case let .success(model):
                print(model.recipes[0].title)
                print(model.recipes[0].readyInMinutes)
                print(model.recipes[0].image)
                print(model.recipes[0].instructions)
            case let .failure(error):
                print(error)
            }
        }
        
        delegate?.didFinishOnboarding()
    }
}
