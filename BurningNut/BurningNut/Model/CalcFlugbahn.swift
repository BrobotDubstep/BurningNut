//
//  CalcFlugbahn.swift
//  BurningNut
//
//  Created by Tim Olbrich on 27.09.17.
//  Copyright © 2017 Tim Olbrich. All rights reserved.
//

import Foundation
import SpriteKit

class CalcFlugbahn {
    
    let scheitel = CGPoint(x: 50, y: 180)
    let scheitel_low = CGPoint(x: -100, y: -50)
    
    var lower_limit: CGFloat = 120, upper_bound: CGFloat = 140
    
    func parabel(t: CGFloat, x: CGFloat, y: CGFloat, x_in: CGFloat, y_in: CGFloat) -> CGFloat {
        let a = (y - y_in) / (pow(x,2) - pow(x_in,2))
        let c = y_in - (y - y_in) / (pow(x,2) - pow(x_in,2)) * pow(x_in,2)
        return a * pow(t,2) + c
    }
    
    func parabel_scheitel(t: CGFloat, x: CGFloat, y: CGFloat, x_s: CGFloat, y_s: CGFloat) -> CGFloat {
        let a = (y - y_s) / pow(x - x_s,2)
        return a * pow(t - x_s,2) + y_s
    }
    
    
    func flugkurve(t: CGFloat, x: CGFloat, y: CGFloat, x_in: CGFloat, y_in: CGFloat, player: CGFloat) -> CGFloat {
        
        let scheitel_y = parabel(t: 0, x: x, y: y, x_in: x_in, y_in: y_in)
        
        if( (y_in < -88||(y_in < -60 && x_in > 10)) && (player == 1) ){
            let x_s: CGFloat = -260
            let y_s: CGFloat = -90
            let m: CGFloat = 5*(y-y_s)/(x-x_s)
            let k: CGFloat = y - m*x
            return(m * t + k)
        }
        
        if( (y_in < -88||(y_in < -60 && x_in < -10)) && (player == -1) ){
            let x_s:CGFloat = 260
            let y_s: CGFloat = -90
            let m: CGFloat = 5*(y-y_s)/(x-x_s)
            let k: CGFloat = y - m*x
            return(m * t + k)
        }
        
        if scheitel_y < lower_limit {
            if(x_in < 50 && x_in > -50){
                return parabel_scheitel(t: t, x: x,y: y, x_s: scheitel_low.x * player, y_s: scheitel_low.y)
            }
            else{
                return parabel_scheitel(t: t, x: x,y: y,x_s: x_in,y_s: y_in)
            }
        }
        else if scheitel_y > upper_bound {
            return parabel_scheitel(t: t, x: x, y: y, x_s: scheitel.x, y_s: scheitel.y)
        }
        else{
            return parabel(t: t, x: x, y: y, x_in: x_in, y_in: y_in)
        }
    }
}
