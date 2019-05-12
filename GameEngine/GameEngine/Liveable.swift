//
//  Liveable.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 09/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//


protocol Liveable: AnyObject {
    func start()
    func update(with deltaTime:Float)
}
