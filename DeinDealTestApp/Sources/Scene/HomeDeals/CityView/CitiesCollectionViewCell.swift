import Foundation
import Reusable
import UIKit
import SDWebImage
import Kingfisher

public final class CitiesCollectionViewCell: UICollectionViewCell, Reusable {
    
    private lazy var cityImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.opacity = 0.7
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 24, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        cityImageView.image = nil
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    public func configureCell(with city: City) {
        contentView.addSubview(cityImageView)
        contentView.addSubview(cityLabel)
        
        setupLayout()
        style()
        
        cityLabel.text = city.channelInfo.title
        if let imageUrl = URL(string: city.channelInfo.images.large) {
            cityImageView.sd_setImage(with: imageUrl)
        }
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            cityImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cityImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            cityImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cityImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            cityLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            cityLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            cityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6),
            cityLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
    }
    
    func style() {
        accessibilityIdentifier = "CitiesCollectionViewCell"
        self.roundCorners(corners: .allCorners, radius: 14)
        self.backgroundColor = .gray
    }
}

