//
//  Mouse.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 13/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import simd


public enum MouseCodes: Int {
    case left = 0
    case right = 1
    case center = 2
}

public enum Mouse {
    private static var MOUSE_BUTTON_COUNT = 12
    private static var mouseButtonList = [Bool].init(repeating: false, count: MOUSE_BUTTON_COUNT)

    private static var overallMousePosition = float2(repeating: 0)
    private static var mousePositionDelta = float2(repeating: 0)

    private static var scrollWheelPosition: Float = 0
    private static var lastWheelPosition: Float = 0.0
    private static var scrollWheelChange: Float = 0.0

    public static var overrallPosX: Float {
        return overallMousePosition.x
    }

    public static var overrallPosY: Float {
        return overallMousePosition.y
    }

    public static func SetMouseButtonPressed(button: Int, isOn: Bool){
        mouseButtonList[button] = isOn
    }

    public static func IsMouseButtonPressed(button: MouseCodes)->Bool{
        return mouseButtonList[Int(button.rawValue)] == true
    }

    public static func SetOverallMousePosition(position: float2){
        self.overallMousePosition = position
    }

    public static func ResetMouseDelta(){
        self.mousePositionDelta = float2(repeating: 0)
    }

    ///Sets the delta distance the mouse had moved
    public static func SetMousePositionChange(overallPosition: float2, deltaPosition: float2){
        self.overallMousePosition = overallPosition
        self.mousePositionDelta += deltaPosition
    }

    public static func ScrollMouse(deltaY: Float){
        scrollWheelPosition += deltaY
        scrollWheelChange += deltaY
    }

    //Returns the overall position of the mouse on the current window
    public static func GetMouseWindowPosition()->float2{
        return overallMousePosition
    }

    ///Returns the movement of the wheel since last time getDWheel() was called
    public static func GetDWheel()->Float{
        let position = scrollWheelChange
        scrollWheelChange = 0
        return position
    }

    ///Movement on the y axis since last time getDY() was called.
    public static func GetDY()->Float{
        let result = mousePositionDelta.y
        mousePositionDelta.y = 0
        return result
    }

    ///Movement on the x axis since last time getDX() was called.
    public static func GetDX()->Float{
        let result = mousePositionDelta.x
        mousePositionDelta.x = 0
        return result
    }

//    //Returns the mouse position in screen-view coordinates [-1, 1]
//    public static func GetMouseViewportPosition()->float2{
//        let x = (overallMousePosition.x - GameView.Width * 0.5) / (GameView.Width * 0.5)
//        let y = (overallMousePosition.y - GameView.Height * 0.5) / (GameView.Height * 0.5)
//        return float2(x, y)
//    }
}
