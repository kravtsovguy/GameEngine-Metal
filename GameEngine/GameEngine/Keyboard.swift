//
//  Keyboard.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 13/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


public enum Keyboard {
    private static var KEY_COUNT: Int = 256
    private static var keys = [Bool].init(repeating: false, count: KEY_COUNT)

    public static func setKeyPressed(_ keyCode: UInt16, isOn: Bool) {
        keys[Int(keyCode)] = isOn
    }

    public static func isKeyPressed(_ keyCode: KeyCodes)->Bool{
        return keys[Int(keyCode.rawValue)]
    }
}


