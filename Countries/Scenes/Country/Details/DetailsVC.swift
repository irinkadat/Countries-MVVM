//
//  DetailsVC.swift
//  Countries
//
//  Created by Irinka Datoshvili on 21.04.24.
//

import UIKit

class DetailsVC: UIViewController {
    
    // MARK: - Properties
    
    private let viewModel: DetailsViewModel
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let googleMapsIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "googlemap")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let openStreetMapsIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "openstreetmap")
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()
    
    var flagDetailsLabel = UILabel()
    var timezoneLabel = UILabel();
    var spellingLabel = UILabel();
    var capitalLabel = UILabel();
    var regionLabel = UILabel();
    var neighborsLabel = UILabel();
    var populationLabel = UILabel()
    let dynamicBackground = UIColor.dynamicColor(light: UIColor.white, dark: UIColor(red: 0.24, green: 0.24, blue: 0.24, alpha: 1.0))
    
    // MARK: - Init methods
    
    init(viewModel: DetailsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = dynamicBackground
        navigationItem.title = viewModel.country?.name.common
        setupScrollView()
        viewModel.onDataUpdate = { [weak self] in
            guard let self = self else { return }
            self.updateUI(with: self.viewModel)
        }
        viewModel.fetchCountryDetails()
        setupViews()
        
        let googleMapsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openGoogleMaps))
        googleMapsIcon.addGestureRecognizer(googleMapsTapGestureRecognizer)
        googleMapsIcon.isUserInteractionEnabled = true
        
        let openStreetMapsTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(openOpenStreetMaps))
        openStreetMapsIcon.addGestureRecognizer(openStreetMapsTapGestureRecognizer)
        openStreetMapsIcon.isUserInteractionEnabled = true
    }
    
    // MARK: - Actions
    
    @objc private func openGoogleMaps() {
        if let googleMapsURLString = viewModel.country?.maps.googleMaps, let googleMapsURL = URL(string: googleMapsURLString) {
            openURL(googleMapsURL)
        }
    }
    
    @objc private func openOpenStreetMaps() {
        if let openStreetMapsURLString = viewModel.country?.maps.openStreetMaps, let openStreetMapsURL = URL(string: openStreetMapsURLString) {
            openURL(openStreetMapsURL)
        }
    }
    
    // MARK: - Helper Methods
    
    private func openURL(_ url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    
    private func createInfoLabel(title: String, value: UILabel) -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 80
        
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.font = UIFont(name: "SFPro-Regular", size: 14)
        titleLabel.numberOfLines = 0
        value.numberOfLines = 0
        value.font = UIFont(name: "SFPro-Regular", size: 14)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(value)
        
        return stackView
    }
    
    // MARK: - Display Data
    
    private func updateUI(with item: DetailsViewModel) {
        
        if let flagImageUrl = item.flagImg {
            flagImageView.fetchImage(url: flagImageUrl)
        } else {
            print("Flag image URL is missing")
        }
        flagDetailsLabel.text = item.flagDetails
        timezoneLabel.text = item.timezone
        spellingLabel.text = item.spelling
        capitalLabel.text = item.capital
        neighborsLabel.text = item.borders
        populationLabel.text = item.population
        regionLabel.text = item.region
    }
    
    // MARK: - Setup
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setupViews() {
        flagDetailsLabel.numberOfLines = 0
        contentView.addSubview(flagImageView)
        
        let aboutFlagStackView = UIStackView()
        aboutFlagStackView.axis = .vertical
        aboutFlagStackView.spacing = 8
        aboutFlagStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let aboutFlagTitleLabel = UILabel()
        aboutFlagTitleLabel.text = "About the Flag"
        aboutFlagTitleLabel.font = UIFont(name: "SFPro-Bold", size: 16)
        
        aboutFlagStackView.addArrangedSubview(aboutFlagTitleLabel)
        aboutFlagStackView.addArrangedSubview(flagDetailsLabel)
        
        contentView.addSubview(aboutFlagStackView)
        
        let basicInfoStackView = UIStackView()
        basicInfoStackView.axis = .vertical
        basicInfoStackView.spacing = 20
        basicInfoStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let basicInfoTitleLabel = UILabel()
        basicInfoTitleLabel.text = "Basic Information"
        basicInfoTitleLabel.font = UIFont(name: "SFPro-Bold", size: 16)
        
        basicInfoStackView.addArrangedSubview(basicInfoTitleLabel)
        basicInfoStackView.addArrangedSubview(createInfoLabel(title: "Time Zone", value: timezoneLabel))
        basicInfoStackView.addArrangedSubview(createInfoLabel(title: "Spelling", value: spellingLabel))
        basicInfoStackView.addArrangedSubview(createInfoLabel(title: "Capital", value: capitalLabel))
        basicInfoStackView.addArrangedSubview(createInfoLabel(title: "Region", value: regionLabel))
        basicInfoStackView.addArrangedSubview(createInfoLabel(title: "Neighbors", value: neighborsLabel))
        basicInfoStackView.addArrangedSubview(createInfoLabel(title: "Population", value: populationLabel))
        
        contentView.addSubview(basicInfoStackView)
        
        let usefulLinksStackView = UIStackView()
        usefulLinksStackView.axis = .horizontal
        usefulLinksStackView.spacing = 40
        usefulLinksStackView.translatesAutoresizingMaskIntoConstraints = false
        
        let usefulLinksTitleLabel = UILabel()
        usefulLinksTitleLabel.text = "Useful Links"
        usefulLinksTitleLabel.font = UIFont(name: "SFPro-Bold", size: 16)
        usefulLinksTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(usefulLinksTitleLabel)
        
        usefulLinksStackView.addArrangedSubview(openStreetMapsIcon)
        usefulLinksStackView.addArrangedSubview(googleMapsIcon)
        
        contentView.addSubview(usefulLinksStackView)
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.layer.cornerRadius = 87
        flagImageView.layer.shadowColor = UIColor.black.cgColor
        flagImageView.layer.shadowOffset = CGSize(width: 0, height: 4)
        flagImageView.layer.shadowOpacity = 0.5
        flagImageView.layer.shadowRadius = 4
        flagImageView.layer.masksToBounds = false
        flagImageView.layer.cornerRadius = 30
        flagImageView.layer.masksToBounds = true
        
        let lineSeparator = UIView()
        lineSeparator.translatesAutoresizingMaskIntoConstraints = false
        lineSeparator.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        contentView.addSubview(lineSeparator)
        
        let lineSeparator2 = UIView()
        lineSeparator2.translatesAutoresizingMaskIntoConstraints = false
        lineSeparator2.backgroundColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1.0)
        contentView.addSubview(lineSeparator2)
        
        NSLayoutConstraint.activate([
            
            flagImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            flagImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            flagImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            
            aboutFlagStackView.topAnchor.constraint(equalTo: flagImageView.bottomAnchor, constant: 20),
            aboutFlagStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            aboutFlagStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            lineSeparator.heightAnchor.constraint(equalToConstant: 1),
            lineSeparator.topAnchor.constraint(equalTo: aboutFlagStackView.bottomAnchor, constant: 24),
            lineSeparator.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            lineSeparator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            basicInfoStackView.topAnchor.constraint(equalTo: lineSeparator.bottomAnchor, constant: 24),
            basicInfoStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            basicInfoStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            lineSeparator2.heightAnchor.constraint(equalToConstant: 1),
            lineSeparator2.topAnchor.constraint(equalTo: basicInfoStackView.bottomAnchor, constant: 24),
            lineSeparator2.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            lineSeparator2.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32),
            
            usefulLinksTitleLabel.topAnchor.constraint(equalTo: lineSeparator2.bottomAnchor, constant: 20),
            usefulLinksTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            usefulLinksTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            usefulLinksStackView.topAnchor.constraint(equalTo: usefulLinksTitleLabel.bottomAnchor, constant: 15),
            usefulLinksStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            usefulLinksStackView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
            
        ])
    }
}



