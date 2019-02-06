//
//  TextViewController.swift
//  ARKitPresentation
//
//  Created by Kyle Blazier on 9/30/18.
//  Copyright © 2018 Kyle Blazier. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class TextViewController: BaseSceneViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func sceneTapped(at touchPoint: CGPoint) {
        if let hitTestResult = sceneView.hitTest(touchPoint, types: .existingPlane).first {
            addTextToScene(with: hitTestResult)
        }
    }
    
    private func addTextToScene(with hitTestResult: ARHitTestResult) {
        // Create the text object to add to the scene and make it colored maroon (GO HOKIES!!!)
        let textGeometry = SCNText(string: "Hello VT!", extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor(red: 99 / 255.0, green: 0, blue: 49 / 255.0, alpha: 1.0)
        
        // Create a Scene node with this text object and set it's position relative to our hit test result
        let textNode = SCNNode(geometry: textGeometry)
        let worldTransformPoint = hitTestResult.worldTransform.columns.3
        textNode.position = SCNVector3(worldTransformPoint.x,
                                       worldTransformPoint.y,
                                       worldTransformPoint.z)
        
        // Scale the node
        textNode.scale = SCNVector3(0.02, 0.02, 0.02)
        sceneView.scene.rootNode.addChildNode(textNode)
    }
}
