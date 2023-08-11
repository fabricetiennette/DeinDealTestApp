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
        viewModel = HomeDealsViewModel(cityService: cityServices, delegate: coordinator)
    }
    
    override func tearDown() {
        cancellables = []
        super.tearDown()
    }
    
    func testFetchCitiesSuccess() async throws {
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
        
        try await fulfillment(of: [expectation], timeout: 5)
    }

}


final class MockHeHomeDealsCoordinator: HomeDealsModule.Delegate {
    func didFinish(homeDealsController: HomeDealsControllerEvent) {
        switch homeDealsController {
        case .homeDealsViewModel(let event):
            switch event {
                default: break
            }
        }
    }
}


final class MockCityServices: CityServicesDelegate {
    var shouldReturnError: Bool = false
    var citiesResponse: CitiesResponse!
    
    func fetchCitiesFromAPI() async throws -> CitiesResponse {
        if shouldReturnError {
            throw CityServices.NetworkError.failedToFetchData
        }
        return citiesResponse
    }
}
