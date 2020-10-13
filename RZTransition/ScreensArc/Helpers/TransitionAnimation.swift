//
//  TransitionAnimation.swift
//  NewArc
//
//  Created by Александр Сенин on 07.07.2020.
//  Copyright © 2020 Александр Сенин. All rights reserved.
//

import UIKit

/*
public enum TransitionAnimation{
    case ezAnim
    case ezAnimR
    case ezAnimRSlou
    case swipeRight
    case appearance
    case exhaustion
    case circle(point: CGPoint)
    case circleP(rect: CGRect, color: UIColor, borderColor: UIColor? = nil)
    case circlePR(rect: CGRect, color: UIColor)
    case shiftRight
    case shiftLeft
    case shiftRightEz
    case shiftLeftEz
    
    var funcAnim: (_ firstView: UIView?,
                   _ secondView: UIView?,
                   _ rootSize: CGSize,
                   _ end: @escaping ()->())->(){
        switch self {
        case .ezAnim:
            return {firstView, secondView, rootSize, end in
                if let unwrapView = secondView{
                    unwrapView.transform.ty += rootSize.height
                    UIView.animate(withDuration: 0.6,
                                   delay: 0.0,
                                   usingSpringWithDamping: 1,
                                   initialSpringVelocity: 0,
                                   options: [.curveEaseInOut], animations: {
                        unwrapView.transform.ty = 0
                        firstView?.transform.ty -= rootSize.height * 0.3
                    }){(ending) in
                        firstView?.transform.ty = 0
                        end()
                    }
                }
            }
        case .ezAnimR:
            return {firstView, secondView, rootSize, end in
                if let unwrapView = firstView{
                    unwrapView.superview!.bringSubviewToFront(unwrapView)
                    secondView?.transform.ty -= rootSize.height * 0.3
                    UIView.animate(withDuration: 0.5, animations: {
                        unwrapView.transform.ty += rootSize.height
                        secondView?.transform.ty = 0
                    }){(ending) in
                        unwrapView.transform.ty = 0
                        end()}
                }
            }
        case .ezAnimRSlou:
            return {firstView, secondView, rootSize, end in
                if let unwrapView = firstView{
                    unwrapView.superview!.bringSubviewToFront(unwrapView)
                    UIView.animate(withDuration: 0.5, animations: {
                        unwrapView.transform.ty += rootSize.height
                    }){(ending) in
                        unwrapView.transform.ty = 0
                        end()}
                }
            }
        case .appearance:
            return {firstView, secondView, rootSize, end in
                if let unwrapView = secondView{
                    unwrapView.alpha = 0
                    UIView.animate(withDuration: 0.2, animations: {
                        unwrapView.alpha = 1
                    }){(ending) in end()}
                }
            }
        case .exhaustion:
            return {firstView, secondView, rootSize, end in
                if let unwrapView = firstView{
                    unwrapView.superview!.bringSubviewToFront(unwrapView)
                    UIView.animate(withDuration: 0.2, animations: {
                        unwrapView.alpha = 0
                    }){(ending) in
                        end()
                        unwrapView.alpha = 1
                    }
                }
            }
        case .swipeRight:
            return {firstView, secondView, rootSize, end in
                if let unwrapView = firstView{
                    secondView?.transform.tx -= rootSize.width * 0.3
                    unwrapView.superview!.bringSubviewToFront(unwrapView)
                    UIView.animate(withDuration: 0.3, animations: {
                        unwrapView.transform.tx += rootSize.width
                        secondView?.transform.tx = 0
                    }){(ending) in
                        unwrapView.transform.tx = 0
                        end()}
                }
            }
        case .circle(let point):
            return {firstView, secondView, rootSize, end in
                if let unwrapView = secondView{
                    let foundationFrame = CGRect(x: point.x,
                                                 y: point.y,
                                                 width: 0,
                                                 height: 0)
                    let foundation = UIView(frame: foundationFrame)
                    
                    unwrapView.frame.origin.x = -point.x
                    unwrapView.frame.origin.y = -point.y
                    foundation.layer.masksToBounds = true
                    unwrapView.superview!.addSubview(foundation)
                    foundation.addSubview(unwrapView)
                    UIView.animate(withDuration: 2, animations: {
                        foundation.frame = CGRect(x: -(foundation.superview!.frame.height * 2 - foundation.superview!.frame.width) / 2,
                                                  y: -foundation.superview!.frame.height / 2,
                                                  width: foundation.superview!.frame.height * 2,
                                                  height: foundation.superview!.frame.height * 2)
                        
                        unwrapView.frame.origin.x = (foundation.superview!.frame.height * 2 - foundation.superview!.frame.width) / 2
                        unwrapView.frame.origin.y = foundation.superview!.frame.height / 2
                        foundation.layer.cornerRadius = foundation.frame.height / 2
                    }){(ending) in
                        foundation.superview!.addSubview(unwrapView)
                        unwrapView.frame.origin.x = 0
                        unwrapView.frame.origin.y = 0
                        foundation.removeFromSuperview()
                        end()
                    }
                }
            }
        case .circleP(let rect, let color, let borderColor):
            return {firstView, secondView, rootSize, end in
                if let unwrapView = secondView{
                    let foundation = UIView(frame: rect)
                    foundation.alpha = 0
                    foundation.layer.cornerRadius = foundation.frame.height / 2
                    
                    unwrapView.transform.a = 0.001
                    unwrapView.transform.d = 0.001
                    
                    unwrapView.superview!.addSubview(foundation)
                    
                    unwrapView.superview!.bringSubviewToFront(unwrapView)
                    
                    unwrapView.frame.origin.x = rect.minX + rect.width / 2
                    unwrapView.frame.origin.y = rect.minY + rect.height / 2
                    unwrapView.alpha = 0
                    
                    foundation.backgroundColor = color
                    
                    if let borderColor = borderColor{
                        foundation.layer.borderWidth = 3
                        foundation.layer.borderColor = borderColor.cgColor
                    }
                    
                    UIView.animate(withDuration: 0.5, animations: {
                        unwrapView.transform.a = 1
                        unwrapView.transform.d = 1
                        unwrapView.frame.origin.x = 0
                        unwrapView.frame.origin.y = 0
                    })
                    
                    UIView.animate(withDuration: 0.6, animations: {
                        foundation.frame = CGRect(x: -(foundation.superview!.frame.height * 2 - foundation.superview!.frame.width) / 2,
                                                  y: -foundation.superview!.frame.height / 2,
                                                  width: foundation.superview!.frame.height * 2,
                                                  height: foundation.superview!.frame.height * 2)
                        foundation.layer.cornerRadius = foundation.frame.height / 2
                        
                    }, completion: {(ending) in
                        
                    })
                    
                    
                    UIView.animate(withDuration: 0.5, delay: 0.1, animations: {
                        unwrapView.alpha = 1
                    }){(ending) in
                        foundation.superview!.addSubview(unwrapView)
                        unwrapView.frame.origin.x = 0
                        unwrapView.frame.origin.y = 0
                        foundation.removeFromSuperview()
                        end()
                    }
                    
                    UIView.animate(withDuration: 0.05, animations: {
                        foundation.alpha = 1
                    })
                }
            }
        case .circlePR(let rect, let color):
            return {firstView, secondView, rootSize, end in
                if let unwrapView = firstView{
                    let foundation = UIView(frame: CGRect())
                    unwrapView.superview!.addSubview(foundation)
                    foundation.backgroundColor = color
                    unwrapView.superview!.bringSubviewToFront(unwrapView)
                    
                    foundation.frame = CGRect(x: -(foundation.superview!.frame.height * 2 - foundation.superview!.frame.width) / 2,
                                              y: -foundation.superview!.frame.height / 2,
                                              width: foundation.superview!.frame.height * 2,
                                              height: foundation.superview!.frame.height * 2)
                    foundation.layer.cornerRadius = foundation.frame.height / 2
                    
                    
                    UIView.animate(withDuration: 0.5, delay: 0.1, animations: {
                        unwrapView.center.x = rect.minX + rect.width / 2
                        unwrapView.center.y = rect.minY + rect.height / 2
                        
                        unwrapView.transform.a = 0.001
                        unwrapView.transform.d = 0.001
                    }, completion: {(ending) in
                        unwrapView.transform.a = 1
                        unwrapView.transform.d = 1
                        unwrapView.alpha = 1
                        
                        foundation.removeFromSuperview()
                        end()
                    })
                    
                    UIView.animate(withDuration: 0.6, animations: {
                        foundation.frame = rect
                        foundation.layer.cornerRadius = foundation.frame.height / 2
                    })
                    
                    UIView.animate(withDuration: 0.4, animations: {
                        unwrapView.alpha = 0
                    })
                    
                    UIView.animate(withDuration: 0.05, delay: 0.55, animations: {
                        foundation.alpha = 0
                    })
                }
            }
        case .shiftLeft:
            return {firstView, secondView, rootSize, end in
                if let unwrapViewF = firstView, let unwrapViewS = secondView{
                    unwrapViewS.transform.tx += rootSize.width
                    UIView.animate(withDuration: 0.3, animations: {
                        unwrapViewS.transform.tx = 0
                        unwrapViewF.transform.tx -= rootSize.width
                    }){(ending) in
                        unwrapViewF.transform.tx = 0
                        end()}
                }
            }
        case .shiftRight:
            return {firstView, secondView, rootSize, end in
                if let unwrapViewF = firstView, let unwrapViewS = secondView{
                    unwrapViewS.transform.tx -= rootSize.width
                    UIView.animate(withDuration: 0.3, animations: {
                        unwrapViewS.transform.tx = 0
                        unwrapViewF.transform.tx += rootSize.width
                    }){(ending) in
                        unwrapViewF.transform.tx = 0
                        end()}
                }
            }
        case .shiftLeftEz:
            return {firstView, secondView, rootSize, end in
                if let unwrapViewF = firstView, let unwrapViewS = secondView{
                    unwrapViewS.transform.tx += rootSize.width
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                        unwrapViewS.transform.tx = 0
                        unwrapViewF.transform.tx -= rootSize.width
                    }){(ending) in
                        unwrapViewF.transform.tx = 0
                        end()}
                }
            }
        case .shiftRightEz:
            return {firstView, secondView, rootSize, end in
                if let unwrapViewF = firstView, let unwrapViewS = secondView{
                    unwrapViewS.transform.tx -= rootSize.width
                    UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                        unwrapViewS.transform.tx = 0
                        unwrapViewF.transform.tx += rootSize.width
                    }){(ending) in
                        unwrapViewF.transform.tx = 0
                        end()}
                }
            }
        }
    }
    
    var funcAnimPopUp: (_ popUpView: PopUpView,_ backView: UIView, _ endCloser: @escaping ()->())->(){
        switch self {
        case .shiftRight:
            return {popUpView, backView, endCloser in
                UIView.animate(withDuration: 0.7,
                               delay: 0.0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.5,
                               options: [], animations: {
                   backView.alpha = 0
                   popUpView.transform.tx = ParentElements.rootSize.width
                }){_ in
                    backView.alpha = 1
                    popUpView.transform.tx = 0
                    endCloser()
                }
            }
            
        case .shiftLeft:
            return {popUpView, backView, endCloser in
                backView.alpha = 0
                popUpView.transform.tx = ParentElements.rootSize.width
                UIView.animate(withDuration: 0.7,
                               delay: 0.0,
                               usingSpringWithDamping: 0.8,
                               initialSpringVelocity: 0.5,
                               options: [], animations: {
                   backView.alpha = 1
                   popUpView.transform.tx = 0
                                
                }){_ in
                    endCloser()
                }
                
            }
            
        default: return {popUpView, backView, endCloser in}
        }
        
    }
}
 */

public struct TransitionAnimation: Equatable{
    public static func == (lhs: TransitionAnimation, rhs: TransitionAnimation) -> Bool {
        lhs.name == rhs.name
    }
    
    public typealias TAnimation = (_ oldView: UIView?, _ newView: UIView?, _ placeView: UIView, _ end: @escaping ()->()) -> ()
    public var funcAnim: TAnimation
    public var name: String = ""
    
    
    public init(_ name: String, _ funcAnim: @escaping TAnimation){
        self.funcAnim = funcAnim
        self.name = name
    }
    
    public static var ezAnim: TransitionAnimation{
        TransitionAnimation("ezAnim") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let newView = newView{
                newView.transform.ty += rootSize.height
                UIView.animate(withDuration: 0.6,
                               delay: 0.0,
                               usingSpringWithDamping: 1,
                               initialSpringVelocity: 0,
                               options: [.curveEaseInOut],
                animations:{
                    newView.transform.ty = 0
                    oldView?.transform.ty -= rootSize.height * 0.3
                }){_ in
                    oldView?.transform.ty = 0
                    end()
                }
            }
        }
    }
    
    public static var ezAnimR: TransitionAnimation{
        TransitionAnimation("ezAnimR") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView{
                placeView.bringSubviewToFront(oldView)
                newView?.transform.ty -= rootSize.height * 0.3
                UIView.animate(withDuration: 0.5, animations: {
                    oldView.transform.ty += rootSize.height
                    newView?.transform.ty = 0
                }){_ in
                    oldView.transform.ty = 0
                    end()
                }
            }
        }
    }
    
    public static var ezAnimRSlou: TransitionAnimation{
        TransitionAnimation("ezAnimRSlou") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView{
                placeView.bringSubviewToFront(oldView)
                UIView.animate(withDuration: 0.5, animations: {
                    oldView.transform.ty += rootSize.height
                }){_ in
                    oldView.transform.ty = 0
                    end()
                }
            }
        }
    }
    
    public static var appearance: TransitionAnimation{
        TransitionAnimation("appearance") { oldView, newView, placeView, end in
            if let newView = newView{
                newView.alpha = 0
                UIView.animate(withDuration: 0.2, animations: {
                    newView.alpha = 1
                }){_ in end()}
            }
        }
    }
    
    public static var exhaustion: TransitionAnimation{
        TransitionAnimation("exhaustion") { oldView, newView, placeView, end in
            if let oldView = oldView{
                placeView.bringSubviewToFront(oldView)
                UIView.animate(withDuration: 0.2, animations: {
                    oldView.alpha = 0
                }){(ending) in
                    end()
                    oldView.alpha = 1
                }
            }
        }
    }
    
    public static var swipeRight: TransitionAnimation{
        TransitionAnimation("swipeRight") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView{
                newView?.transform.tx -= rootSize.width * 0.3
                placeView.bringSubviewToFront(oldView)
                UIView.animate(withDuration: 0.3, animations: {
                    oldView.transform.tx += rootSize.width
                    newView?.transform.tx = 0
                }){_ in
                    oldView.transform.tx = 0
                    end()
                }
            }
        }
    }
    
    public static var shiftLeft: TransitionAnimation{
        TransitionAnimation("shiftLeft") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView, let newView = newView{
                newView.transform.tx += rootSize.width
                UIView.animate(withDuration: 0.3, animations: {
                    newView.transform.tx = 0
                    oldView.transform.tx -= rootSize.width
                }){_ in
                    oldView.transform.tx = 0
                    end()
                }
            }
        }
    }
    
    public static var shiftRight: TransitionAnimation{
        TransitionAnimation("shiftRight") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView, let newView = newView{
                newView.transform.tx -= rootSize.width
                UIView.animate(withDuration: 0.3, animations: {
                    newView.transform.tx = 0
                    oldView.transform.tx += rootSize.width
                }){_ in
                    oldView.transform.tx = 0
                    end()
                }
            }
        }
    }
    
    public static var shiftLeftEz: TransitionAnimation{
        TransitionAnimation("shiftLeftEz") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView, let newView = newView{
                newView.transform.tx += rootSize.width
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                    newView.transform.tx = 0
                    oldView.transform.tx -= rootSize.width
                }){_ in
                    oldView.transform.tx = 0
                    end()
                }
            }
        }
    }
    
    public static var shiftRightEz: TransitionAnimation{
        TransitionAnimation("shiftRightEz") { oldView, newView, placeView, end in
            let rootSize = placeView.frame.size
            if let oldView = oldView, let newView = newView{
                newView.transform.tx -= rootSize.width
                UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
                    newView.transform.tx = 0
                    oldView.transform.tx += rootSize.width
                }){_ in
                    oldView.transform.tx = 0
                    end()
                }
            }
        }
    }
    
    public static func circle(_ point: CGPoint) -> TransitionAnimation{
        TransitionAnimation("circle") { oldView, newView, placeView, end in
            if let newView = newView{
                let foundationFrame = CGRect(x: point.x,
                                             y: point.y,
                                             width: 0,
                                             height: 0)
                let foundation = UIView(frame: foundationFrame)
                
                newView.frame.origin.x = -point.x
                newView.frame.origin.y = -point.y
                foundation.layer.masksToBounds = true
                placeView.addSubview(foundation)
                foundation.addSubview(newView)
                UIView.animate(withDuration: 2, animations: {
                    foundation.frame = CGRect(x: -(placeView.frame.height * 2 - placeView.frame.width) / 2,
                                              y: -placeView.frame.height / 2,
                                              width: placeView.frame.height * 2,
                                              height: placeView.frame.height * 2)
                    
                    newView.frame.origin.x = (placeView.frame.height * 2 - placeView.frame.width) / 2
                    newView.frame.origin.y = placeView.frame.height / 2
                    foundation.layer.cornerRadius = foundation.frame.height / 2
                }){(ending) in
                    placeView.addSubview(newView)
                    newView.frame.origin.x = 0
                    newView.frame.origin.y = 0
                    foundation.removeFromSuperview()
                    end()
                }
            }
        }
    }
    
    public static func circleP(rect: CGRect, color: UIColor, borderColor: UIColor? = nil) -> TransitionAnimation{
        TransitionAnimation("circleP") { oldView, newView, placeView, end in
            if let newView = newView{
                let foundation = UIView(frame: rect)
                foundation.alpha = 0
                foundation.layer.cornerRadius = foundation.frame.height / 2
                
                newView.transform.a = 0.001
                newView.transform.d = 0.001
                
                placeView.addSubview(foundation)
                
                placeView.bringSubviewToFront(newView)
                
                newView.frame.origin.x = rect.minX + rect.width / 2
                newView.frame.origin.y = rect.minY + rect.height / 2
                newView.alpha = 0
                
                foundation.backgroundColor = color
                
                if let borderColor = borderColor{
                    foundation.layer.borderWidth = 3
                    foundation.layer.borderColor = borderColor.cgColor
                }
                
                UIView.animate(withDuration: 0.5, animations: {
                    newView.transform.a = 1
                    newView.transform.d = 1
                    newView.frame.origin.x = 0
                    newView.frame.origin.y = 0
                })
                
                UIView.animate(withDuration: 0.6, animations: {
                    foundation.frame = CGRect(x: -(placeView.frame.height * 2 - placeView.frame.width) / 2,
                                              y: -placeView.frame.height / 2,
                                              width: placeView.frame.height * 2,
                                              height: placeView.frame.height * 2)
                    foundation.layer.cornerRadius = foundation.frame.height / 2
                    
                }, completion: {(ending) in
                    
                })
                
                
                UIView.animate(withDuration: 0.5, delay: 0.1, animations: {
                    newView.alpha = 1
                }){(ending) in
                    placeView.addSubview(newView)
                    newView.frame.origin.x = 0
                    newView.frame.origin.y = 0
                    foundation.removeFromSuperview()
                    end()
                }
                
                UIView.animate(withDuration: 0.05, animations: {
                    foundation.alpha = 1
                })
            }
        }
    }
    
    public static func circlePR(rect: CGRect, color: UIColor) -> TransitionAnimation{
        TransitionAnimation("circlePR") { oldView, newView, placeView, end in
            if let oldView = oldView{
                let foundation = UIView(frame: CGRect())
                placeView.addSubview(foundation)
                foundation.backgroundColor = color
                placeView.bringSubviewToFront(oldView)
                
                foundation.frame = CGRect(x: -(placeView.frame.height * 2 - placeView.frame.width) / 2,
                                          y: -placeView.frame.height / 2,
                                          width: placeView.frame.height * 2,
                                          height: placeView.frame.height * 2)
                foundation.layer.cornerRadius = foundation.frame.height / 2
                
                
                UIView.animate(withDuration: 0.5, delay: 0.1, animations: {
                    oldView.center.x = rect.minX + rect.width / 2
                    oldView.center.y = rect.minY + rect.height / 2
                    
                    oldView.transform.a = 0.001
                    oldView.transform.d = 0.001
                }, completion: {(ending) in
                    oldView.transform.a = 1
                    oldView.transform.d = 1
                    oldView.alpha = 1
                    
                    foundation.removeFromSuperview()
                    end()
                })
                
                UIView.animate(withDuration: 0.6, animations: {
                    foundation.frame = rect
                    foundation.layer.cornerRadius = foundation.frame.height / 2
                })
                
                UIView.animate(withDuration: 0.4, animations: {
                    oldView.alpha = 0
                })
                
                UIView.animate(withDuration: 0.05, delay: 0.55, animations: {
                    foundation.alpha = 0
                })
            }
        }
    }
    
    
    public static var shiftRightPopUp: TransitionAnimation{
        TransitionAnimation("shiftRightPopUp") { _, popUpView, backView, end in
            UIView.animate(withDuration: 0.7,
                           delay: 0.0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [], animations: {
               backView.alpha = 0
               popUpView?.transform.tx = backView.frame.width
            }){_ in
                backView.alpha = 1
                popUpView?.transform.tx = 0
                end()
            }
        }
    }
    
    public static var shiftLeftPopUp: TransitionAnimation{
        TransitionAnimation("shiftLeftPopUp") { _, popUpView, backView, end in
            backView.alpha = 0
            popUpView?.transform.tx = backView.frame.width
            UIView.animate(withDuration: 0.7,
                           delay: 0.0,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0.5,
                           options: [], animations: {
               backView.alpha = 1
               popUpView?.transform.tx = 0
                            
            }){_ in
                end()
            }
        }
    }
}
