//
//  NetworkManagerSDKTests.swift
//  NetworkManagerSDKTests
//
//  Created by Desarrollador iOS on 25/06/24.
//

import XCTest
@testable import NetworkManagerSDK

final class NetworkManagerSDKTests: XCTestCase {
    var sut: WebService!
    var expectetion: XCTestExpectation!

    override func setUp() {
        self.sut = WebService(environment: .qa, appVersion: "2.0.10")
        self.expectetion = self.expectation(description: "Signup Web Service Response Expectetion")
    }
    
    func testValidateBait() {
        self.sut.fetchData(target: .validarBait(numero: "7713733729", accion: .login)) { response, error in
            if case .validarBait(let obc) = response {
                print(obc)
                XCTAssertEqual(obc?.status, 0)
                self.expectetion.fulfill()
            }
        }
        
        self.wait(for: [self.expectetion], timeout: 5)
    }

    func testLoadConfig() {
        self.sut.loadConfiguration { response, error in
            if let resp = response{
                XCTAssertTrue(resp)
                self.expectetion.fulfill()
            }
        }
        
        self.wait(for: [self.expectetion], timeout: 2)
    }
    
    func testImei() {
        self.sut.fetchData(target: .validar(imei: "351073871526101")) { response, error in
            if case .validarImei(let objc) = response {
                XCTAssertEqual(objc?.imei?.homologated, "HOMOLOGADOS O VOLTE")
                self.expectetion.fulfill()
            }
        }
        
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testPinBlocked(){
        self.sut.fetchData(target: .solicitudOtp(params: OTPRequest(numero: "5655867467", operacion: .otpRegister))) { response, error in
            if case .solicitudOtp(let objc) = response {
                print(objc?.fechaDesbloqueo)
                print(objc?.success)
                XCTAssertFalse(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testFetchNumber() {
        self.sut.fetchData(target: .validarBait(numero: "8952140062592895663", accion: .portability)) { response, error in
            if case .validarBait(let objc) = response {
                print(objc)
                print(objc?.success)
                XCTAssertFalse(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    override func tearDown() {
        self.sut = nil
        self.expectetion = nil
    }
}
