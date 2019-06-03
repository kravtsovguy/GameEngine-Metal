//
//  EditorViewModel.swift
//  GameEngine-Editor
//
//  Created by Matvey Kravtsov on 26/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import GameEngine
import simd


class EditorViewModel {

    struct Component {
        let name: String
        let parameters: [Parameter]
    }

    enum Parameter {
        case string(name: String, parameter: GameEngine.Component.Parameter<String>)
        case int(name: String, parameter: GameEngine.Component.Parameter<Int>)
        case float(name: String, parameter: GameEngine.Component.Parameter<Float>)
        case float3(name: String, parameter: GameEngine.Component.Parameter<float3>)

        var name: String {
            switch self {
            case .string(let name, _):
                return name
            case .int(let name, _):
                return name
            case .float(let name, _):
                return name
            case .float3(let name, _):
                return name
            }
        }
    }

    var name: String
    let components: [Component]

    init?(node: Node?) {
        guard let node = node else { return nil}

        var components: [Component] = []
        for component in node.components {
            var parameters: [Parameter] = []
            EditorViewModel.handleParameters(instance: component) { (label, value) in
                if let param = value as? GameEngine.Component.Parameter<Int> {
                    parameters.append(Parameter.int(name: label, parameter: param))
                } else if let param = value as? GameEngine.Component.Parameter<String> {
                    parameters.append(Parameter.string(name: label, parameter: param))
                }
            }

            components.append(Component(name: String(describing:type(of: component)),
                                        parameters: parameters))
        }

        self.name = node.name
        self.components = components
    }

    static func handleParameters(instance: Any, handle: (String, Any) -> ()) {
        let mirror = Mirror(reflecting: instance)
        for (label, value) in mirror.children {
            guard let label = label else { continue }
            handle(label, value)
        }
    }
}
