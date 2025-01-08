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
        self.sut = WebService(environment: .qa, appVersion: "2.0.11")
        self.expectetion = self.expectation(description: "Signup Web Service Response Expectetion")
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
    
    func testLogin() {
        self.sut.fetchData(target: .acceso(params: AccesoRequest(numero: "5646671491", pass: "Qwerty1*"))) { response, error in
            if case .datosUsuario(let obc) = response {
                print(obc)
                XCTAssertTrue(obc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testValidateBait() {
        self.sut.fetchData(target: .validarBait(numero: "5646671491", accion: .login)) { response, error in
            if case .validarBait(let obc) = response {
                print(obc)
                XCTAssertEqual(obc?.status, 0)
                self.expectetion.fulfill()
            }
        }
        
        self.wait(for: [self.expectetion], timeout: 10)
    }
    
    func testSendOTP() {
        self.sut.fetchData(target: .solicitudOtp(params: OTPRequest(numero: "8143853049", operacion: .otpRegister)), printResponse: true) { response, error in
            if case .solicitudOtp(let obc) = response{
                print(obc)
                XCTAssertTrue(obc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testImei() {
        self.sut.fetchData(target: .validarImei(params: ImeiRequest(imei: "35465091643806"))) { response, error in
            if case .validarImei(let objc) = response {
                print(objc)
                XCTAssertEqual(objc?.data?.homologated, "HOMOLOGADOS O VOLTE")
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
        self.sut.fetchData(target: .validarBait(numero: "8952020018171683669", accion: .portability)) { response, error in
            if case .validarBait(let objc) = response {
                print(objc)
                print(objc?.success)
                XCTAssertFalse(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testFetchRecurrencyReload() {
        self.sut.fetchData(target: .listaRecurrentes(params: RecurrenciasActivasRequest(identificador: "5655889516"))) { response, error in
            if case .listaRecurrentes(let objc) = response {
                print(objc)
                print(objc?.lista?.count)
                XCTAssertTrue(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testFetchSupplies() {
        self.sut.fetchData(target: .asociados) { response, error in
            if case .ofertas(let objc) = response {
                print(objc)
                print(objc?.lista?.count)
                XCTAssertTrue(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testConsumo() {
        self.sut.fetchData(target: .consumo(params: MobileHotspotRequest(access: "ASI/w3T974yE9L+OSkWQTrtWZTdAyLJN"))) { response, error in
            if case .consumo(let objc) = response {
                let inter = objc?.consumo?.first{
                    $0.nombre == "datosUsoInternacional"
                }
                print(inter)
                let mb = Double(inter!.mb_totales!) / 1024
                let divisor = pow(10.0, Double(2))
                let x = (mb * divisor).rounded()
                print(x / divisor)
                XCTAssertTrue(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testUpdateDataProfile() {
        self.sut.fetchData(target: .cambiarPerfil(params: PerfilRequest(access: "AOIlioyz5TVdhisiULOrulmQBEvocJ1P", nombre: "Pruebas iOS Rules", email: "ios_example@mail.com", permiso: 1, foto: ""))) { response, error in
            if case .datosUsuario(let objc) = response {
                print(objc)
                XCTAssertTrue(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testRegisterRequestChangeSim() {
        self.sut.fetchData(target: .solicitudReemplazoSim(params: ReplaceSimRequest(dn: "5646671491", iccid: "8952140063007187175", email: "qwerty@qwerty.com", reason: .lostOrStolen))) { response, error in
            if case .solicitudReemplazoSim(let objc) = response {
                print(objc)
                XCTAssertTrue(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testServicesAreaCodeChange() {
        self.sut.fetchData(target: .listaCodigoArea) { response, error in
            if case .listaCodigoArea(let objc) = response {
                print(objc)
                XCTAssertTrue(objc?.success ?? false)
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
