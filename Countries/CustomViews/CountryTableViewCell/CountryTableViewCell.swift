//
import UIKit

class CountryTableViewCell: UITableViewCell {
    var country: Country?
    var chevronTapHandler: (() -> Void)?
    var viewModel: CountryTableViewCellViewModel?
    
    let flagImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 12
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "SFPro-Regular", size: 14)
        return label
    }()
    
    let chevronImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    
    let dynamicBackground = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
    let dynamicChevronColor = UIColor.dynamicColor(light: UIColor.black, dark: UIColor.white)
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        updateCellAppearance()
        chevronImageView.tintColor = dynamicChevronColor
        contentView.addSubview(flagImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(chevronImageView)
        
        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        chevronImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            flagImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 30),
            flagImageView.heightAnchor.constraint(equalToConstant: 30),
            
            nameLabel.trailingAnchor.constraint(equalTo: chevronImageView.leadingAnchor, constant: -4),
            nameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            chevronImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -19),
            chevronImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            chevronImageView.widthAnchor.constraint(equalToConstant: 18),
            chevronImageView.heightAnchor.constraint(equalToConstant: 18)
        ])
        
        selectionStyle = .none
        contentView.layer.cornerRadius = 24
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = dynamicBackground.cgColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleChevronTap))
        chevronImageView.addGestureRecognizer(tapGesture)
        
    }
    
    // აქ რომ ვორნინგი მაქვს ვიცი, საქმე ისაა რომ სხვანაირად ვერ ვაკეთებ სელის ბორდერს თეთრს,
    // ყველაფერი დანარჩენი შევცვალე traitCollectionDidChange- ის გარეშე, მაგრამ ამას ვერ ვშვრები და დიდად
    // დამავალებთ,  თუ მასწავლით რა არის ბესთ ფრაქთისი.
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        updateCellAppearance()
    }
    private func updateCellAppearance() {
        let borderColor = UIColor.dynamicColor(light: .black, dark: .white)
        contentView.layer.borderColor = borderColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleChevronTap() {
        chevronTapHandler?()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let cellSpacing: CGFloat = 10
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: cellSpacing / 2, left: 0, bottom: cellSpacing / 2, right: 0))
    }
    
    func setFlagImage(from urlString: String) {
        guard let url = URL(string: urlString) else {
            return
        }
        
        ImageDownloader.shared.downloadImage(from: url) { [weak self] image in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                self.flagImageView.image = image
            }
        }
    }
    func configure(with country: Country) {
        nameLabel.text = country.name.common
        
        if let flagURL = country.flags["png"] {
            setFlagImage(from: flagURL)
        } else {
            print("url is missing")
        }
    }
    
    func configure(with viewModel: CountryTableViewCellViewModel?) {
        guard let viewModel = viewModel else {
            return
        }
        nameLabel.text = viewModel.countryName
        setFlagImage(from: viewModel.flagURL)
    }
}
