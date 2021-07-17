//
//  ViewModel.swift
//  UnitTesting
//
//  Created by Maksim Vialykh on 7/17/21.
//

import Foundation

protocol ViewModel: AnyObject {
    var onError: ((Error) -> Void)? { get set }
    func signup(username: String?, password: String?)
}

enum SignupError: Error {
    case emptyUsername
    case emptyPassword
}

class DefaultViewModel: ViewModel {
    
    var onError: ((Error) -> Void)?
    private let client: NetworkClient
    private let router: Router
    
    init(client: NetworkClient, router: Router) {
        self.client = client
        self.router = router
    }
    
    func signup(username: String?, password: String?) {
        guard let username = username else {
            onError?(SignupError.emptyUsername)
            return
        }
        guard let password = password else {
            onError?(SignupError.emptyPassword)
            return
        }
        /*
         {
           "id": 0,
           "username": "string",
           "firstName": "string",
           "lastName": "string",
           "email": "string",
           "password": "string",
           "phone": "string",
           "userStatus": 0
         }
         
         https://petstore.swagger.io/#/user/createUser
         */
        struct User: Encodable {
            let id = 0
            var username = ""
            let firstName = ""
            let lastName = ""
            let email = ""
            var password = ""
            let phone = ""
            let userStatus = ""
            
            init(username: String, password: String) {
                self.username = username
                self.password = password
            }
        }
        var request = URLRequest(url: URL(string: "https://petstore.swagger.io/v2/user")!)
        let user = User(username: username, password: password)
        request.httpMethod = "POST"
        request.httpBody = try! JSONEncoder().encode(user)
        client.send(request: request) { result in
            switch result {
            case .success(let data):
                // serialize data
                print("response: \(String(data: data, encoding: .utf8))")
                DispatchQueue.main.async { [weak self] in
                    self?.router.openMainView()
                }
            case .failure(let error):
                DispatchQueue.main.async { [weak self] in
                    self?.onError?(error)
                }
            }
        }
    }
    
}
