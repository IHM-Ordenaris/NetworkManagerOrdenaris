import Testing
@testable import SwiftNetworkManager

import XCTest

final class NetworkManagerSDKTests: XCTestCase, @unchecked Sendable {
    var sut: WebService!
    var expectetion: XCTestExpectation!

    override func setUp() {
        self.sut = WebService(environment: .qa, appVersion: "3.0.0")
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
        self.sut.fetchData(target: .acceso(params: AccesoRequest(numero: "5624981330", pass: "Test.1234"))) { response, error in
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
        self.sut.fetchData(target: .validarImei(params: ImeiRequest(imei: "351073871526101"))) { response, error in
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
        self.sut.fetchData(target: .listaRecurrentes(params: RecurrenciasActivasRequest(identificador: "5660502377"))) { response, error in
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
        self.sut.fetchData(target: .ofertaeSim) { response, error in
            if case .ofertaeSim(let objc) = response {
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
        self.sut.fetchData(target: .cambiarPerfil(params: PerfilRequest(access: "AOIlioyz5TVdhisiULOrulmQBEvocJ1P", nombre: "Pruebas iOS Rules", email: "ios_example@mail.com", permiso: 1, avatar: 0))) { response, error in
            if case .datosUsuario(let objc) = response {
                print(objc)
                XCTAssertTrue(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testUserInfo() {
        self.sut.fetchData(target: .userInfo(params: UserInfoRequest(access: "1mDHodYN9AihUKaSsACVF6gm9dhuqdkc"))) { response, error in
            if case .informacionUsuario(let objc) = response {
                print(objc)
                XCTAssertTrue(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testAvataresList() {
        self.sut.fetchData(target: .avatares) { response, error in
            if case .avatares(let objc) = response {
                print(objc)
                XCTAssertTrue(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testRegisterRequestChangeSim() {
        self.sut.fetchData(target: .solicitudReemplazoSim(params: ReplaceSimRequest(dn: "5660609075", iccid: "8952140063104636850", email: "qwerty@qwerty.com", reason: .lostOrStolen))) { response, error in
            if case .solicitudReemplazoSim(let objc) = response {
                print(objc)
                XCTAssertTrue(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testOptRemplacementSimRequest() {
        self.sut.fetchData(target: .enviarOtpReemplazoSim(params: SendSimOtpRequest(dn: "5661066502"), uuid: "ed9ce7ee1e9b4e3ea8eec2040c3093bf")) { response, error in
            if case let .enviarOtpReemplazoSim(objc, headers) = response {
                print(objc)
                print(headers)
                XCTAssertTrue(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testServicesAreaCodeChange() {
        self.sut.fetchData(target: /*.validarOtpNir(params: ValidateOtpRequest(numero: "9372847584", pin: "480355"))*/ .cambiarNir(params: UpdateNirRequest(nir: "663", numero: "9372847584", uuid: "53457a21-0145-4e3d-96b8-5160d06dff36"))) { response, error in
            if case .cambiarNir(let objc) = response {
                print(objc)
                XCTAssertTrue(objc?.success ?? false)
                self.expectetion.fulfill()
            }
        }
        self.wait(for: [self.expectetion], timeout: 5)
    }
    
    func testServiceAdvertising() {
        self.sut.fetchData(target: .advertising){ response, error in
            if case .advertising(let objc) = response {
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
