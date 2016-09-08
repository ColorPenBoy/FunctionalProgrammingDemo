//
//  ShipGame.swift
//  FunctionalProgrammingDemo
//
//  Created by 张强 on 16/8/24.
//  Copyright © 2016年 ColorPen. All rights reserved.
//

import Foundation


typealias Distance = Double

struct Position {
    var x : Double
    var y : Double
}

extension Position {
    
    // 是否在射程之内（自己在原点）
    func inRange(_ range : Distance) -> Bool {
        return sqrt(x * x + y * y) < range
    }
    
    // 几何运算的辅助函数
    func minus(_ p : Position) -> Position {
        return Position(x: x - p.x, y: y - p.y)
    }
    
    var length: Double {
        return sqrt(x * x + y * y)
    }
}


struct Ship {
    var position : Position // 自身位置
    var firingRange : Distance
    var unsafeRange : Distance
}

extension Ship {
    
    // 可以交战的敌船 - 检验是否有另一艘船在射程内（无论自己是否在原点）
    func canEngageShip(_ target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange
    }
    
    // 避免与过近的敌船交火
    func canSafelyEngageShip(_ target: Ship) -> Bool {
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        return targetDistance <= firingRange && targetDistance > unsafeRange
    }
    
    // 避免自身过于靠近我发友船
    func canSafelyEngageShip1(_ target: Ship, friendly: Ship) -> Bool {
        
        // 目标范围距离
        let dx = target.position.x - position.x
        let dy = target.position.y - position.y
        let targetDistance = sqrt(dx * dx + dy * dy)
        
        // 友船距离自己目标的距离
        let friendlyDx = friendly.position.x - target.position.x
        let friendlyDy = friendly.position.y - target.position.y
        let friendlyDistance = sqrt(friendlyDx * friendlyDx + friendlyDy * friendlyDy)
        
        // 自己与友船都距离目标大于最小安全距离，自己与目标小于射程
        return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > unsafeRange
    }
    
    // 添加辅助函数之后
    func canSafelyEngageShip2(_ target: Ship, friendly: Ship) -> Bool {
        
        // 目标范围距离
        let targetDistance = target.position.minus(position).length
        
        // 友船距离自己目标的距离
        let friendlyDistance = friendly.position.minus(target.position).length
        
        // 自己与友船都距离目标大于最小安全距离，自己与目标小于射程
        return targetDistance <= firingRange && targetDistance > unsafeRange && friendlyDistance > unsafeRange
    }
    
  
    
    
}




