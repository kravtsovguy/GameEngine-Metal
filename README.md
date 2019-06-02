# GameEngine by Metal

Проект игрового движка нужен тем разработчикам, кто планирует реализовать собственный графический или игровой проект с минимальными затратами по ресурсам и времени (относительно реализации с «нуля»). При этом движок полностью «нативен» для устройств Apple и поддерживает платформы macOS, iOS, tvOS.

# Руководство разработчика

## Добавление библиотеки
Для успешной работы с движком, необходимо подключить три артефакта.
Первый - файл статической библиотеки libGameEngine.a.
Второй - файл для описания интерфейса библиотеки GameEngine.swiftmodule
Третий - файл стандартной библиотеки шейдеров - ShadersLibrary.metallib

Пример их подключения можно посмотреть, открыв Demo проект

## Запуск движка

Для запуска движка необходимо создать файл в корне проекта main.Swift
В тело файла добавить следующий код:
```swift
import GameEngine

Main.start { params in
    params.title = "My Game"
    params.windowSizeMacOS = CGSize(width: 1200, height: 800)
    params.viewControllerType = CustomViewController.self
    params.viewType = CustomGameView.self
    params.sceneType = CustomScene.self
}
```
Таким образом движок будет настроен с параметрами, а потом запущен.
Подробнее познакомиться с полями настроек можно, заглянув в данный класс:
```swift
public final class Parameters {

    public var windowSizeMacOS: CGSize = CGSize(width: 1200, height: 800)
    public var appDelegateType: AppDelegate.Type = AppDelegate.self
    public var viewControllerType: GameViewController.Type = GameViewController.self
    public var viewType: GameView.Type = GameView.self
    public var sceneType: Scene.Type?
    public var title: String = ""

    fileprivate init() { }
}
```
- title - заголовок окна, имеет эффект только в системе macOS

- windowSizeMacOS - размер окна в операционной системе macOS (окно всегда появляется в центе)

- appDelegateType - класс делегата, если не подходит стандартный, то необходимо унаследоваться от класса GameEngine.AppDelegate и переопределить метод setup, выполняя всю необходимую настройку там

- viewControllerType - класс контроллера окна, если не подходит стандартный, то необходимо унаследоваться от класса GameEngine.GameViewController, при необходимости переопределите метод загрузки окна loadView

- viewType - класс окна отрисовки, если не подходит стандартный, то необходимо унаследоваться от класса GameEngine.GameView, при необходимости переопределите метод настройки окна setup

- sceneType - класс сцены, по-умолчанию он неназначен и при запуске будет черный экран, назначить сцену - обязательно условие. Класс сцены должен быть унаследован от класса GameEngine.Scene. Также необходимо переопределить конструктор и добавить объекты и компоненты там

## Создание сцены

### Описание

Сцена состоит из графа объектов, с корневым элементом с названием "Root"
![Граф сцены](https://downloader.disk.yandex.ru/preview/1aaec21fa3cb985e9e23ab23eb18d3e21904c82794a716d83f6c50f53f525e14/5cf3e60e/v9KF2KG3fmWkC4vRn1fxb95vrzivHCdsvW5431SGWOqhV-N23EsHNBhSgbJRxO99CRibLFPGpxb1W4AX39wXVQ%3D%3D?uid=0&filename=Схема1.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&tknv=v2&size=2048x2048)

Схема классов сцены
![Схема классов сцены](https://downloader.disk.yandex.ru/preview/bdfdbcbf931272a8093a90c1a052ba1af326412d8c94e87ace0aac72e7cefc28/5cf3e685/7HQnouCvIIh7LVOl5r-lBBf-n27bSVUt-h46ei0T0f6Gq6XcL49ouzm2wkpgaG3r0dt-UCdt5cvTU1nqHEx6nA%3D%3D?uid=0&filename=Схема2.png&disposition=inline&hash=&limit=0&content_type=image%2Fpng&tknv=v2&size=2048x2048)


Каждый объект имеет массив компонентов, при этом, каждый объект содержит минимум один компонент - Transform
Transform хранит состояние объекта в мире, а именно:
```swift
position: float3
scale: float3
rotation: float3
quaternion: simd_quatf
```
- position: задает позицию объекта в пространстве
- scale: задает масштаб объекта по всем трём осям X,Y,Z
- rotation: поворот объекта по всем трём осям X,Y,Z
- quaternion: кватернион для поворота объекта вокруг оси и на определенный угол. Позволяет избавиться от проблемы Gimbal Lock

### Добавление объектов на сцену

Рассмотрим пример кода с демо проекта:
```swift
    required init() {
        super.init(name: "Main")
        add(node: camera)
        add(node: train)
        add(node: trees)
        add(node: plane)
        add(node: sphere)
    }
```

- Создается сцена с названием "Main"
- На сцену добавляется 4 объекта:
    - camera
    - train
    - trees
    - plane
    - sphere
    
Рассмотрим каждый объект подробнее

#### Camera

```swift
let camera = Node(with: "Camera") { node in
        node.add(component: FPSCameraComponent(projectionType: .defaultPerspective)) { component in
            component.transform.position = [0, 0, -5]
            component.transform.rotation = [0, 0, radians(fromDegrees: 0)]
        }

        node.add(component: SoundComponent()) { component in
            component.playBackgroundMusic("ambient.wav")
        }
    }
```

К объекту с названием Camera добавляется два компонента: FPSCameraComponent и SoundComponent

- FPSCameraComponent: Это один из главных компонентов сцены, родительский класс Camera. Задача данного компонента - предоставить viewMatrix для вершинного шейдера. В данном случае создается камера в проекцией перспективы и выставляется позиция объекта на сцене

- SoundComponent: Компонент, позволяющий добавлять музыку на сцену

Также к объекту применяется трансформация перемещения и поворота

#### Plane

```swift
let plane = Node(with: "Plane") { node in
    let planeModel = Model.plane(material: Material(baseColor: [0.5,0.5,0.5],
                                                    specularColor: [0.5,0.5,0.5],
                                                    shininess: 1))
    node.add(component: ModelComponent(model: planeModel))
}
```

К объекту с названием Plane добавляется комнонент ModelComponent. Перед этим создается экземпляр класса Model, вызванный статическим методом plane, который создает поверхность размером 1 на 1 юнит. При создании модели указывается базовый цвет объекта, зеркальный цвет, а также степень отражения

#### Sphere

```swift
let sphere = Node(with: "Sphere") { node in
    let sphereModel = Model.sphere(material: Material(baseColor: [1.0,0.0,0.0],
                                                      specularColor: [0.2,0.2,0.2],
                                                      shininess: 1))
    node.add(component: ModelComponent(model: sphereModel))
    node.transform.position.y = 0.5
    node.transform.position.x = -1
    node.transform.scale = float3(repeating: 0.5)
}
```
К объекту с названием Sphere добавляется комнонент ModelComponent. Модель сферы создается с помощью статического метода Model.sphere и добавлением цветов для материала. Радиус сферы по-умолчанию 1 юнит
В конце, объекту присваивается позиция и масштаб.

#### Train

```swift
let train = Node(with: "Train") { node in
    let trainModel = Model(withObject: "train")
    node.add(component: ModelComponent(model: trainModel))
    node.add(component: MoveForwardComponent())
    node.transform.position.z = 0
    node.transform.scale = float3(repeating: 0.5)
    node.transform.rotation.y = radians(fromDegrees: 0)
}
```

К объекту с названием Train добавляется комнонент ModelComponent. Модель создается из файла с расширением ".obj", материал берется из файла ".mtl", тектура берется из соответствующего файла ".png". В данном случае это подель поезда, сделанная в программе Blender для macOS.
Далее добавляется кастомный компонент, который двигает объект вперед с постоянной скоростью
В конце, поезду задается перемещение, поворот и масштаб

#### Trees

```swift
let trees = Node(with: "Trees") { node in
    let treeModel = Model(withObject: "treefir")
    let treesComponent = InstanceComponent(model: treeModel, instanceCount: 3)
    node.add(component: treesComponent) { component in
        for i in 0..<3 {
            component.transforms[i].position.x = Float(i)
            component.transforms[i].position.y = 0
            component.transforms[i].position.z = 1
        }
    }
}
```
К объекту с названием Trees добавляется комнонент InstanceComponent. Этот класс является наследником класса ModelComponent, при инициализации на вход принимает саму модель и сколько копий нужно ещё создать. Этот компонент служит оптимизацией при отрисовки множества одинаковых объектов.
Далее, в компоненте для каждой модели присваивается позиция так, чтобы деревья выстроились в ряд

#### MoveForwardComponent

Данный компонент находится в демо проекте и его задача сделать так, чтобы объект в котором он лежит двигался по прямой с константной скоростью

```swift
final class MoveForwardComponent: Component {

    override public func start() {
        print("MoveForwardComponent started")
    }

    override public func update(with deltaTime: Float) {
        self.transform.position += self.transform.rightVector * deltaTime
    }
}
```

Любой компонент должен быть наследником класса GameEngine.Component.
В компоненте есть метод start, который можно переопределить и получать уведомление, когда компонент появляется на сцене.
Также, в компоненте есть метод update(deltaTime), который можно переопределить и получать оповещение каждый раз, когда надо отрисовать новый кадр. При этом, в аргумент передается время, между текущем кадром и предыдущем кадром. С помощью данного аргумента можно создавать плавное поведения объектов, даже если возникают "просадки" fps.
В программе Blender используется система координат, отличная от Metal, поэтому, чтобы двигать объект вперед нужно использовать нормализированный вектор, направленный вправо. При умножении значения перемещения на deltaTime, получается плавное перемещения, так как учитывается время между кадрами. 


## Создание собственного пайплайна отрисовки

Чтобы создать свой пайплайн отрисовки необходимо реализовать наследника класса GameView:

```swift
final class EditorGameView: GameView {
    private let renderPass: EditorRendererPass = EditorRendererPass()

    override func setup() {
        super.setup()
        renderer.renderPasses.append(renderPass)
    }
    
    ...
}
```

В нем необходимо создать экземпляр класса, реализующий протокол RendererPassProtocol, а также добавить его в массив графических пайплайнов, находящийся в экземпялре renderer (класс Renderer) 

```swift
public protocol RendererPassProtocol {

    var renderPassDescriptor: MTLRenderPassDescriptor { get }

    func setup(commandBuffer: MTLCommandBuffer)
    func setup(commandEncoder: MTLRenderCommandEncoder, renderer: Renderer)
    func teardown(commandBuffer: MTLCommandBuffer)
    func render(commandEncoder: MTLRenderCommandEncoder, renderable: Renderable)
    func commandBufferCompleted(commandBuffer: MTLCommandBuffer)
    func updateWithView(view: MTKView)
}
```

В наследнике, необходимо создать свой пайплайн отрисовки (пример взят из проекта GameEngine-Editor):

```swift
    static func createEditorRenderPipeline() -> MTLRenderPipelineState {
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm //view.colorPixelFormat
        pipelineStateDescriptor.depthAttachmentPixelFormat = .depth32Float //view.depthStencilPixelFormat
        pipelineStateDescriptor.vertexFunction =  Metal.developerLibrary.makeFunction(name: "vertex_editor")
        pipelineStateDescriptor.fragmentFunction = Metal.developerLibrary.makeFunction(name: "fragment_editor")
        pipelineStateDescriptor.vertexDescriptor = MTLVertexDescriptor.defaultVertexDescriptor()

        return try! Metal.device.makeRenderPipelineState(descriptor: pipelineStateDescriptor)
    }
```

Одна из самых важный вещей при создании пайплайна - указать вершинный шейдер и  фрагментный.
В данном случае используются шейдеры, реализованные в библиотеки разработчика, вот их код:

```metal
#include <metal_stdlib>
#include "../GameEngine/ShaderTypes.h"

using namespace metal;

struct VertexIn {
    float4 position [[attribute(0)]];
    float3 normal [[attribute(1)]];
    float2 uv [[attribute(2)]];
};

struct VertexOut {
    float4 position [[position]];
};

vertex VertexOut vertex_editor(VertexIn vertexBuffer [[stage_in]],
                             constant Uniforms &uniforms [[buffer(21)]]
                             ) {
    VertexOut out;
    out.position = uniforms.projectionMatrix * uniforms.viewMatrix * uniforms.modelMatrix * vertexBuffer.position;
    return out;
}

fragment float4 fragment_editor(VertexOut in [[stage_in]],
                              constant float3 &color [[buffer(12)]]) {
    return float4(color, 1);
}
```
Вначале надо подключить типы, которые находятся в заголовочном файле ShaderTypes.h, находящийся в проекте движка, он общий для всех проектов.

Также можно подключить свои заголовочные файлы.

Далее идет определение типов и реализация шейдеров.

Код необходимо писать на языке Metal Shading Language, разработанный компанией Apple (https://developer.apple.com/metal/Metal-Shading-Language-Specification.pdf). На самом деле это урезанный стандарт C++ 14.


## Заключение

Видно, что реализовать игру с помощью движка достаточно легко. Вся мощь заключается в компонентно-ориентированном подходе.
Также, если есть необходимость можно реализовывать свои пайплайны и писать свои шейдеры!
Разработка движка идет очень активно, поэтому документация и руководство может меняться просьба следить за изменениями.
