//
//  ScreensInstallerNew.swift
//  NewArc
//
//  Created by Александр Сенин on 18.06.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit
// MARK: - ScreenPresenterDelegateProtocol

// MARK: - InstallableScreenProtocol


class ScreensInstaller{
    static var inAnimation: Bool = false
    static var rootViewController: RootViewController!
    
    //MARK: - in
    static func installScreen(in viewController: UIViewController,
                              view: UIView? = nil,
                              installingScreen: ScreenControllerProtocol,
                              animation: TransitionAnimation? = nil) -> Bool{
        if viewController == installingScreen{return false}
        setChild(viewController, view, installingScreen)
        started(installingScreen)
        installingScreen.open()
        
        
        installingScreen.inAnim = true
        inAnimation = true
        
        let end = {
            installingScreen.inAnim = false
            self.inAnimation = false
            installingScreen.completedOpen()
        }
        
        animation?.funcAnim(nil, installingScreen.rotater, installingScreen.rotater?.superview ?? UIView(), end) ?? end()
        return true
    }
    
    //MARK: - instead
    static func installScreen(instead screen: ScreenControllerProtocol,
                              installingScreen: ScreenControllerProtocol? = nil,
                              archive: Bool = false,
                              pastScreen: ScreenControllerProtocol? = nil,
                              saveTranslite: Bool = true,
                              setLine: Bool = true,
                              animation: TransitionAnimation? = nil) -> Bool{
        
        if saveTranslite && (inAnimation || (installingScreen?.inAnim == true)){
            return false
        }
        
        if archive{
            var pastScreen = pastScreen
            if pastScreen == nil{
                pastScreen = screen
            }
            installingScreen?.pastScreen = pastScreen
        }
        screen.close()
        if let installingScreen = installingScreen, let parent = screen.parent{
            if screen == installingScreen {return false}
            if let selectLine = screen.screenLine, setLine{ LineController.setControllerInLine(selectLine, installingScreen) }
            setChild(parent, screen.rotater?.superview, installingScreen)
            started(installingScreen)
            installingScreen.open()
        }
        
        installingScreen?.inAnim = true
        inAnimation = true
        
        let end = {
            installingScreen?.inAnim = false
            self.inAnimation = false
            installingScreen?.completedOpen()
            screen.completedClose()
            
            removeChild(screen)
        }
        
        animation?.funcAnim(screen.rotater, installingScreen?.rotater, screen.rotater?.superview ?? UIView(), end) ?? end()
        
        return true
    }
    
    static func installPopUp(in view: UIView,
                             installingPopUpView: PopUpView,
                             anim open: TransitionAnimation = .shiftLeft,
                             anim close: TransitionAnimation = .shiftRight){
        /*
        let backView = installingPopUpView.backView
        backView.frame = view.bounds
        view.addSubview(backView)
        view.addSubview(installingPopUpView)
        
        open.funcAnimPopUp(installingPopUpView, backView, {})
        
       installingPopUpView.closeClouser = {[weak installingPopUpView] in
           guard let unInstallingPopUpView = installingPopUpView else {return}
           close.funcAnimPopUp(unInstallingPopUpView, backView, {[weak installingPopUpView] in
               guard let unInstallingPopUpView = installingPopUpView else {return}
               unInstallingPopUpView.removeFromSuperview()
               backView.removeFromSuperview()
           })
       }
         */
    }
    
    private static func setChild(_ viewController: UIViewController, _ view: UIView?, _ screen: ScreenControllerProtocol){
        let view: UIView = view ?? viewController.view
        screen.view.frame = view.bounds
        view.addSubview(screen.view)
        
        
        viewController.addChild(screen)
        screen.didMove(toParent: viewController)
        
        screen.rotater = Rotater(viewController: screen)
        ScreensInstaller.rootViewController?.roatateCild()
    }
    
    private static func removeChild(_ viewController: UIViewController){
        viewController.willMove(toParent: nil)
        viewController.removeFromParent()
        viewController.view.removeFromSuperview()
        (viewController as? ScreenController)?.rotater?.removeFromSuperview()
    }
    
    private static func started(_ screen: ScreenControllerProtocol){
        
        if !screen.starting{
            if let delegating = screen as? SetPresenterProtocol{
                delegating.setPresenter()
            }
            
            screen.start()
            screen.starting = true
        }
    }
    
    static func prepare(_ transitionType: TransitionProcedure.TransitionType, _ screen: UIViewController) -> TransitionProcedure{
        return TransitionProcedure(transitionType, screen)
    }
    
    static func prepare(_ transitionType: TransitionProcedure.TransitionType, _ line: String) -> TransitionProcedure{
        return TransitionProcedure(transitionType, line)
    }
}

public class TransitionProcedure{
    public enum TransitionType {
        case In
        case Instead
    }
    
    private var transitionType: TransitionType
    
    private weak var _screen: UIViewController?
    private var _view: UIView?
    private var _pastScreen: ScreenControllerProtocol?
    private var _installingScreen: ScreenControllerProtocol?
    private var _archive: Bool = false
    private var _saveTranslite: Bool = true
    private var _animation: TransitionAnimation?
    private var _selectLine: String?
    private var _setLine: Bool = true
    
    public init(_ transitionType: TransitionType, _ screen: UIViewController){
        self.transitionType = transitionType
        _screen = screen
    }
    
    public convenience init(_ transitionType: TransitionType, _ line: String){
        self.init(transitionType, LineController.getControllerInLine(line)!)
    }
    
    public convenience init(_ transitionType: TransitionType, _ line: ScreenLines){
        self.init(transitionType, line.id)
    }
    
    public func view(_ view: UIView) -> TransitionProcedure {
        _view = view
        return self
    }
    
    public func back() -> TransitionProcedure{
        return screen((_screen as? ScreenController)?.pastScreen)
    }
    
    public func screen(_ screen: ScreenControllerProtocol?) -> TransitionProcedure {
        _installingScreen = screen
        return self
    }
    
    public func line(_ string: String) -> TransitionProcedure {
        _selectLine = string
        _installingScreen = LineController.getControllerInLine(string)
        _setLine = false
        return self
    }
    
    public func line(_ screenLine: ScreenLines) -> TransitionProcedure {
        return line(screenLine.id)
    }
    
    public func setLine(_ setLine: Bool) -> TransitionProcedure {
        _setLine = setLine
        return self
    }
    
    public func archive(_ pastScreen: ScreenControllerProtocol? = nil) -> TransitionProcedure {
        _archive = true
        _pastScreen = pastScreen
        return self
    }
    
    public func saveTranslite(_ saveTranslite: Bool) -> TransitionProcedure {
        _saveTranslite = saveTranslite
        return self
    }
    
    public func animation(_ animation: TransitionAnimation) -> TransitionProcedure {
        _animation = animation
        return self
    }
    
    @discardableResult
    func transit() -> Bool{
        switch transitionType {
        case .In:
            guard let _screen = _screen else {return false}
            guard let _installingScreen = _installingScreen else {return false}
            return ScreensInstaller.installScreen(in: _screen, view: _view, installingScreen: _installingScreen, animation: _animation)
        case .Instead:
            guard let _screen = _screen as? ScreenControllerProtocol else {return false}
            let test = ScreensInstaller.installScreen(instead: _screen,
                                                      installingScreen: _installingScreen,
                                                      archive: _archive,
                                                      pastScreen: _pastScreen,
                                                      saveTranslite: _saveTranslite,
                                                      setLine: _setLine,
                                                      animation: _animation)
            
            return test
        }
    }
    
}





