//
//  AudioPlayerController.swift
//  MusicGen
//
//  Created by Kartinin Studio on 13.07.2021.
//

import AVFoundation
import UIKit



class AudioPlayerView: UIView {
    
    //MARK: - PROPERTIES
    var player:AVPlayer?
    var playerItem:AVPlayerItem?
    var realTimeTrack = 0 {
        didSet {
            let (h,m,s) = secondsToHoursMinutesSeconds(seconds: realTimeTrack)
            var seconds = "00"
            if s < 10 {
                seconds = "0\(s)"
            } else {
                seconds = "\(s)"
            }
            timeRunTitle.text = "\(m):\(seconds)"
        }
    }
    var urlTrack = "http://147.182.236.169/files?file_name=data%2Fresults%2FeJAyuIFSTtPFPukZhaMkHjV98hc2/ai2_50_arabic_18-08-2021-06-43-08_CONVERT_MID_TO_WAV.mp3"//"https://s3.amazonaws.com/kargopolov/kukushka.mp3" //"http://147.182.236.169/files?file_name=data%2Fresults%2Ffcb4d1ed-7d1b-482b-baf6-08e0035649fc_CONVERT_MID_TO_WAV.wav"
    //"https://s3.amazonaws.com/kargopolov/kukushka.mp3"
    
    let playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "play1X")
        button.setImage(image, for: .normal)
        //button.addTarget(self, action: #selector(playBtnPressed), for: .touchUpInside)
        return button
    }()
    
    let timeRunTitle: UILabel = {
        let label = UILabel()
        label.text = "0:00"
        label.font = UIFont(name: "Gilroy-SemiBold", size: 12)
        label.textColor = .orangeApp
        return label
    }()
    
    
    
    /* private var progressBarHighlightedObserver: NSKeyValueObservation?
        
    private lazy var progressBar: UISlider = {
        let bar = UISlider()
        bar.minimumTrackTintColor = .red
        bar.maximumTrackTintColor = .white
        bar.value = 0.0
        bar.isContinuous = false
        bar.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        self.progressBarHighlightedObserver = bar.observe(\UISlider.isTracking, options: [.old, .new]) { (_, change) in
            if let newValue = change.newValue {
                self.didChangeProgressBarDragging?(newValue, bar.value)
            }
        }
        return bar
    }()*/

    
    //MARK: - LIFECYCLE
    override init(frame: CGRect) {
            super.init(frame: frame)
       print("urlTrack = \(globalMidiUrl)")
        /*let customView = UIView()
        customView.frame = CGRect.init(x: 0, y: 0, width: Constants.screenSize.width, height: 100)
            customView.backgroundColor = UIColor.white     //give color to the view
           
            self.addSubview(customView)*/
        let newURLString = globalMidiUrl.replacingOccurrences(of: " ", with: "%", options: .literal, range: nil)
        let url = URL(string: newURLString)
        
                let playerItem:AVPlayerItem = AVPlayerItem(url: url!)
                player = AVPlayer(playerItem: playerItem)
                
                let playerLayer=AVPlayerLayer(player: player!)
                playerLayer.frame=CGRect(x:0, y:0, width:10, height:50)
                self.layer.addSublayer(playerLayer)
        
        
                
        self.addSubview(playButton)
        playButton.anchor(top: self.topAnchor, paddingTop: 0, width: 100, height: 100)
        playButton.centerX(inView: self)
                //playButton!.addTarget(self, action: Selector("playButtonTapped:"), for: .touchUpInside)
                playButton.addTarget(self, action: #selector(self.playButtonTapped(_:)), for: .touchUpInside)
                
                
                
                
                // Add playback slider
                
                let playbackSlider = UISlider(frame:CGRect(x:10, y:300, width:Constants.screenSize.width-40, height:20))
                playbackSlider.minimumValue = 0
                
                
               // let duration : CMTime = playerItem.asset.duration
        let timeIntvl: TimeInterval = TimeInterval(globalSeconds)
        let cmTime = CMTime(seconds: timeIntvl, preferredTimescale: 1000000)
                let seconds : Float64 = CMTimeGetSeconds(cmTime)//Float64 = CMTimeGetSeconds(duration)
       
                print("seconds = \(seconds)")
                print("seconds globalSeconds = \(globalSeconds)")
      /*  if globalSeconds <= 60 {
            playbackSlider.maximumValue = Float(seconds)//Float(seconds)
        } else {
            playbackSlider.maximumValue = Float(globalSeconds)//Float(seconds)
        }*/
        playbackSlider.maximumValue = Float(globalSeconds)
        print("seconds playbackSlider.maximumValue = \(playbackSlider.maximumValue)")
                playbackSlider.isContinuous = true
                playbackSlider.tintColor = UIColor.purpleApp
        playbackSlider.currentThumbImage?.withTintColor(UIColor.purpleApp)
       let image = UIImage(named: "Knob")
        playbackSlider.setThumbImage(image, for: .normal)
                
                playbackSlider.addTarget(self, action: #selector(self.playbackSliderValueChanged(_:)), for: .valueChanged)
               // playbackSlider.addTarget(self, action: "playbackSliderValueChanged:", forControlEvents: .ValueChanged)
                self.addSubview(playbackSlider)
        playbackSlider.anchor(top: self.topAnchor, paddingTop: 0, width: Constants.screenSize.width-40, height: 20)
        
        //time show
        let timeTitle = UILabel()
        let (h,m,s) = secondsToHoursMinutesSeconds(seconds: globalSeconds)
        timeTitle.text = "\(m):\(s)"
        timeTitle.font = UIFont(name: "Gilroy-SemiBold", size: 12)
        timeTitle.textColor = .orangeApp
        self.addSubview(timeTitle)
        timeTitle.anchor(top: self.topAnchor, right: self.rightAnchor, paddingTop: 20, paddingRight: 0, width: 30, height: 20)
        
        //timer run show
        self.addSubview(timeRunTitle)
        timeRunTitle.anchor(top: self.topAnchor, left: self.leftAnchor, paddingTop: 20, paddingLeft: 0, width: 30, height: 20)
      

        // Invoke callback every second
        let interval = CMTime(seconds:1.0, preferredTimescale: CMTimeScale(NSEC_PER_SEC))

        // Queue on which to invoke the callback
        let mainQueue = DispatchQueue.main

        // Keep the reference to remove
        var playerObserv = player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue) { time in
            print(time.seconds)
            self.realTimeTrack = Int(time.seconds)
            playbackSlider.setValue(Float(time.seconds), animated: true)
        }
    }
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - HELPER FUNCTION
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
      return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    @objc func playbackSliderValueChanged(_ playbackSlider:UISlider)
        {
            
            let seconds : Int64 = Int64(playbackSlider.value)
            let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
            
            player!.seek(to: targetTime)
            
            if player!.rate == 0
            {
                player?.play()
                let image = UIImage(named: "pause3X")
                playButton.setImage(image, for: .normal)
            }
        }
        
        
       @objc func playButtonTapped(_ sender:UIButton)
        {
            if player?.rate == 0
            {
                player!.play()
                //playButton!.setImage(UIImage(named: "player_control_pause_50px.png"), forState: UIControlState.Normal)
                //playButton.setTitle("Pause", for: UIControl.State.normal)
                let image = UIImage(named: "pause3X")
                playButton.setImage(image, for: .normal)
            } else {
                player!.pause()
                //playButton!.setImage(UIImage(named: "player_control_play_50px.png"), forState: UIControlState.Normal)
                //playButton.setTitle("Play", for: UIControl.State.normal)
                let image = UIImage(named: "play1X")
                playButton.setImage(image, for: .normal)
            }
        }
}
