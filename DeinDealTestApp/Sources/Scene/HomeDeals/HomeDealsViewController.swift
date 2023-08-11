import UIKit
import Combine

public final class HomeDealsViewController: AppViewController<HomeDealsModule.ViewModel> {
    
    private lazy var homeScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.accessibilityIdentifier = "homeScrollView.HomeDealsViewController"
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bannerView,
                                                       labelContainerView,
                                                       citiesCollectionView,
                                                       advertImageView,
                                                       advertImageView2,
                                                       advertImageView3])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 20
        stackView.accessibilityIdentifier = "containterStackView.HomeDealsViewController"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bannerView: BannerView = {
        let bannerView = BannerView()
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        return bannerView
    }()
    
    private lazy var labelContainerView: UIView = {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        return containerView
    }()
    
    private lazy var citieslabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var citiesCollectionView: UICollectionView = {
        let collectionView = CitiesCollectionView()
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.accessibilityIdentifier = "citiesCollectionView.HomeDealsViewController"
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var advertImageView: UIImageView = createAdvertImageView()
    private lazy var advertImageView2: UIImageView = createAdvertImageView()
    private lazy var advertImageView3: UIImageView = createAdvertImageView()
    
    private let loader = LoaderIndicator()
    private var cancellables: Set<AnyCancellable> = []
    private var cities: [City] = []
    private var hasAppliedAnimation = false
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "DeinDeal Restaurant"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        setupConstraints()
        bindViewModel()
        configureView()
    }
    
    private func bindViewModel() {
        viewModel.cities
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newCities in
                guard let self else { return }
                self.loader.hideCircleStroke()
                self.cities = newCities
                self.citiesCollectionView.reloadData()
                self.animateViewsIn()
            }
            .store(in: &cancellables)
        
        loader.showCircleStroke(indicator: view)
        viewModel.fetchCities()
    }
    
    private func configureView() {
        citieslabel.text = "Nearby cities:"
        bannerView.isHidden = true
        bannerView.configureBanner(title: "Hungry? We deliver",
                                   description: "Tap here to select an address",
                                   icon: UIImage(named: "location_icon"))
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showBannerWithSlideInAnimation()
        }
        
        containerStackView.setCustomSpacing(0, after: bannerView)
        containerStackView.setCustomSpacing(0, after: labelContainerView)
    }
    
    private func animateViewsIn() {
        citieslabel.fadeAnimationIn()
        citiesCollectionView.fadeAnimationIn()
        advertImageView.fadeAnimationIn()
        advertImageView2.fadeAnimationIn()
        advertImageView3.fadeAnimationIn()
    }
    
    private func createAdvertImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "advert_image")
        return imageView
    }
    
    func showBannerWithSlideInAnimation() {
        let animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) {
            self.bannerView.isHidden = false
            self.bannerView.transform = .identity
        }
        
        animator.startAnimation()
    }
    
    private func setupConstraints() {
        view.addSubview(homeScrollView)
        homeScrollView.addSubview(containerStackView)
        labelContainerView.addSubview(citieslabel)
        
        NSLayoutConstraint.activate([
            homeScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            homeScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            homeScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            homeScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            homeScrollView.widthAnchor.constraint(equalToConstant: view.bounds.width),
            
            containerStackView.topAnchor.constraint(equalTo: homeScrollView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: homeScrollView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: homeScrollView.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: homeScrollView.bottomAnchor),
            containerStackView.widthAnchor.constraint(equalTo: homeScrollView.widthAnchor),
            
            citiesCollectionView.heightAnchor.constraint(equalToConstant: 120),
            bannerView.heightAnchor.constraint(equalToConstant: 100),
            
            labelContainerView.heightAnchor.constraint(equalToConstant: 40),
            citieslabel.bottomAnchor.constraint(equalTo: labelContainerView.bottomAnchor),
            citieslabel.leadingAnchor.constraint(equalTo: labelContainerView.leadingAnchor,constant: 20),
            citieslabel.trailingAnchor.constraint(equalTo: labelContainerView.trailingAnchor),
        ])
    }
}

extension HomeDealsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cities.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: CitiesCollectionViewCell = collectionView.dequeueReusableCell(for: indexPath)
        let city = cities[indexPath.row]
        cell.configureCell(with: city)
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 175, height: 100)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    
}
