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
let camera = Node(with: "Camera") { node in

        node.add(component: FPSCameraComponent(projectionType: .defaultPerspective)) { component in
            component.transform.position = [0, 0, -5]
            component.transform.rotation = [0, 0, radians(fromDegrees: 0)]
        }

        node.add(component: SoundComponent()) { component in
            component.playBackgroundMusic("ambient.wav")
        }
    }

    let train = Node(with: "Train") { node in
        let trainModel = Model(withObject: "train")
        node.add(component: ModelComponent(model: trainModel))
        node.add(component: MoveForwardComponent())
        node.transform.position.z = 0
        node.transform.scale = float3(repeating: 0.5)
        node.transform.rotation.y = radians(fromDegrees: 0)
    }

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

    let plane = Node(with: "Plane") { node in
        let planeModel = Model.plane(material: Material(baseColor: [0.5,0.5,0.5],
                                                        specularColor: [0.5,0.5,0.5],
                                                        shininess: 1))
        node.add(component: ModelComponent(model: planeModel))
    }

    let sphere = Node(with: "Sphere") { node in
        let sphereModel = Model.sphere(material: Material(baseColor: [1.0,0.0,0.0],
                                                          specularColor: [0.2,0.2,0.2],
                                                          shininess: 1))
        node.add(component: ModelComponent(model: sphereModel))
        node.transform.position.y = 0.5
        node.transform.position.x = -1
        node.transform.scale = float3(repeating: 0.5)
    }

    required init() {
        super.init(name: "Main")
        add(node: camera)
        add(node: train)
        add(node: trees)
        add(node: plane)
        add(node: sphere)
    }
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
