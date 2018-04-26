//
//  DetectionPlaneViewController.swift
//  TestSCNView
//
//  Created by Zhang xiaosong on 2018/4/10.
//  Copyright © 2018年 Zhang xiaosong. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

/// 平面检测与视觉效果
class DetectionPlaneViewController: UIViewController , ARSCNViewDelegate {
    
    var sceneView = ARSCNView()
    var configuration: ARConfiguration?
    
    var planes = [UUID:Plane]() // 字典，存储场景中当前渲染的所有平面
    
    //MARK: -  life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupScene()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    // MARK: - ARSCNViewDelegate
    
    /**
     实现此方法来为给定 anchor 提供自定义 node。
     
     @discussion 此 node 会被自动添加到 scene graph 中。
     如果没有实现此方法，则会自动创建 node。
     如果返回 nil，则会忽略此 anchor。
     @param renderer 将会用于渲染 scene 的 renderer。
     @param anchor 新添加的 anchor。
     @return 将会映射到 anchor 的 node 或 nil。
     */
        func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
            guard let anchor = anchor as? ARPlaneAnchor else {
                return nil
            }
            
            // 检测到新平面时创建 SceneKit 平面以实现 3D 视觉化
            
            let plane = Plane(withAnchor: anchor)
            planes[anchor.identifier] = plane
            
            return plane
            
        }
    
    
    /**
     将新 node 映射到给定 anchor 时调用。
     
     @param renderer 将会用于渲染 scene 的 renderer。
     @param node 映射到 anchor 的 node。
     @param anchor 新添加的 anchor。
     */
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        
        
    }
    
    /**
     使用给定 anchor 的数据更新 node 时调用。
     
     @param renderer 将会用于渲染 scene 的 renderer。
     @param node 更新后的 node。
     @param anchor 更新后的 anchor。
     */
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        
        // 查看此平面当前是否正在渲染
        guard let plane = planes[anchor.identifier] else {
            return
        }
//        guard let anchor = anchor as? ARPlaneAnchor else {
//            return
//        }
//        guard let node = node as? Plane else {
//            return
//        }

        // anchor 更新后也需要更新 3D 几何体。例如平面检测的高度和宽度可能会改变，所以需要更新 SceneKit 几何体以匹配
        plane.update(anchor: anchor as! ARPlaneAnchor)
    }
    
    /**
     从 scene graph 中移除与给定 anchor 映射的 node 时调用。
     
     @param renderer 将会用于渲染 scene 的 renderer。
     @param node 被移除的 node。
     @param anchor 被移除的 anchor。
     */
    func renderer(_ renderer: SCNSceneRenderer, didRemove node: SCNNode, for anchor: ARAnchor) {
        // 如果多个独立平面被发现共属某个大平面，此时会合并它们，并移除这些 node
        planes.removeValue(forKey: anchor.identifier)
    }
    
    /**
     将要用给定 anchor 的数据来更新时 node 调用。
     
     @param renderer 将会用于渲染 scene 的 renderer。
     @param node 即将更新的 node。
     @param anchor 被更新的 anchor。
     */
    func renderer(_ renderer: SCNSceneRenderer, willUpdate node: SCNNode, for anchor: ARAnchor) {
        
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        
    }
    
    
    //MARK: - internal methodds
    
    func setupScene() {
        
        sceneView.frame = self.view.frame
        self.view.addSubview(sceneView)
        // 显示统计数据（statistics）如 fps 和 时长信息
        sceneView.showsStatistics = false
        sceneView.autoenablesDefaultLighting = true
        
        // 开启 debug 选项以查看世界原点并渲染所有 ARKit 正在追踪的特征点
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        // 设置 ARSCNViewDelegate——此协议会提供回调来处理新创建的几何体
        sceneView.delegate = self
        
    }
    
    func setupSession()
    {
        if ARWorldTrackingConfiguration.isSupported {
            let worldTracking = ARWorldTrackingConfiguration()
            worldTracking.planeDetection = .horizontal
            worldTracking.isLightEstimationEnabled = true
            self.configuration = worldTracking
        }
        else{
            let orientationTracking = AROrientationTrackingConfiguration()
            self.configuration = orientationTracking
        }
    
        // 运行 view 的 session
        sceneView.session.run(self.configuration!)
        
        
    }
    

}
