//
//  TestViewController.swift
//  Tone Generator
//
//  Created by Siseong Ahn on 2022/11/13.
//

import UIKit
import AVFoundation

class TestViewController: UIViewController {

    @IBOutlet weak var labelFrequency: UILabel!
    @IBOutlet weak var buttonTestStart: UIButton!
    @IBOutlet weak var buttonNext: UIButton!
    @IBOutlet weak var buttonChart: UIButton!
    
    var engine: AVAudioEngine!
    var tone: AVTonePlayerUnit!
    let frequency = [250.0, 500.0, 1000.0, 1500.0, 2000.0, 3000.0, 4000.0, 6000.0, 8000.0]
    var testResult:[Double] = []
    var decibel = 0
    var testIndex = 0
    var timerTest: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        //[audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playback)
        }
        catch {
            debugPrint("error set category!")
        }
        

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        self.testResult.removeAll()
        self.labelFrequency.text = ""
        buttonTestStart.isHidden = false
        buttonNext.isHidden = true
        buttonChart.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueChart" {
            let vc = segue.destination as! ChartViewController
            for res in testResult {
                vc.valueLeftArray.append(res)
            }
        }
    }
    
    @IBAction func chartAppear(_ sender: Any) {
        performSegue(withIdentifier:"segueChart", sender: sender)
    }
    
    //@IBAction func chartAppear(_ sender: Any) {
       //let vc = self.storyboard?.instantiateViewController(withIdentifier: "TestViewController") as? TestViewController
        
        //vc?.modalPresentationStyle = .fullScreen
       // self.present(vc!, animated: true, completion: nil)
        
        //func Reply(data:[Double]){
        //    testResult = data
       // }
        
   // }
    
    @IBAction func actionStart(_ sender: Any) {
        //playTone()
        //startTest()
        testIndex = 0;
        decibel = 0;
        playTone()
        startTimer()
        
        buttonTestStart.isHidden = true
        buttonNext.isHidden = false
    }
    
    // 1회성 타이머 실행
    @objc func timerFire(timer: Timer) {
        print("\(frequency[testIndex]) - \(decibel) : test end")
        decibel = decibel + 10
        if (decibel == 100) {
            testIndex = testIndex + 1
            decibel = 0
        }
        
        if (testIndex > 8) {
            // TODO:  테스트 종료 후 결과 페이지로 이동
            print("test res = \(testResult.debugDescription)")
            stopTone()
            
            buttonTestStart.isHidden = false
            buttonNext.isHidden = true
            buttonChart.isHidden = false
        }
        else {
            stopTone()
            sleep(2)
            startTimer()
            playTone()
        }
        //print("timerFire!")
        //if timer.userInfo != nil {
        //    print("\(String(describing: timer.userInfo))")
            // Timer 1
        //}
    }
    
    // 1회성 타이머 시작
    func startTimer() {
        let userInfo = "Timer 1"
        self.labelFrequency.text = "\(frequency[testIndex]) Hz"
        
        timerTest = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerFire(timer:)), userInfo: userInfo, repeats: false)
        
        //decibel = decibel + 10
    }
    
    @IBAction func actionYes(_ sender: Any) {
        timerTest?.invalidate()
        testResult.append(Double(decibel))
        testIndex = testIndex + 1
        decibel = 0
        if (testIndex > 8) {
            print("test res = \(testResult.debugDescription)")
            // TODO: 테스트 종료 결과 페이지로 이동
            stopTone()
            
            buttonTestStart.isHidden = false
            buttonNext.isHidden = true
            buttonChart.isHidden = false
        }
        else {
            stopTone()
            sleep(2)
            startTimer()
            playTone()
        }

//        stopTest()
//        if (decibel > 90) {
//            //testResult.append(decibel)
//            testIndex = testIndex + 1
//            decibel = 0
//        }
//        else {
//            //decibel = decibel + 10
//            startTimer()
//        }
//        // TODO: timer 3초
//        //startTimer()
        
    }


    func playTone() {
    
        print("test 1")
        tone = AVTonePlayerUnit()
        tone.frequency = frequency[testIndex]
        tone.decibel = decibel
        print("test 2")
        let format = AVAudioFormat(standardFormatWithSampleRate: tone.sampleRate, channels: 1)
        print("test 3")
        engine = AVAudioEngine()
        print("test 4")
        engine.attach(tone)
        print("test 5")
        let mixer = engine.mainMixerNode
        engine.connect(tone, to: mixer, format: format)
        do {
            try engine.start()
        } catch let error as NSError {
            debugPrint(error)
        }
        tone.preparePlaying()
        tone.play()
        engine.mainMixerNode.volume = 1.0
    }
    
    func stopTone() {
        engine.mainMixerNode.volume = 0.0
        engine.stop()
        engine.disconnectNodeOutput(engine.mainMixerNode)
        engine.reset()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
