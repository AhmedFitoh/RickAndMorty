//
//  ViewController.swift
//  RickAndMorty
//
//  Created by AhmedFitoh on 2/7/25.
//

import SwiftUI
import Combine

final class CharacterListViewController: UIViewController {
    private let viewModel: CharacterListViewModel
    private let filterContainer = UIView()
    private var cancellables = Set<AnyCancellable>()
    private var filterHostingController: UIHostingController<StatusFilterView>?
    
    private lazy var tableView: UITableView = {
        let table = UITableView()
        table.backgroundColor = .systemBackground
        table.register(SwiftUITableViewCell<CharacterRowView>.self, forCellReuseIdentifier: "CharacterCell")
        table.rowHeight = 110
        table.separatorStyle = .none
        table.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        return table
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .medium)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    init(viewModel: CharacterListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
        loadCharacters()
    }
    
    private func setupUI() {
        title = "Characters"
        view.backgroundColor = .systemBackground
        
        [filterContainer, tableView, loadingIndicator].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            filterContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            filterContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterContainer.heightAnchor.constraint(equalToConstant: 44),
            
            tableView.topAnchor.constraint(equalTo: filterContainer.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        tableView.delegate = self
        tableView.dataSource = self

        updateFilterView()
    }
    
    private func setupBindings() {
        // Bind state changes
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.handleState(state)
            }
            .store(in: &cancellables)
        
        // Bind characters array changes
        viewModel.$characters
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // Bind selectedStatus changes
        viewModel.$selectedStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateFilterView()
            }
            .store(in: &cancellables)
    }

    private func updateFilterView() {
        let statusFilterView = StatusFilterView(selectedStatus: Binding(
            get: { [weak self] in
                self?.viewModel.selectedStatus
            },
            set: { [weak self] newStatus in
                Task { @MainActor in
                    await self?.viewModel.filterByStatus(newStatus)
                }
            }
        ))
        
        if let existingController = filterHostingController {
            existingController.rootView = statusFilterView
        } else {
            let controller = UIHostingController(rootView: statusFilterView)
            filterHostingController = controller
            addChild(controller)
            filterContainer.addSubview(controller.view)
            controller.view.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                controller.view.topAnchor.constraint(equalTo: filterContainer.topAnchor),
                controller.view.leadingAnchor.constraint(equalTo: filterContainer.leadingAnchor),
                controller.view.trailingAnchor.constraint(equalTo: filterContainer.trailingAnchor),
                controller.view.bottomAnchor.constraint(equalTo: filterContainer.bottomAnchor)
            ])
            controller.didMove(toParent: self)
        }
    }
    
    private func loadCharacters() {
        Task {
            await viewModel.loadCharacters()
        }
    }

    private func handleState(_ state: CharacterListViewModel.State) {
        switch state {
        case .idle:
            loadingIndicator.stopAnimating()
        case .loading:
            loadingIndicator.startAnimating()
        case .loaded:
            loadingIndicator.stopAnimating()
        case .error(let message):
            loadingIndicator.stopAnimating()
            presentError(message)
        }
    }
    
    private func presentError(_ message: String) {
        let alert = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension CharacterListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.characters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: "CharacterCell",
            for: indexPath
        ) as? SwiftUITableViewCell<CharacterRowView> else {
            return UITableViewCell()
        }
        
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        cell.configure(with: CharacterRowView(
            character: viewModel.characters[indexPath.row],
            index: indexPath.row
        ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let character = viewModel.characters[indexPath.row]
        viewModel.didSelectCharacter(character)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height
        
        if offsetY > contentHeight - height * 1.2 {
            Task {
                await viewModel.loadCharacters(loadMore: true)
            }
        }
    }
}
