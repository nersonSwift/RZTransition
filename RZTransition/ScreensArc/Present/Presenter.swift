//
//  Presenter.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

fileprivate class PresenterInterfase{
    weak var screenController: ScreenControllerProtocol?
}

public protocol PresenterNoJenericProtocol: NSObject{
    var view: UIView { get }
    func create()
    init(installableScreen: ScreenControllerProtocol)
}

extension PresenterNoJenericProtocol{
    public var view: UIView{
        screenController?.view ?? UIView()
    }
    
    public var screenController: ScreenControllerProtocol?{
        set(screenController){
            screenControllerInterfase.screenController = screenController
        }
        get{
            screenControllerInterfase.screenController
        }
    }
    
    public init(installableScreen: ScreenControllerProtocol) {
        self.init()
        screenController = installableScreen
    }
    
    private var key: UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: 16)
    }
    
    private var screenControllerInterfase: PresenterInterfase {
        if let key = key, let presenterInterfase = objc_getAssociatedObject(self, key) as? PresenterInterfase{
            return presenterInterfase
        }
        let presenterInterfase = PresenterInterfase()
        
        if let key = key{
            objc_setAssociatedObject(self, key, presenterInterfase, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        return presenterInterfase
    }
}


public protocol PresenterProtocol: PresenterNoJenericProtocol{
    associatedtype Controller: ScreenControllerProtocol
    var controller: Controller? { get }
}

extension PresenterProtocol {
    public var controller: Controller?{ screenController as? Controller }
}


public protocol ScreenModelProtocol{}

public protocol ScreenModelSeterNJ: class {
    func setModel()
}

public protocol ScreenModelSeter: ScreenModelSeterNJ {
    associatedtype ScreenModel: ScreenModelProtocol
    var screenModel: ScreenModel! {get set}
    
    func setModel()
    func setModel(_ model: ScreenModel?)
}

extension ScreenModelSeter{
    public func setModel(){
        setModel(nil)
    }
    
    public func setModel(_ model: ScreenModel?){
        if let model = model{
            screenModel = model
        }
    }
}


public typealias PresenterNMJ = NSObject & PresenterNoJenericProtocol
public typealias PresenterNJ = NSObject & PresenterNoJenericProtocol & ScreenModelSeter
public typealias PresenterNM = NSObject & PresenterProtocol
public typealias Presenter = NSObject & PresenterProtocol & ScreenModelSeter




