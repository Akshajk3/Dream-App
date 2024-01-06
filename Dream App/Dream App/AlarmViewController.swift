//
//  AlarmViewController.swift
//  Dream App
//
//  Created by Akshaj Kanumuri on 12/30/23.
//

import UIKit

class AlarmViewController: UIViewController {

    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var startTimerButton: UIButton!
    
    @IBOutlet weak var resetTimerButton: UIButton!
    
    @IBOutlet weak var circularProgressBar: UIView!
    
    var timer: Timer?
    var totalSeconds = 300
    var remainingSeconds = 0
    var isRunning = false
    var reset = true
    var progressBarLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCircularProgressBar()
        //startTimer()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func startButtonPressed(_ sender: Any) {
        if reset == true {
            startTimer()
        }
        else {
            if isRunning == false {
                resumeTimer()
            }
            else {
                pauseTimer()
            }
        }
    }
    
    @IBAction func resetButtonPressed(_ sender: Any) {
        resetTimer()
    }
    
    func setUpCircularProgressBar() {
        let progressBarRadius = timerLabel.bounds.width / 2.0 + 20.0
        let progressBarCenter = timerLabel.center
        
        let circularPath = UIBezierPath(arcCenter: progressBarCenter, radius: progressBarRadius, startAngle: -(.pi / 2),
                                        endAngle: .pi * 2 - (.pi / 2), clockwise: true)
        progressBarLayer = CAShapeLayer()
        progressBarLayer.path = circularPath.cgPath
        progressBarLayer.strokeColor = UIColor.blue.cgColor
        progressBarLayer.lineWidth = 10.0
        progressBarLayer.fillColor = UIColor.clear.cgColor
        progressBarLayer.lineCap = .round
        progressBarLayer.strokeEnd = 0.0
        
        view.layer.addSublayer(progressBarLayer)
    }
    
    func updateProgressBar() {
        let progress = 1.0 - Double(totalSeconds) / 300.0
        progressBarLayer.strokeEnd = CGFloat(progress)
    }
    
    func startTimer() {
        timer?.invalidate()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        
        isRunning = true
        reset = false
        startTimerButton.setTitle("Pause", for: .normal)
    }
    
    func pauseTimer() {
        timer?.invalidate()
        isRunning = false
        startTimerButton.setTitle("Resume", for: .normal)
        remainingSeconds = totalSeconds
    }
    
    func resumeTimer() {
        if !isRunning {
            totalSeconds = remainingSeconds
            startTimer()
        }
    }
    
    func resetTimer() {
        timer?.invalidate()
        startTimerButton.setTitle("Start", for: .normal)
        reset = true
        
        totalSeconds = 300
        remainingSeconds = 0
        
        let minutes = totalSeconds / 60
        let seconds = totalSeconds % 60
        
        timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
    }
    
    @objc func updateTimer() {
        if totalSeconds > 0 {
            totalSeconds -= 1
            updateProgressBar()
            
            let minutes = totalSeconds / 60
            let seconds = totalSeconds % 60
            
            timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
            //print(totalSeconds)
        }
        else {
            timer?.invalidate()
            timerLabel.text = "Time's up"
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if isRunning == true {
            pauseTimer()
        }
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
