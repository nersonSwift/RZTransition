//
//  ScreenController.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

//MARK: - ScreenControllerProtocol
/// `ru`: - протокол который используется для создания и переходов контроллеров
public protocol ScreenControllerProtocol: UIViewController{
    
    //MARK: - propertes
    //MARK: - starting
    /// `ru`: - данное свойство устанавливается на `true` когда контроллер был установлен
    var starting: Bool { get set }
    
    //MARK: - inAnim
    /// `ru`: - данное свойство устанавливается на `true` когда контроллер находится в анимации
    var inAnim: Bool { get set }
    
    //MARK: - screenLine
    /// `ru`: - данное свойство отображает идетификатор линии в которой находится
    var screenLine: String? { get set }
    
    //MARK: - isHorizontal
    /// `ru`: - данное свойство отображает ориентацию контроллера
    var isHorizontal: Bool { get set }
    
    //MARK: - rotater
    /// `ru`: - класс отвечающий за орентацию котроллера в представлении
    var rotater: Rotater? { get set }
    
    //MARK: - pastScreen
     /// `ru`: - контроллер который архивируется для обратного перехода
    var pastScreen: ScreenControllerProtocol? { get set }
    
    
    //MARK: - funcs
    //MARK: - start
    /// `ru`: - метод который вызывается при первой устрановке экрана на представление
    func start()
    
    //MARK: - open
    /// `ru`: - метод который вызывается при каждой установке экрана на представление
    func open()
    
    //MARK: - close
    /// `ru`: - метод который вызывается при каждом закрытии экрана
    func close()
    
    //MARK: - completedOpen
    /// `ru`: -  метод который вызывается при каждой установке экрана на представление после анимации
    func completedOpen()
    
    //MARK: - completedClose
    /// `ru`: - метод который вызывается при каждом закрытии экрана после анимации
    func completedClose()
    
    //MARK: - rotate
    /// `ru`: - метод который вызывается при изменении ориентации
    func rotate()
}

class ScreenControllerInterfase{
    var rotater: Rotater?
    var isHorizontal: Bool = false
    
    var starting: Bool = false
    var inAnim = false
    var screenLine: String?
    var pastScreen: ScreenControllerProtocol?
}

extension ScreenControllerProtocol{
    func start(){}
    func open(){}
    func close(){}
    func completedOpen(){}
    func completedClose(){}
    func rotate(){}
    
    private var key: UnsafeRawPointer? {
        return UnsafeRawPointer(bitPattern: 16)
    }
    
    private var screenControllerInterfase: ScreenControllerInterfase {
        if let key = key, let screenControllerInterfase = objc_getAssociatedObject(self, key) as? ScreenControllerInterfase{
            return screenControllerInterfase
        }
        let screenControllerInterfase = ScreenControllerInterfase()
        
        if let key = key{
            objc_setAssociatedObject(self, key, screenControllerInterfase, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
        }
        return screenControllerInterfase
    }
        
    var rotater: Rotater? {
        set(rotater){
            screenControllerInterfase.rotater = rotater
        }
        get{
            screenControllerInterfase.rotater
        }
    }
    var isHorizontal: Bool {
        set(isHorizontal){
            screenControllerInterfase.isHorizontal = isHorizontal
        }
        get{
            screenControllerInterfase.isHorizontal
        }
    }
    var starting: Bool {
        set(starting){
            screenControllerInterfase.starting = starting
        }
        get{
            screenControllerInterfase.starting
        }
    }
    var inAnim: Bool {
        set(inAnim){
            screenControllerInterfase.inAnim = inAnim
        }
        get{
            screenControllerInterfase.inAnim
        }
    }
    var screenLine: String? {
        set(screenLine){
            screenControllerInterfase.screenLine = screenLine
        }
        get{
            screenControllerInterfase.screenLine
        }
    }
    var pastScreen: ScreenControllerProtocol? {
        set(pastScreen){
            screenControllerInterfase.pastScreen = pastScreen
        }
        get{
            screenControllerInterfase.pastScreen
        }
    }
    
    init() {
        self.init(nibName: nil, bundle: nil)
    }
}

public protocol SetPresenterProtocol {
    func setPresenter()
}

//MARK: - ScreenController
/// `ru`: - расширение для `ScreenControllerProtocol` позволяющее делигировать ликику представления в `Presenter`
public protocol ScreenControllerPresentingProtocol: ScreenControllerProtocol, SetPresenterProtocol{
    associatedtype SPDP: PresenterNoJenericProtocol
    
    //MARK: - propertes
    //MARK: - presenter
    /// `ru`: - свойство которое инициализируется типом указанным в классе реализующем данный протокол
    var presenter: SPDP? { get set }
    
    //MARK: - iPhonePresenter
    /// `ru`: - свойство которое которое должно вернуть тип `Presenter` который будет инициализирован для версии `iPhone`
    var iPhonePresenter: PresenterNoJenericProtocol.Type? { get }
    
    //MARK: - iPadPresenter
    /// `ru`: - свойство которое которое должно вернуть тип `Presenter` который будет инициализирован для версии `iPad`
    var iPadPresenter: PresenterNoJenericProtocol.Type? { get }
}

extension ScreenControllerPresentingProtocol{
    var iPhonePresenter: PresenterNoJenericProtocol.Type? { nil }
    var iPadPresenter: PresenterNoJenericProtocol.Type? { nil }
    
    func setPresenter(){
        if UIDevice.current.userInterfaceIdiom == .pad, let type = iPadPresenter{
            presenter = type.init(installableScreen: self) as? Self.SPDP
        }else if UIDevice.current.userInterfaceIdiom == .phone, let type = iPhonePresenter{
            presenter = type.init(installableScreen: self) as? Self.SPDP
        }else{
            presenter = SPDP.init(installableScreen: self)
        }
        
        if let presenter = presenter as? ScreenModelSeterNJ{
            presenter.setModel()
        }
    }
}


public typealias ScreenController = UIViewController & ScreenControllerProtocol
public typealias ScreenControllerPresenting = ScreenController & ScreenControllerPresentingProtocol

public typealias ScreenNavigationController = UINavigationController & ScreenControllerProtocol
public typealias ScreenNavigationControllerPresenting = ScreenNavigationController & ScreenControllerPresentingProtocol

public typealias ScreenTabBarController = UITabBarController & ScreenControllerProtocol
public typealias ScreenTabBarControllerPresenting = ScreenTabBarController & ScreenControllerPresentingProtocol


