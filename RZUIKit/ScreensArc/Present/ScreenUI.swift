//
//  ScreenUI.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI

public protocol AnyScreen{
    func testSelf(rowRouter: RowRouter) -> AnyView?
    init()
}
extension AnyScreen{
    func testSelf(rowRouter: RowRouter) -> AnyView?{
        return nil
    }
}
extension AnyScreen where Self: ScreenUI{
    func testSelf(rowRouter: RowRouter) -> AnyView?{
        let ro = rowRouter as! R
        return AnyView(self.environmentObject(ro))
    }
}

public protocol ScreenUI: View, AnyScreen{
    associatedtype R: Router
    var router: R { get }
    var screenController: ScreenControllerProtocol? { get }
    init()
}

extension ScreenUI{
    var screenController: ScreenControllerProtocol? { router.screenController }
}
