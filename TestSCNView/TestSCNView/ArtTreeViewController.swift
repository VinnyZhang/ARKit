//
//  ArtTreeViewController.swift
//  TestSCNView
//
//  Created by Zhang xiaosong on 2018/4/10.
//  Copyright © 2018年 Zhang xiaosong. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

/// 向墙上添加 壁画
class ArtTreeViewController: UIViewController,ARSCNViewDelegate {
    

    //必备 控件
    let arSCNView = ARSCNView()
    let arSession = ARSession()
    let arConfiguration = ARWorldTrackingConfiguration()
    
    var arIndex = 0
    
    //图
    let artPicNode = SCNNode()
    //光晕
    let artPicHaloNode = SCNNode()
    
    
    // MARK: - life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        arSCNView.frame = self.view.frame
        arSCNView.session = arSession
        arSCNView.automaticallyUpdatesLighting = true //自动调节亮度
        
        self.view.addSubview(arSCNView)
        arSCNView.delegate = self
        
        self.initNode()
//        self.addLight()
        for i in 0..<6 {
            self.addBtns(index: i)
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        arConfiguration.isLightEstimationEnabled = true //自适应灯光 （室内到室外的话画面会比较柔和）
        arSession.run(arConfiguration, options: [.removeExistingAnchors,.resetTracking])
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        arSession.pause()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    //MARK: - internal methods
    
    //MARK: 初始化节点信息
    func initNode(){
        //1.设置几何
//        artPicNode.geometry = SCNSphere(radius: 3)//球形
        //图片
        var boxW: CGFloat = 6
        var boxH:CGFloat = 6
        let boxL:CGFloat = 0.1
        if self.arIndex == 0 {
            boxH = 9
        }
        else if self.arIndex == 1 {
            boxH = 5
        }
        else if self.arIndex == 2 {
            boxW = 10
        }
        
        artPicNode.geometry = SCNBox.init(width: boxW, height: boxH, length: boxL, chamferRadius: 0.0)//方形
        
        let imageA = ["jingjing.JPG","timg2kuang.jpg","timg3Kuang.jpg"]
        artPicNode.geometry?.firstMaterial?.diffuse.contents = imageA[self.arIndex]
        artPicNode.geometry?.firstMaterial?.multiply.intensity = 0.5//强度
        artPicNode.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        artPicNode.position = SCNVector3(0,0,-25)
        arSCNView.scene.rootNode.addChildNode(artPicNode)
    }
    
    //MARK: 添加光晕
    func addLight()
    {
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light?.color = UIColor.red //被光照到的地方的颜色
        
        artPicNode.addChildNode(lightNode)
        lightNode.light?.attenuationEndDistance = 20.0 //光照的亮度随着距离改变
        
        lightNode.light?.attenuationStartDistance = 1.0
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 1
        lightNode.light?.color = UIColor.white
        lightNode.opacity = 0.5
        SCNTransaction.commit()
        
        artPicHaloNode.geometry = SCNPlane.init(width: 25,height: 25)
        artPicHaloNode.rotation = SCNVector4Make(1, 0, 0, Float(0 * Double.pi/180))
        artPicHaloNode.geometry?.firstMaterial?.diffuse.contents = "sun-halo.png"
        artPicHaloNode.geometry?.firstMaterial?.lightingModel = SCNMaterial.LightingModel.constant
        artPicHaloNode.geometry?.firstMaterial?.writesToDepthBuffer = false //不要有厚度 ，看起来薄薄的一层
        artPicHaloNode.opacity = 5
        artPicNode.addChildNode(artPicHaloNode)
        
    }
    
    //MARK: 添加按钮
    func addBtns(index: NSInteger){
        let colorA = [UIColor.red,UIColor.green,UIColor.blue,UIColor.orange,UIColor.purple,UIColor.red,UIColor.purple]
        let titleA = ["左","上","下","右","前","后","添加"]
        let btnW = self.view.frame.size.width/6.0
        let btnH = 50.0
        var org_x = 0.0
        var org_y = self.view.frame.size.height - 50.0
        if index == 0 {// 左
            org_x = Double(btnW * 1.5)
            org_y = self.view.frame.size.height - 100
        }
        else if index == 1 {//上
            org_x = Double(btnW * 2.5)
            org_y = self.view.frame.size.height - 150
        }
        else if index == 2 {//下
            org_x = Double(btnW * 2.5)
            org_y = self.view.frame.size.height - 50
        }
        else if index == 3 {//右
            org_x = Double(btnW * 3.5)
            org_y = self.view.frame.size.height - 100
        }
        else if (index == 4) {//前
            org_x = 15;
            org_y = self.view.frame.size.height - 100;
        }
        else if (index == 5) {//后
            org_x = Double(self.view.frame.size.width - btnW - 15.0);
            org_y = self.view.frame.size.height - 100;
        }
        else if (index == 6) {//add
            org_x = Double(btnW * 2.5);
            org_y = self.view.frame.size.height - 100;
        }
        
        let button:UIButton = UIButton(type: .contactAdd)
        button.frame = CGRect(x: CGFloat(org_x),y: CGFloat(org_y), width: CGFloat(btnW), height:CGFloat(btnH))
        button.setTitle(titleA[index], for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(tapped(_:)), for: .touchUpInside)
        button.tag = index
        button.backgroundColor = colorA[index]
        self.view.addSubview(button)
        
    }
    //MARK: 点击事件
    @objc func tapped(_ button:UIButton) {
        var vector = SCNVector3.init()
        vector = artPicNode.position
        let dat: Float = 2
        
        if button.tag == 0 {
            vector.x = vector.x - dat
        }
        else if button.tag == 1 {
            vector.y += dat
        }
        else if button.tag == 2 {
            vector.y -= dat
        }
        else if button.tag == 3 {
            vector.x += dat
        }
        else if button.tag == 4 {
            vector.z -= dat
        }
        else if button.tag == 5 {
            vector.z += dat
        }
        artPicNode.position = vector
        
    }

}
