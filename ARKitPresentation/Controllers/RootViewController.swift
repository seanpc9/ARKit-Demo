//
//  RootViewController.swift
//  ARKitPresentation
//
//  Created by Kyle Blazier on 9/30/18.
//  Copyright © 2018 Kyle Blazier. All rights reserved.
//

import UIKit
import QuickLook

class RootViewController: UIViewController {
    
    private enum SceneType: Int {
        // Note: not 0 indexed because this will be used for a button's tag and the default
        //  value for tag is 0
        case earth = 1
        case text = 2
        case logo = 3
    }
    
    @IBOutlet var earthSceneButton: UIButton!
    @IBOutlet var textSceneButton: UIButton!
    @IBOutlet var logoSceneButton: UIButton!
    @IBOutlet weak var quickLookButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        earthSceneButton.tag = SceneType.earth.rawValue
        textSceneButton.tag = SceneType.text.rawValue
        logoSceneButton.tag = SceneType.logo.rawValue
        
        for button in [earthSceneButton, textSceneButton, logoSceneButton] {
            button?.addTarget(self, action: #selector(buttonPressed(_:)), for: .touchUpInside)
            button?.layer.cornerRadius = 20
        }
        
        quickLookButton.layer.cornerRadius = 20
        quickLookButton.addTarget(self, action: #selector(quickLookButtonPressed(_:)), for: .touchUpInside)
        
        // Disable automatic screen sleep
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    @objc func buttonPressed(_ sender: UIButton) {
        guard let selectedScene = SceneType(rawValue: sender.tag) else {
            print("Unknown Scene selected")
            return
        }
        
        let viewController: UIViewController
        switch selectedScene {
        case .earth:
            viewController = EarthViewController()
        case .text:
            viewController = TextViewController()
        case .logo:
            viewController = LogoViewController()
        }
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    @objc func quickLookButtonPressed(_ sender: UIButton) {
        let quickLookController = QLPreviewController()
        quickLookController.dataSource = self
        quickLookController.delegate = self
        present(quickLookController, animated: true)
    }
}

extension RootViewController: QLPreviewControllerDelegate, QLPreviewControllerDataSource {
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        return Bundle.main.url(forResource: "New_VT_logo", withExtension: "usdz")! as QLPreviewItem
    }
}
