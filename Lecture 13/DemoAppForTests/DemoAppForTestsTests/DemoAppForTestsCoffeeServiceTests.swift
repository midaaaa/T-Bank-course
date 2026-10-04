//
//  DemoAppForTestsTests.swift
//  DemoAppForTestsTests
//
//  Created by Dmitriy Toropkin on 05.05.2025.
//

import XCTest
@testable import DemoAppForTests

final class DemoAppForTestsTests: XCTestCase {

    var coffeeService: CoffeeService!
        
    override func setUp() {
        super.setUp()
        coffeeService = CoffeeService()
    }
    
    override func tearDown() {
        coffeeService = nil
        super.tearDown()
    }
    
    // MARK: - Fetch Coffees
    
    func testFetchCoffees_ReturnsAvailableCoffees() async {
        do {
            let coffees = try await coffeeService.fetchCoffees()
            XCTAssertFalse(coffees.isEmpty, "Список кофе не должен быть пустым")
            XCTAssertEqual(coffees.count, 5, "Должно быть 5 видов кофе")
        } catch {
            XCTFail("Ошибка при получении кофе: \(error)")
        }
    }
    
    // MARK: - Place Order
    
    func testPlaceOrder_ValidOrder_ReturnsOrder() async {
        do {
            let order = try await coffeeService.placeOrder(
                coffeeId: 1,
                quantity: 2,
                customerName: "Test User"
            )
            
            XCTAssertEqual(order.coffeeId, 1, "ID кофе должен быть 1")
            XCTAssertEqual(order.quantity, 2, "Количество должно быть 2")
            XCTAssertEqual(order.customerName, "Test User", "Имя клиента должно совпадать")
            XCTAssertEqual(order.status, .pending, "Статус должен быть 'pending'")
        } catch {
            XCTFail("Неожиданная ошибка: \(error)")
        }
    }
    
    func testPlaceOrder_InvalidQuantity_ThrowsError() async {
        do {
            _ = try await coffeeService.placeOrder(
                coffeeId: 1,
                quantity: 0,
                customerName: "Test User"
            )
            XCTFail("Должна быть ошибка при нулевом количестве")
        } catch {
            
        }
    }
    
    // MARK: - Get Order Status
    
    func testGetOrderStatus_ValidOrder_ReturnsOrder() async {
        do {
            let newOrder = try await coffeeService.placeOrder(
                coffeeId: 1,
                quantity: 1,
                customerName: "Test User"
            )
            
            let fetchedOrder = try await coffeeService.getOrderStatus(orderId: newOrder.id)
            XCTAssertEqual(fetchedOrder.id, newOrder.id, "ID заказа должен совпадать")
        } catch {
            XCTFail("Неожиданная ошибка: \(error)")
        }
    }
    
    func testGetOrderStatus_InvalidOrderId_ThrowsError() async {
        do {
            _ = try await coffeeService.getOrderStatus(orderId: 9999)
            XCTFail("Должна быть ошибка при неверном ID")
        } catch CoffeeError.invalidOrderId {
            
        } catch {
            XCTFail("Неверный тип ошибки: \(error)")
        }
    }
    
    // MARK: - Cancel Order
    
    func testCancelOrder_ValidOrder_ReturnsTrue() async {
        do {
            let newOrder = try await coffeeService.placeOrder(
                coffeeId: 1,
                quantity: 1,
                customerName: "Test User"
            )
            
            let isCancelled = try await coffeeService.cancelOrder(orderId: newOrder.id)
            XCTAssertTrue(isCancelled, "Заказ должен быть отменён")
            
            let cancelledOrder = try await coffeeService.getOrderStatus(orderId: newOrder.id)
            XCTAssertEqual(cancelledOrder.status, .cancelled, "Статус должен быть 'cancelled'")
        } catch {
            XCTFail("Неожиданная ошибка: \(error)")
        }
    }
    
    func testCancelOrder_AlreadyCancelled_ThrowsError() async {
        do {
            let newOrder = try await coffeeService.placeOrder(
                coffeeId: 1,
                quantity: 1,
                customerName: "Test User"
            )
            
            _ = try await coffeeService.cancelOrder(orderId: newOrder.id)
            _ = try await coffeeService.cancelOrder(orderId: newOrder.id)
            XCTFail("Должна быть ошибка при повторной отмене")
        } catch CoffeeError.orderAlreadyCancelled {
           
        } catch {
            XCTFail("Неверный тип ошибки: \(error)")
        }
    }
}
