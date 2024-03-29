import UIKit

public final class CitiesCollectionView: UICollectionView {
    public init() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        super.init(frame: .zero, collectionViewLayout: layout)

        setupCollectionView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CitiesCollectionView {
    private func setupCollectionView() {
        self.register(CitiesCollectionViewCell.self, forCellWithReuseIdentifier: "CitiesCollectionViewCell")
        self.accessibilityIdentifier = "CitiesCollectionView.collectionView"
    }
}
