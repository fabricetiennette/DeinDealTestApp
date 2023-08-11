import UIKit
import SDWebImage

public final class FilterCollectionViewCell: UICollectionViewCell {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var circleView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 30
        view.clipsToBounds = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    public func configureCell(with category: FacetCategory) {
        addSubview(circleView)
        circleView.addSubview(imageView)
        addSubview(titleLabel)
        
        setupLayout()
        accessibilityIdentifier = "FilterCollectionViewCell"
        
        titleLabel.text = category.label
        if let imageUrl = URL(string: category.icon) {
            imageView.sd_setImage(with: imageUrl)
        }
    }
    
    public override var isSelected: Bool {
        didSet {
            circleView.backgroundColor = isSelected ? UIColor(named: "main") : .clear
            titleLabel.textColor = isSelected ? UIColor(named: "main") : .black
            titleLabel.font = isSelected ? UIFont.systemFont(ofSize: 14, weight: .bold) : UIFont.systemFont(ofSize: 14) 
        }
    }
    
    private func setupLayout() {
        
        NSLayoutConstraint.activate([
            circleView.centerXAnchor.constraint(equalTo: centerXAnchor),
            circleView.centerYAnchor.constraint(equalTo: centerYAnchor),
            circleView.widthAnchor.constraint(equalToConstant: 60),
            circleView.heightAnchor.constraint(equalToConstant: 60),
            
            imageView.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: circleView.centerYAnchor),
            imageView.widthAnchor.constraint(equalTo: circleView.widthAnchor, multiplier: 0.7),
            imageView.heightAnchor.constraint(equalTo: circleView.heightAnchor, multiplier: 0.7),
            
            titleLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 5),
            titleLabel.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            titleLabel.widthAnchor.constraint(equalTo: circleView.widthAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
}
