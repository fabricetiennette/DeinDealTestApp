import UIKit

class CityItemCollectionViewManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var cityItems = [CityItem]()
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cityItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dequeueAndConfigureCell(for: indexPath, on: collectionView)
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width / 1.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
    }
    
    // MARK: - Helper Methods
    
    private func dequeueAndConfigureCell(for indexPath: IndexPath, on collectionView: UICollectionView) -> CityItemCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CityItemCollectionViewCell", for: indexPath) as? CityItemCollectionViewCell else {
            fatalError("Unexpected cell type")
        }
        cell.configureCell(with: cityItems[indexPath.row])
        return cell
    }
}
