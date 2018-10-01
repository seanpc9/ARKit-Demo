//
//  BaseSceneViewController.swift
//  ARKitPresentation
//
//  Created by Kyle Blazier on 9/30/18.
//  Copyright © 2018 Kyle Blazier. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class BaseSceneViewController: UIViewController {
    
    enum BodyType: Int {
        case bear = 1
        case bullet = 2
        case plane = 3
        case globe = 4
    }
    
    lazy var sceneView: ARSCNView = {
        // Build and setup ARScene
        let arScene = ARSCNView(frame: view.frame)
        arScene.autoenablesDefaultLighting = true
        arScene.showsStatistics = true
        arScene.delegate = self
        
        // Add a SceneKit Scene to the ARScene
        let scene = SCNScene()
        arScene.scene = scene
        arScene.debugOptions = [.showFeaturePoints, .showWorldOrigin]
        
        arScene.translatesAutoresizingMaskIntoConstraints = false
        return arScene
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupScene()
        addGestureRecognizer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    private func setupScene() {
        // Add the scene view and constrain it programmatically
        view.addSubview(sceneView)
        view.leadingAnchor.constraint(equalTo: sceneView.leadingAnchor).isActive = true
        sceneView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        view.safeAreaLayoutGuide.topAnchor.constraint(equalTo: sceneView.topAnchor).isActive = true
        sceneView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func addGestureRecognizer() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped(_:)))
        sceneView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc private func tapped(_ recognizer: UITapGestureRecognizer) {
        // Try to get the parent view of this gesture recognizer (to make sure it's our ARSCNView)
        if let sceneView = recognizer.view as? ARSCNView {
            // Convert the touch point to the sceneView
            let touch = recognizer.location(in: sceneView)
            
            // Call function that the scene was tapped so subclasses can handle this logic
            sceneTapped(at: touch)
        }
    }
    
    func sceneTapped(at touchPoint: CGPoint) {
        // Subclasses can override to add custom logic
        print("ARScene tapped at point: \(touchPoint)")
    }
}

extension BaseSceneViewController: ARSCNViewDelegate {
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        // If this anchor is a plane, add a custom plane node to display our plane UI element
        guard anchor is ARPlaneAnchor else { return }
        print("Renderer Added plane anchor node")
        
        // Create a plane of 1 square meter
        let plane = SCNPlane(width: 1.0, height: 1.0)
        
        // Create a material with an image of a grid that we have, make it the material of the plane
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "overlay_grid.png")
        material.isDoubleSided = true
        plane.firstMaterial = material
        
        // Create Scene node with the plane object and position it relative to the anchor that was added to the scene
        let planeNode = SCNNode(geometry: plane)
        let anchorTransform = anchor.transform.columns.3
        planeNode.position = SCNVector3(anchorTransform.x,
                                        anchorTransform.y,
                                        anchorTransform.z)
        planeNode.eulerAngles.x = .pi/2
        
        // Enable physics to this plane
        planeNode.physicsBody = SCNPhysicsBody(type: .static, shape: nil)
        planeNode.physicsBody?.categoryBitMask = BodyType.plane.rawValue
        
        // Add this node to the node the scene passed to us in this function
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first(where: { $0.geometry as? SCNPlane != nil }),
            let plane = planeNode.geometry as? SCNPlane
            else {
                return
        }
        
        plane.width = CGFloat(planeAnchor.extent.x)
        plane.height = CGFloat(planeAnchor.extent.z)
        
        let center = planeAnchor.center
        planeNode.position = SCNVector3(center.x, center.y, center.z)
    }
}
