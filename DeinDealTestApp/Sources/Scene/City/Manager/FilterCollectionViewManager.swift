import UIKit

class FilterCollectionViewManager: NSObject, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var facetCategories = [FacetCategory]()
    var selectedIndexPath: IndexPath?
    var viewModel: CityModule.ViewModel?
    
    // MARK: - UICollectionViewDataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        facetCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        dequeueAndConfigureCell(for: indexPath, on: collectionView)
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < facetCategories.count else { return }
        
        if selectedIndexPath == indexPath {
            collectionView.deselectItem(at: indexPath, animated: true)
            viewModel?.didSelectCategory(with: "all")
            selectedIndexPath = nil
        } else {
            viewModel?.didSelectCategory(with: facetCategories[indexPath.row].id)
            selectedIndexPath = indexPath
        }
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 72, height: 72)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 20, bottom: 10, right: 20)
    }
    
    // MARK: - Helper Methods
    
    private func dequeueAndConfigureCell(for indexPath: IndexPath, on collectionView: UICollectionView) -> FilterCollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterCollectionViewCell", for: indexPath) as? FilterCollectionViewCell else {
            fatalError("Unexpected cell type")
        }
        cell.configureCell(with: facetCategories[indexPath.row])
        return cell
    }
}

