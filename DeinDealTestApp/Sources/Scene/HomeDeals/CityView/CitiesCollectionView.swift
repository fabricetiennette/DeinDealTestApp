import UIKit
import Reusable

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
        self.register(cellType: CitiesCollectionViewCell.self)
        self.accessibilityIdentifier = "CitiesCollectionView.collectionView"
    }
}
