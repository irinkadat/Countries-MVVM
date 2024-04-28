import UIKit

class CountriesVC: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    var viewModel = CountriesViewModel()
    
    let tableViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "Search Countries"
        searchBar.delegate = self
        return searchBar
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(CountryTableViewCell.self, forCellReuseIdentifier: "CountryTableViewCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        return tableView
    }()
    let dynamicBackground = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: - logout method to simulate a logout scenario
        
//        if let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate {
//            sceneDelegate.logoutForTesting()
//        }

        
        navigationItem.hidesBackButton = true
        self.view.backgroundColor = dynamicBackground
        setSearchBar()
        setTableView()
        viewModel.fetchData { error in
            if let error = error {
                print("Error fetching data: \(error)")
            } else {
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
        navigateToDetails()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "Countries"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setSearchBar() {
        searchBar.searchBarStyle = .minimal
        
        let searchBarContainer = UIView()
        searchBarContainer.translatesAutoresizingMaskIntoConstraints = false
        searchBarContainer.addSubview(searchBar)
        
        if let microphoneImage = UIImage(systemName: "mic.fill") {
            let microphoneImageView = UIImageView(image: microphoneImage)
            microphoneImageView.contentMode = .center
            microphoneImageView.translatesAutoresizingMaskIntoConstraints = false
            searchBarContainer.addSubview(microphoneImageView)
            
            NSLayoutConstraint.activate([
                microphoneImageView.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor, constant: -32),
                microphoneImageView.centerYAnchor.constraint(equalTo: searchBarContainer.centerYAnchor),
                microphoneImageView.widthAnchor.constraint(equalToConstant: 24),
                microphoneImageView.heightAnchor.constraint(equalToConstant: 24)
            ])
        }
        view.addSubview(searchBarContainer)
        
        NSLayoutConstraint.activate([
            searchBarContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBarContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBarContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBarContainer.heightAnchor.constraint(equalToConstant: 44),
            
            searchBar.leadingAnchor.constraint(equalTo: searchBarContainer.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: searchBarContainer.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: searchBarContainer.topAnchor),
            searchBar.bottomAnchor.constraint(equalTo: searchBarContainer.bottomAnchor)
        ])
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filterCountries(with: searchText)
        tableView.reloadData()
    }
    
    func configureNavTitle() {
        if let customFont = UIFont(name: "SFPro-Bold", size: 24) {
            let attrs = [
                NSAttributedString.Key.foregroundColor: UIColor.label,
                NSAttributedString.Key.font: customFont
            ]
            navigationController?.navigationBar.largeTitleTextAttributes = attrs
        }
    }
    
    func setTableView() {
        tableView.backgroundColor = dynamicBackground
        
        tableViewContainer.addSubview(tableView)
        view.addSubview(tableViewContainer)
        
        NSLayoutConstraint.activate([
            tableViewContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            tableViewContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            tableViewContainer.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 14),
            tableViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: tableViewContainer.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: tableViewContainer.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: tableViewContainer.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: tableViewContainer.bottomAnchor)
        ])
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfCountries
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CountryTableViewCell", for: indexPath) as? CountryTableViewCell else {
            fatalError("Unable to dequeue CountryTableViewCell")
        }
        
        if let country = viewModel.country(at: indexPath.row) {
            let cellViewModel = CountryTableViewCellViewModel(country: country)
            cell.configure(with: cellViewModel)
            cell.backgroundColor = .clear
            cell.chevronTapHandler = {
                self.viewModel.navigateToCountryDetails(index: indexPath.row)

            }
        }
        return cell
    }
    
    // MARK: - UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.navigateToCountryDetails(index: indexPath.row)
    }
    
    func navigateToDetails() {
        viewModel.onCountrySelected = {[weak self] country in
            let countryDetailsViewModel = DetailsViewModel(country: country)
            let detailsVC = DetailsVC(viewModel: countryDetailsViewModel)
            self?.navigationController?.navigationBar.prefersLargeTitles = false
            self?.navigationController?.pushViewController(detailsVC, animated: false)
        }
    }
}


