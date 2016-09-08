//
//  ShipGame1.swift
//  FunctionalProgrammingDemo
//
//  Created by 张强 on 16/8/24.
//  Copyright © 2016年 ColorPen. All rights reserved.
//

import Foundation

// region - 范围
// 指代将Position转化为Bool的函数(Region 表示一个区域：圆，矩形等)
typealias Region = (Position) -> Bool

extension Ship {
    
    
    // 以更加声明的方式，判断一个区域内，是否包含某个点
    func pointInRange(point : Position) -> Bool {
        return true
    }
    
    // 以原点为圆心的圆
    func circle(radius: Distance) -> Region {
        return { point in point.length <= radius}
    }
    
    // 一个更普通的圆
    func circle2(radius: Distance, center: Position) -> Region {
        return { point in point.minus(center).length <= radius}
    }
    
    // 区域变换函数 - 按一定的偏移量移动一个区域
    func shift(region: Region, offset: Position) -> Region {
        return { point in region(point.minus(offset))}
    }
    
    // 反转一个区域，来定义另一个区域（补集）
    func invert(region: Region) -> Region {
        return { point in !region(point) }
    }

    // 交集
    func intersection(region1: Region, region2: Region) -> Region {
        return { point in region1(point) && region2(point) }
    }
    
    // 并集
    func union(region1: Region, region2: Region) -> Region {
        return { point in region1(point) || region2(point) }
    }
    
    // 在第一个区域中，且不在第二个区域中
    func difference(region: Region, minus: Region) -> Region {
        return intersection(region, invert(minus))
    }
    
    
    
    // 添加更多的辅助函数之后
    func canSafelyEngageShip3(target: Ship, friendly: Ship) -> Bool {
        
        let rangeRegion = difference(circle(firingRange), minus: circle(unsafeRange))
        
        // 攻击范围
        let firingRegion = shift(rangeRegion, offset: position)
        
        // 友船范围
        let friendlyRegion = shift(circle(unsafeRange), offset: friendly.position)
        
        // 攻击范围内，友船范围外
        let resultRegion = difference(firingRegion, minus: friendlyRegion)
       
        return resultRegion(target.position)
    }
    
}
