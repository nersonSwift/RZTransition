//
//  Router.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import SwiftUI

public typealias Router = RowRouter & ObservableObject

protocol RouterProtocol: NSObject{
    var screenController: ScreenControllerProtocol? { get set }
    var screenType: AnyScreen.Type? { get }
    init()
}


public class RowRouter: NSObject, RouterProtocol{
    weak var screenController: ScreenControllerProtocol?
    var screenType: AnyScreen.Type? { nil }
    required override init() {super.init()}
}
