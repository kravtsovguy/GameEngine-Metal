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
        fileprivate let realParameters: [RealParameter]

        var parameters: [Parameter] {
            return realParameters.map { realParameter -> Parameter in
                switch realParameter {
                case .string(let name, let parameter):
                    return .string(name: name, value: parameter.value)
                case .int(let name, let parameter):
                    return .int(name: name, value: parameter.value)
                case .float(let name, let parameter):
                    return .float(name: name, value: parameter.value)
                case .float3(let name, let parameter):
                    return .float3(name: name, value: parameter.value)
                }
            }
        }
    }

    enum Parameter {
        case string(name: String, value: String)
        case int(name: String, value: Int)
        case float(name: String, value: Float)
        case float3(name: String, value: float3)

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

    enum RealParameter {
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

//        func update(with parameter: Parameter) {
//            guard name != parameter.name else { return }
//            let p = parameter
//
//            switch self {
//                case .string(_, let parameter):
//                    parameter.value =
//                case .int(let name, let parameter):
//                    <#code#>
//                case .float(let name, let parameter):
//                    <#code#>
//                case .float3(let name, let parameter):
//                    <#code#>
//            }

//            switch parameter {
//            case .string(let name, let value):
//
//            case .int(let name, let value):
//                <#code#>
//            case .float(let name, let value):
//                <#code#>
//            case .float3(let name, let value):
//                <#code#>
//            @unknown default:
//                <#code#>
//            }
//        }
    }

    var name: String
    let components: [Component]

    init?(node: Node?) {
        guard let node = node else { return nil}

        var components: [Component] = []
        for component in node.components {
            var parameters: [Parameter] = []
            var realParameters: [RealParameter] = []
            EditorViewModel.handleParameters(instance: component) { (label, value) in
                if let param = value as? GameEngine.Component.Parameter<Int> {
//                    print("\(label): \(param.value)")
//                    param.value = 2
                    parameters.append(Parameter.int(name: label, value: param.value))
                    realParameters.append(RealParameter.int(name: label, parameter: param))
                }
            }

            components.append(Component(name: String(describing:type(of: component)),
                                        realParameters: realParameters))
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

    func updateComponent(name: String, parameter: Parameter) {
        components.forEach { component in
            guard component.name != name else { return }

            component.realParameters.forEach({ realParameter in
                guard parameter.name != realParameter.name else { return }

            })
        }
    }
}
