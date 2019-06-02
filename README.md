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
title - заголовок окна, имеет эффект только в системе macOS
windowSizeMacOS - размер окна в операционной системе macOS (окно всегда появляется в центе)
appDelegateType - класс делегата, если не подходит стандартный, то необходимо унаследоваться от класса GameEngine.AppDelegate и переопределить метод setup, выполняя всю необходимую настройку там
viewControllerType - класс контроллера окна, если не подходит стандартный, то необходимо унаследоваться от класса GameEngine.GameViewController, при необходимости переопределите метод загрузки окна loadView
viewType - класс окна отрисовки, если не подходит стандартный, то необходимо унаследоваться от класса GameEngine.GameView, при необходимости переопределите метод настройки окна setup
sceneType - класс сцены, по-умолчанию он неназначен и при запуске будет черный экран, назначить сцену - обязательно условие. Класс сцены должен быть унаследован от класса GameEngine.Scene. Также необходимо переопределить конструктор и добавить объекты и компоненты там


