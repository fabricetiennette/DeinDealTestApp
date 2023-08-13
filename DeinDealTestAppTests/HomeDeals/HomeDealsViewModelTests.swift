import XCTest
import Combine
@testable import DeinDealTestApp

final class HomeDealsViewModelTests: XCTestCase {
    
    private var viewModel: HomeDealsModule.ViewModel?
    private var coordinator: MockHeHomeDealsCoordinator?
    private var cityServices: MockCityServices!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        cityServices = MockCityServices()
        coordinator = MockHeHomeDealsCoordinator()
        viewModel = HomeDealsViewModel(cityService: cityServices, delegate: coordinator)
    }
    
    override func tearDown() {
        cancellables = []
        super.tearDown()
    }
    
    func testFetchCitiesSuccess() async  {
        let image = Images(small: "smallURL", large: "largeURL")
        let channelInfo = ChannelInfo(title: "ChannelTitle", images: image)
        let city = City(id: "1", channelInfo: channelInfo)
        
        cityServices.citiesResponse = CitiesResponse(cities: [city])
        
        let expectation = expectation(description: "Waiting for cities to publish")
        
        viewModel?.cities
            .sink { cities in
                XCTAssertEqual(cities.count, 1)
                XCTAssertEqual(cities[0].id, "1")
                XCTAssertEqual(cities[0].channelInfo.title, "ChannelTitle")
                XCTAssertEqual(cities[0].channelInfo.images.small, "smallURL")
                XCTAssertEqual(cities[0].channelInfo.images.large, "largeURL")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel?.fetchCities()
        
        await fulfillment(of: [expectation], timeout: 5)
    }
    
    func testCityTapped() async {
        
        let image = Images(small: "smallURL", large: "largeURL")
        let channelInfo = ChannelInfo(title: "ChannelTitle", images: image)
        let city = City(id: "1", channelInfo: channelInfo)
        let cities = [city]
        
        let expectation = XCTestExpectation(description: "Delegate method called")
        
        coordinator?.callback = {
            expectation.fulfill()
        }
        
        self.viewModel?.didTappedCity(with: city, cities: cities)
        
        await fulfillment(of: [expectation], timeout: 2)
        
        XCTAssertEqual(coordinator?.tappedCity?.id, "1")
        XCTAssertEqual(coordinator?.cityList, cities)
        expectation.fulfill()
    }
    
}

final class MockHeHomeDealsCoordinator: HomeDealsModule.Delegate {
    var tappedCity: City?
    var cityList: [City]?
    var callback: (() -> Void)?
    
    func didFinish(homeDealsController: HomeDealsControllerEvent) {
        switch homeDealsController {
        case .homeDealsViewModel(let event):
            switch event {
            case .city(let city, let cities):
                tappedCity = city
                cityList = cities
                callback?()
            }
        }
    }
}
