//
//  SoundComponent.swift
//  GameEngine
//
//  Created by Matvey Kravtsov on 13/05/2019.
//  Copyright © 2019 Matvey Kravtsov. All rights reserved.
//

import AVFoundation

public final class SoundComponent: Component {

    var backgroundMusicPlayer: AVAudioPlayer?
    var sounds: [String: AVAudioPlayer] = [:]

    static func preloadSoundEffect(_ filename: String) -> AVAudioPlayer? {
        guard let url = Bundle.main.url(forResource: filename,
                                        withExtension: nil) else {
                                            return nil
        }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            return player
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    public func load(soundNames: [String]) {
        for name in soundNames {
            let sound = SoundComponent.preloadSoundEffect(name)
            sounds[name] = sound
        }
    }

    public func playEffect(name: String) {
        sounds[name]?.play()
    }

    public func playBackgroundMusic(_ filename: String) {
        backgroundMusicPlayer = SoundComponent.preloadSoundEffect(filename)
        backgroundMusicPlayer?.numberOfLoops = -1
//        backgroundMusicPlayer?.play()
    }

    public func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }

    public override func start() {
        backgroundMusicPlayer?.play()
    }
}
