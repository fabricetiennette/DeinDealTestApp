import UIKit

public final class FilterCollectionView: UICollectionView {
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

extension FilterCollectionView {
    private func setupCollectionView() {
        self.register(FilterCollectionViewCell.self, forCellWithReuseIdentifier: "FilterCollectionViewCell")
        self.accessibilityIdentifier = "FilterCollectionView.collectionView"
    }
}
