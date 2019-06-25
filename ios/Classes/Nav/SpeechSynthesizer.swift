//
//  SpeechSynthesizer.swift
//  officialDemoNavi
//
//  Created by liubo on 10/11/16.
//  Copyright © 2016 AutoNavi. All rights reserved.
//

import Foundation
import AVFoundation

final class SpeechSynthesizer: NSObject, AVSpeechSynthesizerDelegate {
    public static let Shared = SpeechSynthesizer()

    private var speechSynthesizer: AVSpeechSynthesizer!

    private override init(){
        super.init()

        buildSpeechSynthesizer()
    }

    public func speak(_ aString: String) {

        let aUtterance = AVSpeechUtterance(string: aString)
        aUtterance.voice = AVSpeechSynthesisVoice(language: "zh-CN")

        //iOS语音合成在iOS8及以下版本系统上语速异常
        let sysVer = (UIDevice.current.systemVersion as NSString).doubleValue
        if sysVer < 8.0 {
            aUtterance.rate = 0.25//iOS7设置为0.25
        }
        else if sysVer < 9.0 {
            aUtterance.rate = 0.15//iOS8设置为0.15
        }

        if speechSynthesizer.isSpeaking {
            speechSynthesizer.stopSpeaking(at: .word)
        }

        speechSynthesizer.speak(aUtterance)
    }

    public func isSpeaking() -> Bool {
        return speechSynthesizer.isSpeaking
    }

    public func stopSpeak() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }

    private func buildSpeechSynthesizer() {

        //简单配置一个AVAudioSession以便可以在后台播放声音，更多细节参考AVFoundation官方文档
        let session = AVAudioSession.sharedInstance()

        if let error = try? session.setCategory(AVAudioSession.Category.playback, options: AVAudioSession.CategoryOptions.duckOthers) {
            NSLog("AudioSession Error:\(error)")
        }

        speechSynthesizer = AVSpeechSynthesizer()
        speechSynthesizer.delegate = self
    }

}
