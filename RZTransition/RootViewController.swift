//
//  RootViewController.swift
//  NewArc
//
//  Created by Александр Сенин on 26.06.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

public class RootViewController: UIViewController {
    var lines: [LineNew] = []
    var select: String = "Main"

    
    public static func setupRootViewController(_ installableScreenProtocol: ScreenControllerProtocol) -> RootViewController{
        return setupRootViewController(["Main": installableScreenProtocol], "Main")
    }
    
    public static func setupRootViewController(_ screenLines: [LineNew], _ select: ScreenLines) -> RootViewController{
        setupRootViewController(screenLines, select.id)
    }

    public static func setupRootViewController(_ screenLines: [LineNew], _ select: String) -> RootViewController{
        let rVC = RootViewController()
        rVC.lines = screenLines
        rVC.select = select
        return rVC
    }
    
    public static func setupRootViewController(_ screenLines: [String: ScreenControllerProtocol], _ select: String) -> RootViewController{
        var lines: [LineNew] = []
        screenLines.forEach(){
            lines.append(LineNew(id: $0.key, controller: $0.value))
        }
        return setupRootViewController(lines, select)
    }
    
    public static func setupRootViewController(_ screenLines: [ScreenLines: ScreenControllerProtocol], _ select: ScreenLines) -> RootViewController{
        var lines: [LineNew] = []
        screenLines.forEach(){
            lines.append(LineNew(id: $0.key, controller: $0.value))
        }
        return setupRootViewController(lines, select)
    }
    
    private func registring(){
        if lines.count == 0 {return}
        ScreensInstaller.rootViewController = self
        LineController.addLines(lines)
        lines = []
        let plase = UIView(frame: view.bounds)
        view.addSubview(plase)
        TransitionProcedure(.In, self).view(plase).line(select).transit()
    }
    
    func roatateCild(){
        var orientation = UIApplication.shared.windows.first?.windowScene?.interfaceOrientation ?? .portrait
        if orientation != .unknown{
            Rotater.lastOrintation = orientation
        }else{
            orientation = Rotater.lastOrintation
        }
        for child in children{
            if let child = child as? ScreenControllerProtocol{
                Rotater.resizeAllChild(parent: false,
                                       child: child,
                                       parentOrientation: orientation,
                                       orientation)
            }
        }
        
        Rotater.oldOrintation = Rotater.lastOrintation
        Rotater.rotate()
    }
    
    public override func viewDidLoad() {
        registring()
    }
    
    public override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        roatateCild()
    }
}
