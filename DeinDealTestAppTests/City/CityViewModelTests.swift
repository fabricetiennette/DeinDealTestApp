import XCTest
import Combine
@testable import DeinDealTestApp

final class CityViewModelTests: XCTestCase {
    
    private var viewModel: CityModule.ViewModel?
    private var coordinator: MockCityViewDelegate?
    private var cityServices: MockCityServices!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUp() {
        super.setUp()
        cityServices = MockCityServices()
        let city: City = MockCitiesResponse.geneva.cities[0]
        let availableCities: [City] = [city]
        coordinator = MockCityViewDelegate()
        viewModel = CityViewModel(city: city, citiesAvailable: availableCities, cityService: cityServices, delegate: coordinator)
    }
    
    override func tearDown() {
        cancellables = []
        viewModel = nil
        cityServices = nil
        coordinator = nil
        super.tearDown()
    }
    
    func testFetchingCityData() {
        let expectation = self.expectation(description: "City data fetched")
        
        viewModel?.cityData.sink(receiveValue: { cityData in
            XCTAssertNotNil(cityData)
            XCTAssertEqual(cityData.id, "geneva")
            expectation.fulfill()
        })
        .store(in: &cancellables)
        
        viewModel?.fetchCity(with: "geneva")
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testSelectingCategory() {
        let expectation = XCTestExpectation(description: "Category items filtered")
        var receivedItems: [CityItem] = []

        viewModel?.filteredItemsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { items in
                if items != [] {
                    receivedItems = items
                    expectation.fulfill()
                }
            })
            .store(in: &cancellables)
        
        viewModel?.fetchCity(with: "geneva")

        viewModel?.didSelectCategory(with: "fd_healthy")

        wait(for: [expectation], timeout: 10)

        XCTAssertFalse(receivedItems.isEmpty, "No items received")
    }
    
    func testSelectingAllFilterCategory() {
        let expectation = XCTestExpectation(description: "All items returned when 'all' category is selected")
        
        var initialItemCount: Int?
        var receivedItems: [CityItem] = []

        let cityDataCancellable = viewModel?.cityData
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { cityData in
                initialItemCount = cityData.items.count
            })

        let filteredItemsCancellable = viewModel?.filteredItemsPublisher
            .receive(on: DispatchQueue.main)
            .prefix(3)
            .sink(receiveValue: { items in
                receivedItems = items
                expectation.fulfill()
            })
        
        viewModel?.fetchCity(with: "geneva")
        
        viewModel?.didSelectCategory(with: "fd_healthy")
        
        viewModel?.didSelectCategory(with: "all")

        wait(for: [expectation], timeout: 2.0)

        XCTAssertEqual(receivedItems.count, initialItemCount ?? 0, "Items count doesn't match the initial count after selecting the 'all' category")

        cityDataCancellable?.cancel()
        filteredItemsCancellable?.cancel()
    }
}


final class MockCityViewDelegate: CityModule.Delegate {
    func didFinish(cityController: CityControllerEvent) {}
}

struct MockCitiesResponse {
    static let geneva = CitiesResponse(
        cities: [
            City(
                id: "geneva",
                channelInfo: ChannelInfo(
                    title: "Genève",
                    images: Images(
                        small: "https://example.com/geneva_small.jpg",
                        large: "https://example.com/geneva_large.jpg"
                    )
                )
            )
        ]
    )
}
