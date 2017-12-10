//
//  ViewController.swift
//  ramp-up
//
//  Created by Mac on 12/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class RampPlacerVC: UIViewController, ARSCNViewDelegate, UIPopoverPresentationControllerDelegate {

    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var controls: UIStackView!
    @IBOutlet weak var rotateButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    
    var selectedRampName: String?
    var selectedRamp: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/main.scn")!
        sceneView.autoenablesDefaultLighting = true
        
        // Set the scene to the view
        sceneView.scene = scene
        
        let gesture1 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        let gesture2 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        let gesture3 = UILongPressGestureRecognizer(target: self, action: #selector(onLongPress(gesture:)))
        gesture1.minimumPressDuration = 0.1
        gesture2.minimumPressDuration = 0.1
        gesture3.minimumPressDuration = 0.1
        rotateButton.addGestureRecognizer(gesture1)
        upButton.addGestureRecognizer(gesture2)
        downButton.addGestureRecognizer(gesture3)
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [.featurePoint])
        guard let hitFeature = results.last else { return }
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        placeRamp(position: hitPosition)
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    @IBAction func rampButtonPressed(_ sender: UIButton) {
        let rampPickerVC = RampPickerVC(size: CGSize(width: 250, height: 500))
        rampPickerVC.rampPlacerVC = self
        rampPickerVC.modalPresentationStyle = .popover
        rampPickerVC.popoverPresentationController?.delegate = self
        present(rampPickerVC, animated: true, completion: nil)
        rampPickerVC.popoverPresentationController?.sourceView = sender
        rampPickerVC.popoverPresentationController?.sourceRect = sender.bounds
    }
    
    func rampSelected(_ rampName: String) {
        selectedRampName = rampName
    }
    
    func placeRamp(position: SCNVector3) {
        if let rampName = selectedRampName {
            controls.isHidden = false
            let ramp = Ramp.getRampForName(rampName)
            selectedRamp = ramp
            ramp.position = position
            ramp.scale = SCNVector3Make(0.01, 0.01, 0.01)
            sceneView.scene.rootNode.addChildNode(ramp)
        }
    }
    
    @IBAction func removeButtonPressed(_ sender: Any) {
        if let ramp = selectedRamp {
            ramp.removeFromParentNode()
            selectedRampName = nil
            selectedRamp = nil
        }
    }
    
    @objc func onLongPress(gesture: UILongPressGestureRecognizer) {
        if let ramp = selectedRamp {
            if gesture.state == .ended {
                ramp.removeAllActions()
            } else if gesture.state == .began {
                if gesture.view === rotateButton {
                    let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.08*Double.pi), z: 0, duration: 0.1))
                    ramp.runAction(rotate)
                } else if gesture.view === upButton {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: 0.08, z: 0, duration: 0.1))
                    ramp.runAction(move)
                } else if gesture.view === downButton {
                    let move = SCNAction.repeatForever(SCNAction.moveBy(x: 0, y: -0.08, z: 0, duration: 0.1))
                    ramp.runAction(move)
                }
            }
        }
    }
}
