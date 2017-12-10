//
//  Ramp.swift
//  ramp-up
//
//  Created by Mac on 12/10/17.
//  Copyright © 2017 Mac. All rights reserved.
//

import Foundation
import SceneKit

class Ramp {
    class func getRampForName(_ rampName: String) -> SCNNode {
        switch  rampName {
        case "pipe":
            return getPipe()
        case "pyramid":
            return getPyramid()
        case "quarter":
            return getQuarter()
        default:
            return getPipe()
        }
    }
    
    class func getPipe() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/pipe.dae")
        let node = obj?.rootNode.childNode(withName: "pipe", recursively: true)!
        node?.scale = SCNVector3Make(0.0028, 0.0028, 0.0028)
        node?.position = SCNVector3Make(-1, 0.7, -1)
        return node!
    }
    
    class func getPyramid() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/pyramid.dae")
        let node = obj?.rootNode.childNode(withName: "pyramid", recursively: true)!
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        node?.position = SCNVector3Make(-1, -0.45, -1)
        return node!
    }
    
    class func getQuarter() -> SCNNode {
        let obj = SCNScene(named: "art.scnassets/quarter.dae")
        let node = obj?.rootNode.childNode(withName: "quarter", recursively: true)!
        node?.scale = SCNVector3Make(0.0058, 0.0058, 0.0058)
        node?.position = SCNVector3Make(-1, -2.2, -1)
        return node!
    }
    
    class func startRotating(node: SCNNode) {
        let rotate = SCNAction.repeatForever(SCNAction.rotateBy(x: 0, y: CGFloat(0.01*Double.pi), z: 0, duration: 0.1))
        node.runAction(rotate)
    }
}
