//
//  AVTonePlayerUnit.swift
//  Tone Generator
//
//  Created by Siseong Ahn on 2022/11/13.
//


import Foundation
import AVFoundation

class AVTonePlayerUnit: AVAudioPlayerNode {
    
    let bufferCapacity: AVAudioFrameCount = 512
    let sampleRate: Double = 48_000.0
    var frequency: Double = 440.0
    var decibel: Int = 50
    var amplitude: [Double] = [0, 0.00042, 0.001, 0.01, 0.1, 0.126, 0.251, 0.501, 0.708, 0.891, 1.0]

    
    private var theta: Double = 0.0
    private var audioFormat: AVAudioFormat!
    
    override init() {
        super.init()
        audioFormat = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1)
    }
    
    func prepareBuffer() -> AVAudioPCMBuffer {
        let buffer = AVAudioPCMBuffer(pcmFormat: audioFormat, frameCapacity: bufferCapacity)!
        fillBuffer(buffer)
        return buffer
    }
    
    func removeBuffer(_ buffer: AVAudioPCMBuffer) {
        
    }
    
    func fillBuffer(_ buffer: AVAudioPCMBuffer) {
        let data = buffer.floatChannelData?[0]
        let numberFrames = buffer.frameCapacity
        var theta = self.theta
        let theta_increment = 2.0 * .pi * self.frequency / self.sampleRate
        for frame in 0..<Int(numberFrames) {
            data?[frame] = Float32(sin(theta) * amplitude[Int(decibel/10)])
            
            theta += theta_increment
            if theta > 2.0 * .pi {
                theta -= 2.0 * .pi
            }
        }
        buffer.frameLength = numberFrames
        self.theta = theta
    }
    
    func scheduleBuffer() {
        let buffer = prepareBuffer()
        self.scheduleBuffer(buffer) {
            if self.isPlaying {
                self.scheduleBuffer()
            }
        }
    }
    
    func preparePlaying() {
        scheduleBuffer()
        scheduleBuffer()
        scheduleBuffer()
        scheduleBuffer()
    }
}
