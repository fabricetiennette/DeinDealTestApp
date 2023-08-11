import UIKit

public final class CityItemCollectionView: UICollectionView {
    public init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        super.init(frame: .zero, collectionViewLayout: layout)

        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CityItemCollectionView {
    private func setupCollectionView() {
        self.register(CityItemCollectionViewCell.self, forCellWithReuseIdentifier: "CityItemCollectionViewCell")
        self.accessibilityIdentifier = "CitiesCollectionView.collectionView"
    }
}

