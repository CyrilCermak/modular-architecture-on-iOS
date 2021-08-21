
//
//  SpacesuitViewController.swift
//  ISSSpacesuit
//
//  Created by Cyril Cermak on 27.02.21.
//

import UIKit
import Combine
import ISSUIComponents

class SpacesuitViewController: UIViewController, Outputable {
    enum Action { case close }
    
    /// Outputable protocol fullfilment
    lazy var output: AnyPublisher<Action, Never> = {
        return outputAction.eraseToAnyPublisher()
    }()
    
    private lazy var outputAction = PassthroughSubject<T, Never>()
    private let spacesuitView = SpacesuitView(frame: .zero)
    private var model: SpacesuitViewModel!
    private var subscriptions = Set<AnyCancellable>()
    
    convenience init(viewModel: SpacesuitViewModel) {
        self.init()
        self.model = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Spacesuit"
        bindView()
        
        // Close button in Navigation
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = barButtonItem
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        model.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        model.stop()
    }
    
    override func loadView() {
        self.view = spacesuitView
    }
    
    private func bindView() {
        model.$models
            .sink { [weak spacesuitView] (models) in
                spacesuitView?.bind(models: models)
            }
            .store(in: &subscriptions)
    }
    
    @objc
    func didTapClose() {
        outputAction.send(.close)
    }
}
