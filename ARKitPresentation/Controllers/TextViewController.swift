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
        let textGeometry = SCNText(string: "Hello RIT!", extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.orange
        
        let textNode = SCNNode(geometry: textGeometry)
        let worldTransformPoint = hitTestResult.worldTransform.columns.3
        textNode.position = SCNVector3(worldTransformPoint.x,
                                       worldTransformPoint.y,
                                       worldTransformPoint.z)
        textNode.scale = SCNVector3(0.02, 0.02, 0.02)
        sceneView.scene.rootNode.addChildNode(textNode)
    }
}
