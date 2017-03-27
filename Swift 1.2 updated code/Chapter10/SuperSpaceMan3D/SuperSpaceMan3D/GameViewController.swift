import UIKit
import QuartzCore
import SceneKit

class GameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        let mainScene = createMainScene()
        mainScene.rootNode.addChildNode(setupFloor())
    
        let sceneView = self.view as! SCNView
        sceneView.scene = mainScene
    
        // Optional, but nice to be turned on during developement
        sceneView.showsStatistics = true
        sceneView.allowsCameraControl = true
    }
    
    func createMainScene() -> SCNScene {
        var mainScene = SCNScene(named: "art.scnassets/hero.dae")
        return mainScene!
    }
    
    func setupFloor() -> SCNNode {
        //Flooring
        var floorNode = SCNNode()
        var floor = SCNFloor()
        floorNode.geometry = floor
        floorNode.geometry!.firstMaterial!.diffuse.contents = "Floor"
        return floorNode
    }

}
