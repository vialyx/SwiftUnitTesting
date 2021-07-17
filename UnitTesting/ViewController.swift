//
//  ViewController.swift
//  UnitTesting
//
//  Created by Maksim Vialykh on 7/17/21.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var username: NSTextField!
    @IBOutlet weak var password: NSTextField!
    @IBOutlet weak var error: NSTextField!
    
    let viewModel: ViewModel = DefaultViewModel(
        client: DefaultNetworkClient(),
        router: DefaultRouter()
    )

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.onError = { [weak self] error in
            self?.error.stringValue = error.localizedDescription
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func signup(_ sender: Any) {
        viewModel.signup(
            username: username.stringValue,
            password: password.stringValue
        )
    }
    
}

