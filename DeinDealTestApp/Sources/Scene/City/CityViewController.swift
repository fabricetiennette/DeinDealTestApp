import UIKit
import Combine

public final class CityViewController: AppViewController<CityModule.ViewModel> {
    
    // MARK: - UI Components
    
    private lazy var cityScrollView: UIScrollView = {
        let view = UIScrollView()
        view.showsVerticalScrollIndicator = false
        view.accessibilityIdentifier = "cityScrollView.CityViewController"
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var containerStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [bannerView, filterCollectionView])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = 0
        stackView.accessibilityIdentifier = "containterStackView.CityViewController"
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private lazy var bannerView: BannerView = {
        let bannerView = BannerView()
        bannerView.isHidden = true
        bannerView.translatesAutoresizingMaskIntoConstraints = false

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleBannerTap))
        bannerView.addGestureRecognizer(tapGesture)
        bannerView.isUserInteractionEnabled = true
        bannerView.accessibilityIdentifier = "bannerView.CityViewController"
        return bannerView
    }()
    
    private lazy var filterCollectionView: UICollectionView = {
        let collectionView = FilterCollectionView()
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var cityItemCollectionView: UICollectionView = {
        let collectionView = CityItemCollectionView()
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private lazy var pickerContainerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        view.backgroundColor = .secondarySystemBackground
        view.isHidden = true
        view.accessibilityIdentifier = "pickerContainerView.CityViewController"
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var cityPickerView: UIPickerView = {
        let pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.backgroundColor = .secondarySystemBackground
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        return pickerView
    }()
    
    private lazy var pickerToolbar: UIToolbar = {
        let pickerToolbar = UIToolbar()
        pickerToolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissPicker))
        doneButton.tintColor = UIColor(named: "main")
        pickerToolbar.setItems([.flexibleSpace(), doneButton], animated: false)
        pickerToolbar.barTintColor = .secondarySystemBackground
        pickerToolbar.translatesAutoresizingMaskIntoConstraints = false
        return pickerToolbar
    }()
    
    // MARK: - Properties

    private var cancellables: Set<AnyCancellable> = []
    private var newSelectedCityId: String = ""
    private var currentDisplayedCityId: String = ""
    private var cityCollectionViewHeightConstraint: NSLayoutConstraint?
    private let loader = LoaderIndicator()
    
    private var cityItemCollectionViewManager: CityItemCollectionViewManager?
    private var filterCollectionViewManager: FilterCollectionViewManager?
    
    // MARK: - Lifecycle Methods
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        bindViewModel()
        configureBannerView(withTitle: title)
    }
    
    // MARK: - Gesture Handlers
    
    @objc private func handleBannerTap() {
        animatePickerView(alpha: 1, completion: nil)
    }
    
    @objc func dismissPicker() {
        animatePickerView(alpha: 0) { _ in
            guard self.newSelectedCityId != self.currentDisplayedCityId else { return }
            self.clearDataAndFetchCity()
        }
    }
    
    // MARK: - UI Configuration Methods
    
    private func setupView() {
        view.backgroundColor = .clear
        cityItemCollectionViewManager = CityItemCollectionViewManager()
        cityItemCollectionView.delegate = cityItemCollectionViewManager
        cityItemCollectionView.dataSource = cityItemCollectionViewManager
        
        filterCollectionViewManager = FilterCollectionViewManager()
        filterCollectionView.delegate = filterCollectionViewManager
        filterCollectionView.dataSource = filterCollectionViewManager
        
        setupConstraints()
    }
    
    private func animatePickerView(alpha: CGFloat, completion: ((Bool) -> Void)?) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.6, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
            self.pickerContainerView.alpha = alpha
            self.pickerContainerView.isHidden = alpha == 0
        }, completion: completion)
    }
    
    private func clearDataAndFetchCity() {
        loader.showCircleStroke(indicator: self.view)
        filterCollectionViewManager?.facetCategories = []
        cityItemCollectionViewManager?.cityItems = []
        title = ""
        filterCollectionViewManager?.selectedIndexPath = nil
        bannerView.isHidden = true
        filterCollectionView.reloadData()
        cityItemCollectionView.reloadData()
        viewModel.fetchCity(with: self.newSelectedCityId)
    }

    private func bindViewModel() {
        viewModel.filteredItemsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] items in
                guard let self = self else { return }
                self.cityItemCollectionViewManager?.cityItems = items
                self.configureCityCollectionViewConstraints()
                self.cityItemCollectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel.cityData
            .receive(on: DispatchQueue.main)
            .sink { [weak self] city in
                guard let self = self else { return }
                self.updateUI(with: city)
            }
            .store(in: &cancellables)
        
        loader.showCircleStroke(indicator: view)
        self.title = viewModel.city.channelInfo.title
        filterCollectionViewManager?.viewModel = self.viewModel
    }
    
    private func updateUI(with city: CityData) {
        currentDisplayedCityId = city.id
        loader.hideCircleStroke()
        filterCollectionViewManager?.facetCategories = city.facetCategories
        cityItemCollectionViewManager?.cityItems = city.items
        title = city.name
        configureBannerView(withTitle: title)
        configureView()
    }
    
    private func configureBannerView(withTitle title: String?) {
        let bannerTitle = title ?? ""
        bannerView.configureBanner(title: bannerTitle,
                                   description: "Tap here to change the address",
                                   icon: UIImage(named: "location_icon"))
    }
    
    private func configureView() {
        configureCityCollectionViewConstraints()
        filterCollectionView.reloadData()
        cityItemCollectionView.reloadData()
        bannerView.showBannerWithSlideInAnimation()
    }
    
    private func configureCityCollectionViewConstraints() {
        cityItemCollectionView.layoutIfNeeded()
        if let constraint = cityCollectionViewHeightConstraint {
            NSLayoutConstraint.deactivate([constraint])
        }
        cityCollectionViewHeightConstraint = cityItemCollectionView.heightAnchor.constraint(equalToConstant: ((UIScreen.main.bounds.width / 1.5) + 10) * CGFloat(cityItemCollectionViewManager?.cityItems.count ?? 0))
        cityCollectionViewHeightConstraint?.isActive = true
    }
    
    private func setupConstraints() {
        view.addSubview(cityScrollView)
        cityScrollView.addSubview(containerStackView)
        cityScrollView.addSubview(cityItemCollectionView)
        
        view.addSubview(pickerContainerView)
        pickerContainerView.addSubview(pickerToolbar)
        pickerContainerView.addSubview(cityPickerView)
        
        NSLayoutConstraint.activate([
            cityScrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            cityScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cityScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cityScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            containerStackView.topAnchor.constraint(equalTo: cityScrollView.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: cityScrollView.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: cityScrollView.trailingAnchor),
            containerStackView.widthAnchor.constraint(equalTo: cityScrollView.widthAnchor),
            
            bannerView.heightAnchor.constraint(equalToConstant: 80),
            filterCollectionView.heightAnchor.constraint(equalToConstant: 100),
            
            cityItemCollectionView.topAnchor.constraint(equalTo: containerStackView.bottomAnchor),
            cityItemCollectionView.bottomAnchor.constraint(equalTo: cityScrollView.bottomAnchor),
            cityItemCollectionView.widthAnchor.constraint(equalTo: cityScrollView.widthAnchor),
            
            pickerContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pickerContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            pickerContainerView.heightAnchor.constraint(equalToConstant: 250),
            pickerContainerView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width - 100),
            
            pickerToolbar.topAnchor.constraint(equalTo: pickerContainerView.topAnchor),
            pickerToolbar.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor),
            pickerToolbar.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor),
            pickerToolbar.heightAnchor.constraint(equalToConstant: 44),
            
            cityPickerView.topAnchor.constraint(equalTo: pickerToolbar.bottomAnchor),
            cityPickerView.leadingAnchor.constraint(equalTo: pickerContainerView.leadingAnchor),
            cityPickerView.trailingAnchor.constraint(equalTo: pickerContainerView.trailingAnchor),
            cityPickerView.bottomAnchor.constraint(equalTo: pickerContainerView.bottomAnchor)
        ])
    }
}

// MARK: - Picker View Delegates & Data Source

extension CityViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return viewModel.citiesAvailable.count
    }

    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return viewModel.citiesAvailable[row].channelInfo.title
    }

    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        newSelectedCityId = viewModel.citiesAvailable[row].id
    }
}
