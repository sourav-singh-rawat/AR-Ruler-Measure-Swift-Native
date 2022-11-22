//
//  ViewController.swift
//  ARMeasure
//
//  Created by Sourav Singh Rawat on 22/11/22.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    //MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        sceneView.debugOptions = [.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    //MARK: - ARSCNViewDelegate methods
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else {return}
        
        let touchLocation = touch.location(in: sceneView)
        
        let result = sceneView.raycastQuery(from: touchLocation, allowing: .existingPlaneInfinite, alignment: .horizontal)
        
        guard let hitLocation = result else {return}
        
        createDot(hitLocation.direction.x, hitLocation.direction.y, hitLocation.direction.z)
    }
    
    //MARK: - Dot Methods
    
    func createDot(_ x:Float,_ y:Float,_ z:Float){
        let sphare = SCNSphere(radius: 0.01)
        
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        
        sphare.materials = [material]
        
        let node = SCNNode()
        node.position = SCNVector3(x, y, z)
        node.geometry = sphare
        
        sceneView.scene.rootNode.addChildNode(node)
    }
}
