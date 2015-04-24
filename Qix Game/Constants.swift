//
//  Constants.swift
//  Qix Game
//
//  Created by Glen on 4/12/15.
//  Copyright (c) 2015 Melodic Bug. All rights reserved.
//

public class Constants{
    //Bit Masks
    //Collision
    let playerCollisionBitMask:UInt32 = 1
    let enemyCollisionBitMask:UInt32 = 1
    let borderCollisionBitMask:UInt32 = 8
    
    //Category
    let playerCategoryBitMask:UInt32 = 1 << 0
    let enemyCategoryBitMask:UInt32 = 1 << 1
    let borderCategoryBitMask:UInt32 = 1 << 2
}
