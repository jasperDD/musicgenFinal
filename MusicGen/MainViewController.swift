//
//  ViewController.swift
//  MusicGen
//
//  Created by Kartinin Studio on 10.06.2021.
//

import UIKit
import Firebase
import GaugeSlider
import HGCircularSlider
import SwiftyJSON
import Alamofire
import AVFoundation
import StoreKit

import MediaPlayer


var products: [SKProduct] = []
var productPrice = "0"
var globalMidiUrl = "http://147.182.236.169/files?file_name=data%2Fresults%2FeJAyuIFSTtPFPukZhaMkHjV98hc2/ai2_180_rock_23-08-2021-17-57-24_CONVERT_MID_TO_WAV.mp3" //"http://147.182.236.169/files?file_name=%2Fapp%2Fdata%2Fresults%2FWH2OrrClocO7ZiF8Jq8muUmSjse2/Into Battle - клавиши и метроном_ai4_revert_invert_None_rock_07-10-2021-10-22-54_midi_to_mp3.mp3"
//http://147.182.236.169/files?file_name=%2Fapp%2Fdata%2Fresults%2FWH2OrrClocO7ZiF8Jq8muUmSjse2/HOT_GIRL_ai4_revert_invert_None_rock_07-10-2021-09-14-40_midi_to_mp3.mp3
var globalSeconds = 0



class MainViewController: UIViewController, UICollectionViewDelegate, AVAudioPlayerDelegate, MPMediaPickerControllerDelegate {
    
    //MARK: - PROPERTIES
    //Timer
    @IBOutlet weak var minutesCircularSlider: CircularSlider!
    @IBOutlet weak var hoursCircularSlider: CircularSlider!
    
    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    
    @IBOutlet weak var viewForTimeSlider: UIView!
    var barDown = UIImageView()
    var idToken = ""
    var sizeWidthCellInstruments = [CGSize]()
    
    var audioPlayer: AVAudioPlayer?
    var switchChardsDidChange = true
    
    /*  let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
     lazy var instrumentsCollectionView: UICollectionView = UICollectionView(frame: view.frame, collectionViewLayout: layout)
     private let cellReuseIdentifier = "Cell"*/
    //var headerView = UIView()
    let genresArray = ["50s",
                       "60s",
                       "50s",
                       "70s",
                       "80s",
                       "90s",
                       "anime",
                       "arabic",
                       "blues",
                       "country",
                       "diversen",
                       "drums",
                       "euro",
                       "hardcore",
                       "hardRock",
                       "house",
                       "jazz",
                       "pop",
                       "rap",
                       "rave",
                       "reggae",
                       "rock",
                       "trance",
                       "videoGames"
    ]
    /*let genresArray = ["101 plus",
     "1998 PRO MIDI`S",
     "1999 PRO MIDI`S",
     "1 tot100",
     "anthems",
     "arabic",
     "assorti",
     "BLUEGR~5",
     "blues",
     "broadway",
     "CHILDR~7",
     "christian",
     "christmas",
     "classic rock musician",
     "classic",
     "Classical Archives - The Greats (MIDI)",
     "COUNTR~9",
     "Country & Western",
     "dance",
     "DANSM~11",
     "Disco House",
     "Diversen",
     "Diversen GM",
     "Diversen Klassiek",
     "Diversen Midi GM songs",
     "Diversen Midi GS songs",
     "drums",
     "DUITS~13",
     "DUITS~15",
     "Esy Listening",
     "euro",
     "eurodance",
     "FILM&~17",
     "FOLK&~19",
     "FRANS~21",
     "funk",
     "GForce Trance Epic House 220 MIDI loops",
     "GM GS Reset",
     "happy hardcore",
     "Hard Rock 2",
     "hardcore",
     "Hardcore&Hardstyle MIDIs",
     "harddance",
     "Heavy Metal -MidiFiles",
     "hollands",
     "HOUSE~25",
     "instrumental",
     "INTERNET",
     "ITALI~27",
     "JAPAN~29",
     "jazz",
     "JAZZ_~33",
     "JAZZR~31",
     "JINGL~35",
     "Karaoke Midi Files",
     "Kerst Midi Files",
     "KERST~37",
     "KLASS~39",
     "LATIN~41",
     "MEDLE~43",
     "Midi -DRUMS",
     "Midi-bb",
     "Midi-gm",
     "motown",
     "Movie_Soundtracks",
     "M-sales",
     "NEDER~45",
     "NEW-AGE",
     "Oldies_but_Goodies",
     "ONBEK~49",
     "OTHERS - MIDI",
     "PIANO~51",
     "Polyfonisk musik",
     "pop",
     "pop midi",
     "Pop_and_Top40",
     "PsyTrance Artists Midi Pack",
     "rap",
     "rave",
     "reggae",
     "rock",
     "rock midi_",
     "Roland Songs",
     "siemens",
     "Song Teksten",
     "Soul, Gospel & Rhythm & Blues",
     "Soundtracks",
     "stadium",
     "Synth Music",
     "Synthesizer",
     "techno",
     "teksten",
     "television",
     "The Sound Of The 50's (Engelstalig)",
     "The Sound Of The 60's (Engelstalig)",
     "The Sound Of The 70's (Engelstalig)",
     "The Sound Of The 80's (Engelstalig)",
     "The Sound Of The 90's (Engelstalig)",
     "Themes movie TV",
     "tiroler",
     "Polka & Marsmuziek",
     "trance",
     "tropical",
     "Various Artists",
     "Video_Games",
     "WWW.HANDS-ON-MIDI.CO.UK",
     "WWW.TUNE1000.CO.UK"]*/
    var instumentsArray = [String]()
    let UIPicker: UIPickerView = UIPickerView()
    let UIPickerInstruments: UIPickerView = UIPickerView()
    let blackView = UIView()
    let step:Float = 1
    var arrData = [String]() // This is your data array
    var arrSelectedIndex = [IndexPath]() // This is selected cell Index array
    var arrSelectedData = [String]() // This is selected cell data array
    var saveInstrumentsBtn = [String]()
    var saveInstrumentsBtnInt = [Int]()
    
    let addChardsView = UIView()
    var timer: Timer?
    
    var sliderStepAi = 3
    var genres = "rock"
    var bpmValue = 180
    var midiFilename = String()
    var mp3Filename = String()
    var messageForDownload = ""
    
    let settingsBtn: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Settings", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor: UIColor.orangeApp])
        
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 12)
        button.addTarget(self, action: #selector(settingsPressed), for: .touchUpInside)
        button.setAttributedTitle(attributedTitle, for: .normal)
        return button
    }()
    
    private let percentLoadLabel: UILabel = {
        let label = UILabel()
        label.text = "0 %"
        label.font = UIFont(name: "Gilroy-SemiBold", size: 21)
        label.textColor = .orangeApp
        return label
    }()
    
    private let waitingLoadLabel: UILabel = {
        let label = UILabel()
        label.text = "Waiting.."
        label.font = UIFont(name: "Gilroy-SemiBold", size: 21)
        label.textColor = .white
        return label
    }()
    
    private let genresBtn: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Rock", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        button.setTitleColor(UIColor.orangeApp, for: .normal)
        button.addTarget(self, action: #selector(genresBtnPressed), for: .touchUpInside)
        return button
    }()
    private let instrumentsBtn: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Accordion", for: .normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        button.setTitleColor(UIColor.orangeApp, for: .normal)
        button.addTarget(self, action: #selector(instrumentsBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let pianoBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "pianoBtn")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(pianoBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let guitarBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "guitarBtn")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(guitarBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let stringsBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "stringsBtn")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(stringsBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let bassBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "bassBtn")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(bassBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let drumsBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "drumsBtn")
        button.setImage(image, for: .normal)
        button.addTarget(self, action: #selector(drumsBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let generateBtn: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Generate Music", for: .normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        button.setTitleColor(UIColor.orangeApp, for: .normal)
        button.addTarget(self, action: #selector(generateBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let getSongsBtn: UIButton = {
        let button = AuthButton(type: .system)
        button.setTitle("Get Music", for: .normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        button.setTitleColor(UIColor.orangeApp, for: .normal)
        button.addTarget(self, action: #selector(getSongsBtnPressed), for: .touchUpInside)
        return button
    }()
    
    private let downloadBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "Download1X")
        button.setImage(image, for: .normal)
        button.setTitle("Download", for: .normal)
        button.addTarget(self, action: #selector(downloadBtnPressed), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 40, left: -80, bottom: 0, right: 0)
        button.setTitleColor(UIColor.purpleApp, for: UIControl.State.normal)
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        return button
    }()
    
    private let donateBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "donate1X")
        button.setImage(image, for: .normal)
        button.setTitle("Donate", for: .normal)
        button.addTarget(self, action: #selector(donateBtnPressed), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 40, left: -80, bottom: 0, right: 0)
        button.setTitleColor(UIColor.purpleApp, for: UIControl.State.normal)
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        return button
    }()
    
    private let shareBtn: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "share1X")
        button.setImage(image, for: .normal)
        button.setTitle("Share", for: .normal)
        button.addTarget(self, action: #selector(shareBtnPressed), for: .touchUpInside)
        button.titleEdgeInsets = UIEdgeInsets(top: 40, left: -50, bottom: 0, right: 0)
        button.setTitleColor(UIColor.purpleApp, for: UIControl.State.normal)
        button.widthAnchor.constraint(equalToConstant: 120).isActive = true
        button.titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        return button
    }()
    
    var user: User? {
        didSet{
            // locationInputView.user = user
            print("DEBUG: ..")
            generateBtn.isHidden = false
        }
    }
    lazy var instrumentsCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(InstrumentsCollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        return cv
    }()
    
    let modelName = UIDevice.modelName
    
    //ScrollView
    
    let scrollView: UIScrollView = {
            let v = UIScrollView()
            v.translatesAutoresizingMaskIntoConstraints = false
            v.backgroundColor = .clear
            return v
        }()
    
    
    
    var listFontsView = UIView()
    var musicFontsBtn = [UIButton]()

        
       
        
        let label1: UILabel = {
            let label = UILabel()
            label.text = "Choose the music fonts"
            label.numberOfLines = 0
            label.sizeToFit()
            label.textColor = UIColor.white
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
       
    
        let contentView = UIView()
    var arrayMusicFonts = [String]()
    
    var instrumentsAvailableForCV = [String]()
    var currentMusicFont = String() {
        didSet {
            instrumentsCollectionView.reloadData()
            contentView.removeFromSuperview()
            scrollView.removeFromSuperview()
        }
    }
   
    
    //MARK: - LIFE CYCLE
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser?.uid != nil {
            let uid = Auth.auth().currentUser?.uid ?? ""
            //user is logged in
            print("login")
            Service.shared.fetchUserData(uid: uid, completion: { user in
                print(user)
                self.user = user
            })
            let currentUser = Auth.auth().currentUser
            currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
                if let error = error {
                    // Handle error
                    print(error)
                    return;
                }
                self.idToken = idToken ?? ""
                print("self.idToken = \(self.idToken)")
                print("GENERATE BTN")
                //let strURL = "147.182.236.169/users"
                guard let strURL = URL(string: "http://147.182.236.169/users") else { return }
                let headers: HTTPHeaders =  [ "id-token" : self.idToken ]
                
                AF.request(strURL, method: .post, headers: headers).responseJSON { (responseObject) -> Void in
                    
                    // print(responseObject)
                    switch (responseObject.result) {
                    case .success(let json):
                        
                        let json2 = json as? Dictionary<String, AnyObject>
                        print("json2=\(json2)")
                        let uid_str = json2?["uid"] as? String ?? ""
                        print("uid_str = \(uid_str)")
                        self.uidUser = uid_str
                        
                    case .failure(let error):
                        print(error)
                    //failure code here
                    }
                    // Send token to your backend via HTTPS
                    // ...
                }
                // Send token to your backend via HTTPS
            }
            
        }else{
            //user is not logged in
            let vc = LoginViewController()
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true, completion: nil)
        }
        
        for i in 0..<Instruments.allCases.count {
            if let font = UIFont(name: "Gilroy-SemiBold", size: 16) {
                let fontAttributes = [NSAttributedString.Key.font: font]
                let myText = "\(Instruments.statusList[i])"
                let size = (myText as! NSString).size(withAttributes: fontAttributes)
                self.sizeWidthCellInstruments.append(size)
                
            }
        }
        
    }
    
    var uidUser = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  "\(Instruments.statusList[indexPath.row])"
        
        
        
        
        
        configure()
        
        
        self.view.backgroundColor = .bgApp
        
        
        for instrument in Instruments.allCases {
            
            instumentsArray.append(instrument.rawValue)
        }
        
        // Do any additional setup after loading the view.
    }
    
    
    
    //MARK: - HELPER FUNCTIONS
    func logoutUser() {
        // call from any screen
        
        do { try Auth.auth().signOut() }
        catch { print("already logged out") }
        
    }
  
    
    func createSpinnerView() {
        let child = SpinnerLoaderView()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.alpha = 0.5
        // wait two seconds to simulate some work happening
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // then remove the spinner view controller
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }
    }
    //PICKER CONTROLLER
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    
    var songUrl: NSURL = NSURL()
    func mediaPicker(_ mediaPicker: MPMediaPickerController, didPickMediaItems mediaItemCollection: MPMediaItemCollection) {
        let assetURL = mediaItemCollection.items.first?.artist
        
        print("songUrl = \(assetURL)")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func createDownDesign() {
        //Down design
        let image = UIImage(named: "barDown1X")
        barDown = UIImageView(image: image)
        barDown.frame = CGRect.init(x: 0, y: 0, width: Constants.screenSize.width, height: 86)
        view.addSubview(barDown)
        barDown.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 0, paddingBottom: 0, width: Constants.screenSize.width, height: 86)
        
        view.addSubview(downloadBtn)
        downloadBtn.anchor(top: barDown.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 50, width: 80, height: 80)
        downloadBtn.isHidden = true
        
        view.addSubview(donateBtn)
        donateBtn.anchor(top: barDown.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 50, width: 80, height: 80)
         
        view.addSubview(shareBtn)
        shareBtn.anchor(top: barDown.topAnchor, left: view.leftAnchor, paddingTop: 15, paddingLeft: 120, width: 50, height: 50)
        shareBtn.isHidden = true
    }
    
    func configure() {
        let headerView = HeaderView()
        headerView.frame = CGRect.init(x: 0, y: 0, width: Constants.screenSize.width, height: 60)
        headerView.backgroundColor = UIColor.purpleApp
        self.view.addSubview(headerView)
        
        view.addSubview(settingsBtn)
        settingsBtn.anchor(top: headerView.topAnchor, left: view.leftAnchor, paddingTop: 30, paddingLeft: 0, width: 100, height: 30)
        
        view.addSubview(genresBtn)
        genresBtn.anchor(top: headerView.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, width: Constants.screenSize.width-40, height: 60 )
        genresBtn.addShadow()
        var genresArrow = UIView()
        let genresArrowImage = UIImage(named: "arrowGenres1X")
        genresArrow = UIImageView(image: genresArrowImage)
        genresArrow.frame = CGRect.init(x: 0, y: 0, width: 30, height: 86)
        genresBtn.addSubview(genresArrow)
        genresArrow.anchor(right: genresBtn.rightAnchor, paddingRight: 20, width: 8, height: 5)
        genresArrow.centerY(inView: genresBtn)
        
        /*view.addSubview(instrumentsBtn)
         instrumentsBtn.anchor(top: genresBtn.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingRight: 20, width: Constants.screenSize.width-40, height: 60 )*/
        
        let stackBtn = UIStackView(arrangedSubviews: [pianoBtn,
                                                      guitarBtn,
                                                      stringsBtn,
                                                      bassBtn,
                                                      drumsBtn])
        stackBtn.axis = .horizontal
        stackBtn.distribution = .fillEqually
        stackBtn.spacing = 0
        view.addSubview(stackBtn)
        stackBtn.anchor(top: genresBtn.bottomAnchor, width: Constants.screenSize.width-20, height: 55)
        stackBtn.centerX(inView: view)
        stackBtn.isHidden = true
        
        
        addChardsView.backgroundColor = .purpleApp
        addChardsView.layer.cornerRadius = 15
        view.addSubview(addChardsView)
        
        addChardsView.anchor(top: stackBtn.bottomAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 20, width: Constants.screenSize.width/2-40, height: 88)
        
        let switchChards=UISwitch(frame:CGRect(x: 150, y: 150, width: 0, height: 0))
        switchChards.addTarget(self, action: #selector(switchChardsDidChange(_:)), for: .valueChanged)
        switchChards.setOn(true, animated: false)
        addChardsView.addSubview(switchChards)
        switchChards.anchor(left: addChardsView.leftAnchor, bottom: addChardsView.bottomAnchor, paddingLeft: 10, paddingBottom: 10)
        switchChards.backgroundColor = .purpleLightApp
        switchChards.onTintColor = .orangeApp
        switchChards.layer.cornerRadius = 15
        
        let titleChards = UILabel()
        titleChards.text = "Add chords"
        titleChards.font = UIFont(name: "Gilroy-SemiBold", size: 16)
        titleChards.textColor = .white
        
        addChardsView.addSubview(titleChards)
        titleChards.anchor(top: addChardsView.topAnchor, left: addChardsView.leftAnchor, paddingTop: 10, paddingLeft: 10)
        
        let imageName = "iconMusic1X"
        let imageChards = UIImage(named: imageName)
        let imageChardsView = UIImageView(image: imageChards!)
        addChardsView.addSubview(imageChardsView)
        imageChardsView.anchor(top: addChardsView.topAnchor, right: addChardsView.rightAnchor, paddingTop: 10, paddingRight: 10)
        
        
        let controlAiViewBg = UIView()
        controlAiViewBg.backgroundColor = UIColor(patternImage: UIImage(named: "AiControl2X1")!)
        view.addSubview(controlAiViewBg)
        controlAiViewBg.anchor(top: stackBtn.bottomAnchor, right: view.rightAnchor, paddingTop: 25, paddingRight: 20, width: 138, height: 32)
        let controlAiView = UIView()
        controlAiView.layer.cornerRadius = 15
        view.addSubview(controlAiView)
        
        controlAiView.anchor(top: stackBtn.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingRight: 20, width: 130, height: 88)
        let aiSlider = UISlider(frame: CGRect(x: 0,y: 40,width: 128,height: 31))
        aiSlider.minimumValue = 0
        aiSlider.maximumValue = 3
        aiSlider.isContinuous = true
        aiSlider.tintColor = UIColor.orangeApp
        aiSlider.value = 2
        controlAiView.addSubview(aiSlider)
        aiSlider.addTarget(self, action: #selector(self.sliderValueDidChange(_:)), for: .valueChanged)
        aiSlider.setThumbImage( UIImage(named: "Line1X"), for: .normal)
        
        
        
        
        let bgForCircleControlBPM = UIView()
        bgForCircleControlBPM.layer.cornerRadius = 80
        view.addSubview(bgForCircleControlBPM)
        //let image = UIImage(named: "knob_bpm1X")
        bgForCircleControlBPM.backgroundColor = UIColor(patternImage: UIImage(named: "knob_bpm1X")!)
        bgForCircleControlBPM.anchor(top: controlAiView.bottomAnchor, left: view.leftAnchor, paddingTop: -25, paddingLeft: 0, width: 200, height: 200)
        let v = GaugeSliderView()
        //v.backgroundColor = UIColor.purpleApp
        v.blankPathColor = UIColor.clear//(red: 218/255, green: 218/255, blue: 218/255, alpha: 1) //  -> inactive track color
        v.fillPathColor = UIColor.orangeApp//(red: 74/255, green: 196/255, blue: 192/255, alpha: 1) //  -> filled track color
        v.indicatorColor = UIColor.orangeApp//(red: 94/255, green: 187/255, blue: 169/255, alpha: 1)
        v.unitColor = UIColor.white//(red: 74/255, green: 74/255, blue: 74/255, alpha: 1)
        v.placeholderColor = UIColor.red//(red: 139/255, green: 154/255, blue: 158/255, alpha: 1)
        v.unitIndicatorColor = UIColor(red: 74/255, green: 74/255, blue: 74/255, alpha: 0.2)
        v.customControlColor = UIColor(red: 47/255, green: 190/255, blue: 169/255, alpha: 1)
        v.unitFont = UIFont(name: "Gilroy-SemiBold", size: 22)//UIFont(name: "Gilroy-ExtraBold.otf", size: 14)!//
        v.placeholderFont = UIFont.systemFont(ofSize: 0, weight: .medium)
        v.unitIndicatorFont = UIFont.systemFont(ofSize: 0, weight: .medium)
        v.customControlButtonTitle = ""
        v.isCustomControlActive = false
        v.customControlButtonVisible = false
        v.placeholder = ""
        v.unit = ""  //  -> change default unit from temperature to anything you like
        
        
        v.progress = 100 //  -> 0..100 a way to say percentage
        v.value = 20
        v.minValue = 0
        v.maxValue = 240
        v.countingMethod = GaugeSliderCountingMethod.easeInOut // -> sliding animation style
        v.delegationMode = .singular //  -> or .immediate(interval: Int)
        v.leftIcon = UIImage(named: "snowIcon")
        v.rightIcon = UIImage(named: "sunIcon")
        bgForCircleControlBPM.addSubview(v)
        //v.anchor(top: controlAiView.bottomAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 20, width: Constants.screenSize.width/2-40, height: 200)
        v.anchor(top: bgForCircleControlBPM.topAnchor , left: bgForCircleControlBPM.leftAnchor, paddingTop: 10, paddingLeft: 12, width: 168, height: 200)
        v.backgroundColor = .purpleApp
        //v.centerX(inView: bgForCircleControlBPM)
        v.onProgressChanged = { [weak self] progress in
            print("Progress: \(progress)")
            self?.bpmValue = progress*240/100
        }
        
        //TIMER
        /*let bgForCircleTimer = UIView()
         bgForCircleTimer.layer.cornerRadius = 80
         view.addSubview(bgForCircleTimer)
         bgForCircleTimer.backgroundColor = UIColor(patternImage: UIImage(named: "knob_bpm1X")!)
         bgForCircleTimer.anchor(top: controlAiView.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingRight: 0, width: Constants.screenSize.width/2-20, height: Constants.screenSize.width/2-20)
         */
        setupSliders()
        view.addSubview(generateBtn)
        view.addSubview(getSongsBtn)
        if UIDevice().userInterfaceIdiom == .phone {
            if UIScreen.main.nativeBounds.height < 1792 {
                generateBtn.anchor(top: bgForCircleControlBPM.bottomAnchor, left: view.leftAnchor, paddingTop: -15, paddingLeft: 20, width: Constants.screenSize.width-40, height: 60)
                getSongsBtn.anchor(top: bgForCircleControlBPM.bottomAnchor, left: view.leftAnchor, paddingTop: -15, paddingLeft: 20, width: Constants.screenSize.width-40, height: 60)
            } else {
                generateBtn.anchor(top: bgForCircleControlBPM.bottomAnchor, left: view.leftAnchor, paddingTop: (Constants.screenSize.height/8), paddingLeft: 20, width: Constants.screenSize.width-40, height: 60)
                getSongsBtn.anchor(top: bgForCircleControlBPM.bottomAnchor, left: view.leftAnchor, paddingTop: (Constants.screenSize.height/8), paddingLeft: 20, width: Constants.screenSize.width-40, height: 60)
            }
            
        }
        
        getSongsBtn.isHidden = true
        downloadBtn.isHidden = true
        shareBtn.isHidden = true
        generateBtn.isHidden = false
        
        
        createDownDesign()
        
        instrumentsCollectionView.backgroundColor = .clear
        instrumentsCollectionView.delegate = self
        instrumentsCollectionView.dataSource = self
        view.addSubview(instrumentsCollectionView)
        instrumentsCollectionView.anchor(top: genresBtn.bottomAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 0, width: Constants.screenSize.width, height: 56)
        // instrumentsCollectionView.centerX(inView: view)
        instrumentsCollectionView.isHidden = false
        
        
        //delete after all done
        
        /*let progressView = UIProgressView(progressViewStyle: .bar)
         progressView.center = view.center
         progressView.setProgress(5.0 , animated: true)
         progressView.trackTintColor = UIColor.darkGray
         progressView.tintColor = UIColor.purpleApp
         view.addSubview(progressView)
         progressView.anchor(top: generateBtn.bottomAnchor, left: view.leftAnchor, paddingTop: 5, paddingLeft: 20, width: Constants.screenSize.width-40, height: 60)
         progressView.addSubview(percentLoadLabel)
         percentLoadLabel.anchor(top: progressView.topAnchor, right: progressView.rightAnchor, paddingTop: 10, paddingRight: 20, width: 100, height: 50)
         percentLoadLabel.centerY(inView: progressView)
         
         progressView.addSubview(waitingLoadLabel)
         waitingLoadLabel.anchor(top: progressView.topAnchor, left: progressView.leftAnchor, paddingTop: 10, paddingLeft: 20, width: 200, height: 50)
         waitingLoadLabel.centerY(inView: progressView)
         waitingLoadLabel.font = waitingLoadLabel.font.withSize(25)
         percentLoadLabel.font = percentLoadLabel.font.withSize(25)
         var i = 0
         timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
         if i != 100 {
         i += 1
         }
         
         self.percentLoadLabel.text = "\(i) %"
         
         if self.waitingLoadLabel.text == "Waiting.." {
         self.waitingLoadLabel.text = "Waiting..."
         } else {
         
         self.waitingLoadLabel.text = "Waiting.."
         
         }
         }
         
         
         */
    }
    
    func play(file_name: String) {
        
        guard let soundURL = Bundle.main.url(forResource: "http://172.104.137.82/songs/\(file_name)", withExtension: "wav") else { return }
        
        do {
            
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            audioPlayer?.play()
            let percentage = (audioPlayer?.currentTime ?? 0)/(audioPlayer?.duration ?? 0)
            DispatchQueue.main.async {
                // do what ever you want with that "percentage"
                print("play")
            }
            
        } catch let error {
            audioPlayer = nil
        }
        
    }
    /*func showMidi(_ callback : @escaping (_ midi : MusicModel) -> Void){
     API.getMidi({
     res in
     if res.success {
     callback()
     }
     })
     }*/
    //TIMER PART
    func setupSliders() {
        // hours
        hoursCircularSlider.minimumValue = 0
        hoursCircularSlider.maximumValue = 5
        hoursCircularSlider.endPointValue = 3
        hoursCircularSlider.addTarget(self, action: #selector(updateHours), for: .valueChanged)
        hoursCircularSlider.addTarget(self, action: #selector(adjustHours), for: .editingDidEnd)
        
        // minutes
        minutesCircularSlider.minimumValue = 0
        minutesCircularSlider.maximumValue = 60
        minutesCircularSlider.endPointValue = 35
        minutesCircularSlider.addTarget(self, action: #selector(updateMinutes), for: .valueChanged)
        minutesCircularSlider.addTarget(self, action: #selector(adjustMinutes), for: .editingDidEnd)
        minutesCircularSlider.trackColor = .clear
        
        minutesCircularSlider.trackFillColor = .clear
        minutesCircularSlider.endThumbImage = (UIImage(named: "circleForSlider"))
        
        // minutesCircularSlider.endThumbImage?.rotate(radians: Float.pi * 2.0)
        let x = CGFloat(25)
        let y = CGFloat(0)
        var transform = CGAffineTransform(translationX: x, y: y)
        transform = transform.rotated(by: CGFloat(M_PI_4))
        transform = transform.translatedBy(x: -x,y: -y)
        
        viewForTimeSlider.anchor(top: addChardsView.bottomAnchor, right: view.rightAnchor, paddingTop: -40, paddingRight: 0, width: Constants.screenSize.width/2-20, height: Constants.screenSize.width/2-20)
        //minutesCircularSlider.endThumbImage?.frame.layer.transform = transform
        //  minutesCircularSlider.addTarget(self, action: #selector(self.sliderValueDidChange22(_:)), for: .valueChanged)
        
        //minutesCircularSlider.thumbRadius
        //.images.fra.transform = CGAffineTransform(rotationAngle: CGFloat(-M_PI_2))
        //ImageView.transform = ImageView.transform.rotated(by: .pi / 2)
        //minutesCircularSlider.addTarget(self, action: #selector(onSliderValChanged(slider:event:)), for: .valueChanged)
        
        //minutesCircularSlider.setThumbImage( UIImage(named: "Line1X"))
        hoursLabel.text = "0"
    }
    
    
    
    
    func instrumentBtnDisabled() {
        let image = UIImage(named: "pianoBtn")
        pianoBtn.setImage(image, for: .normal)
        let image2 = UIImage(named: "guitarBtn")
        guitarBtn.setImage(image2, for: .normal)
        let image3 = UIImage(named: "stringsBtn")
        stringsBtn.setImage(image3, for: .normal)
        let image4 = UIImage(named: "bassBtn")
        bassBtn.setImage(image4, for: .normal)
        let image5 = UIImage(named: "drumsBtn")
        drumsBtn.setImage(image5, for: .normal)
    }
    
    //MARK: - SELECTORS
    
    @objc func musicFontsBtnPressed(sender:UIButton) {
        print(sender.tag)
        instrumentsAvailableForCV.removeAll()
       
        for i in 0..<arrayMusicFonts.count {
            if i == sender.tag {
                print("arrayMusicFonts = \(arrayMusicFonts[i])")
                currentMusicFont = arrayMusicFonts[i]
                guard let strURL = URL(string: "http://147.182.236.169/fonts/instruments?font_type=\(arrayMusicFonts[i])") else { return }
                print("strURL = \(strURL)")
                
                //let headers: HTTPHeaders =  [ "id-token" : "\(self.idToken)"]
                
                AF.request( strURL, method: .get).responseJSON { response in
                    
                    switch (response.result) {
                    case .success(let json):
                       // print("success2 = \(json)")
                        
                        if let instrumentsAvailable = json as? [String] {
                            //print("instrumentsAvailable = \(instrumentsAvailable.first)")
                            let string = (instrumentsAvailable.first ?? "") as String
                            for i in 0..<self.instumentsArray.count {
                                let instrString = self.instumentsArray[i] as String
                            

                                if string.range(of:"\(instrString)", options: .caseInsensitive) != nil {
                                print("exists = \(instrString)")
                                    if instrString != "" {
                                        self.instrumentsAvailableForCV.append(instrString)
                                    }
                            }
                            }
                            
                            self.instrumentsCollectionView.reloadData()
                            self.contentView.removeFromSuperview()
                            self.scrollView.removeFromSuperview()
                        }
                       
                    case .failure(let error):
                        print(error)
                        print("error = \(error)")
                        self.instrumentsCollectionView.reloadData()
                        self.contentView.removeFromSuperview()
                        self.scrollView.removeFromSuperview()
                        let alert = UIAlertController(title: "We apologize", message: "Could not connect to the server. Check your network connection.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        
       
    }
    
    @objc func donateBtnPressed() {
        
        // self.window = UIWindow(frame: UIScreen.main.bounds)
        
        let donateScreen = DonateViewController()
        let myNavigationController = UINavigationController(rootViewController: donateScreen)
        myNavigationController.modalPresentationStyle = .fullScreen
        self.present(myNavigationController, animated: true)
        
        
    }
    
    @objc func shareBtnPressed() {
        let someText:String = "Hello want to share music link from BIT App"
        var newURLString = String()
        var objectsToShare: URL?
        if globalMidiUrl.isLatin && !globalMidiUrl.isBothLatinAndCyrillic {
            // String is latin
            print("isLatin = true")
            newURLString = globalMidiUrl.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
           // newURLString.encodeUrl
            objectsToShare = URL(string: newURLString)!
        } else if globalMidiUrl.isCyrillic  {
            // String is cyrillic
            print("isLatin = false")
        } else if globalMidiUrl.isBothLatinAndCyrillic {
            // String can be either latin or cyrillic
            print("isLatin = true and cyrillic = true")
        } else {
            // String is not latin nor cyrillic
            print("isLatin2 = true and cyrillic2 = true")
            newURLString = globalMidiUrl.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            let newNewStr = newURLString.encodeUrl
            let finishUrl = newNewStr.replacingOccurrences(of: "%25", with: "%", options: .literal, range: nil)
            objectsToShare = URL(string: finishUrl)!
        }
            //let objectsToShare:URL = URL(string: "\(globalMidiUrl)")!
            let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view

        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook,UIActivity.ActivityType.postToTwitter,UIActivity.ActivityType.mail]

            self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func instrumentsBtnPressed() {
        UIPickerInstruments.isHidden = false
        blackView.backgroundColor = .black
        blackView.alpha = 0.7
        view.addSubview(blackView)
        blackView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 0, width: Constants.screenSize.width, height: Constants.screenSize.height)
        UIPickerInstruments.delegate = self as UIPickerViewDelegate
        UIPickerInstruments.dataSource = self as UIPickerViewDataSource
        self.view.addSubview(UIPickerInstruments)
        UIPickerInstruments.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 0)
        UIPickerInstruments.centerX(inView: view)
        UIPickerInstruments.isHidden = false
        UIPickerInstruments.setValue(UIColor.orange, forKeyPath: "textColor")
    }
    
    @objc func sliderValueDidChange(_ sender:UISlider!)
    {
        print("Slider value changed")
        //clear all clicked instruments
        arrSelectedIndex.removeAll()
        arrSelectedData.removeAll()
        saveInstrumentsBtn.removeAll()
        saveInstrumentsBtnInt.removeAll()
        arrayMusicFonts.removeAll()
        
        // Use this code below only if you want UISlider to snap to values step by step
        let roundedStepValue = round(sender.value / step) * step
        sender.value = roundedStepValue
        
        print("Slider step value \(Int(roundedStepValue))")
        sliderStepAi = Int(roundedStepValue) + 1
        print("Slider step value2 = \(sliderStepAi)")
        let child = SpinnerLoaderView()

        // add the spinner view controller
        addChild(child)
        child.view.frame = view.frame
        view.addSubview(child.view)
        child.didMove(toParent: self)
        child.view.alpha = 0.1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            // then remove the spinner view controller
            if self.sliderStepAi == 3 || self.sliderStepAi == 4 {
                child.willMove(toParent: nil)
                child.view.removeFromSuperview()
                child.removeFromParent()
                self.instrumentsCollectionView.reloadData()
            }
            if self.sliderStepAi == 1 || self.sliderStepAi == 2 {
                
                guard let strURL = URL(string: "http://147.182.236.169/fonts") else { return }
                
                let headers: HTTPHeaders =  [ "id-token" : "\(self.idToken)"]

                AF.request( strURL, method: .get, headers: headers).responseJSON { response in
                    debugPrint(response)
                    
                    switch (response.result) {
                    case .success(let json):
                        print("success = \(json)")
                        
                               child.willMove(toParent: nil)
                               child.view.removeFromSuperview()
                               child.removeFromParent()
                        if let arrayFonts = json as? [String] {
                           
                            
                            self.arrayMusicFonts = arrayFonts
                           
                            self.view.addSubview( self.scrollView)
                            self.scrollView.addSubview( self.contentView)
                            
                            self.scrollView.centerXAnchor.constraint(equalTo:  self.view.centerXAnchor).isActive = true
                            self.scrollView.widthAnchor.constraint(equalTo:  self.view.widthAnchor).isActive = true
                            self.scrollView.topAnchor.constraint(equalTo:  self.view.topAnchor).isActive = true
                            self.scrollView.bottomAnchor.constraint(equalTo:  self.view.bottomAnchor).isActive = true
                            
                            self.contentView.centerXAnchor.constraint(equalTo:  self.scrollView.centerXAnchor).isActive = true
                            self.contentView.widthAnchor.constraint(equalTo:  self.scrollView.widthAnchor).isActive = true
                            self.contentView.topAnchor.constraint(equalTo:  self.scrollView.topAnchor).isActive = true
                            self.contentView.bottomAnchor.constraint(equalTo:  self.scrollView.bottomAnchor).isActive = true
                            self.contentView.anchor(top: self.scrollView.topAnchor, left: self.scrollView.leftAnchor, right: self.scrollView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingRight: 10, width: self.scrollView.frame.width, height: 40 + CGFloat(45*arrayFonts.count))
                        
                            self.scrollView.backgroundColor = .black
                            
                            
                            self.contentView.addSubview(self.label1)
                            self.label1.centerXAnchor.constraint(equalTo: self.contentView.centerXAnchor).isActive = true
                            self.label1.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
                            self.label1.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 3/4).isActive = true
                            self.label1.textAlignment = .center
                            self.label1.font = UIFont(name: "Gilroy-SemiBold", size: 18)
                            self.scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 40 + CGFloat(45*arrayFonts.count))
                            
                            
                           for i in 0..<arrayFonts.count {
                                
                                let button = AuthButton(type: .system)
                                self.musicFontsBtn.append(button)
                                self.musicFontsBtn[i].setTitle("\(arrayFonts[i])", for: .normal)
                                self.musicFontsBtn[i].titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
                                self.musicFontsBtn[i].titleLabel?.font = UIFont(name: "Gilroy-SemiBold", size: 12)
                                self.musicFontsBtn[i].setTitleColor(UIColor.orangeApp, for: .normal)
                                self.musicFontsBtn[i].tag = i
                                self.musicFontsBtn[i].addTarget(self, action: #selector(self.musicFontsBtnPressed), for: .touchUpInside)
                                self.contentView.addSubview(self.musicFontsBtn[i])
                                self.musicFontsBtn[i].anchor(top: self.contentView.topAnchor, left: self.contentView.leftAnchor, right: self.contentView.rightAnchor, paddingTop: 40 + CGFloat(45*i), paddingLeft: 10, paddingRight: 10, width: self.contentView.frame.width, height: 35)
                            }
                          
                            
                            
                        }
                    case .failure(let error):
                        print(error)
                        print("error = \(error)")
                        
                               child.willMove(toParent: nil)
                               child.view.removeFromSuperview()
                               child.removeFromParent()
                        let alert = UIAlertController(title: "We apologize", message: "Could not connect to the server. Check your network connection.", preferredStyle: UIAlertController.Style.alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            } else {
                self.instrumentsCollectionView.reloadData()
            }
        }
        
        
    }
    
    @objc func downloadBtnPressed() {
        print("wwww")
        createSpinnerView()
        
        var url = URL(string: globalMidiUrl)
        var newURLString = String()
        var finishUrl = String()
        if globalMidiUrl.isLatin && !globalMidiUrl.isBothLatinAndCyrillic {
            // String is latin
            print("isLatin = true")
           // finishUrl = globalMidiUrl.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            //url = URL(string: newURLString)!
        } else if globalMidiUrl.isCyrillic  {
            // String is cyrillic
            print("isLatin = false")
        } else if globalMidiUrl.isBothLatinAndCyrillic {
            // String can be either latin or cyrillic
            print("isLatin = true and cyrillic = true")
        } else {
            // String is not latin nor cyrillic
            print("isLatin2 = true and cyrillic2 = true")
            newURLString = globalMidiUrl.replacingOccurrences(of: " ", with: "%20", options: .literal, range: nil)
            let newNewStr = newURLString.encodeUrl
            finishUrl = newNewStr.replacingOccurrences(of: "%25", with: "%", options: .literal, range: nil)
            url = URL(string: finishUrl)!
        }
        // let downloadedURL = "https://s3.amazonaws.com/kargopolov/kukushka.mp3"
        //print(globalMidiUrl)
        if let audioUrl = URL(string: finishUrl) {
            // create your document folder url
            let documentsUrl = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            // your destination file url
            var destination = documentsUrl.appendingPathComponent(audioUrl.lastPathComponent)
            print(destination)
            // check if it exists before downloading it
            if FileManager.default.fileExists(atPath: destination.path) {
                print("The file already exists at path")
                self.messageForDownload = "The file already exists at path"
                
            } else {
                //  if the file doesn't exist
                //  just download the data from your url
                URLSession.shared.downloadTask(with: audioUrl, completionHandler: { (location, response, error) in
                    // after downloading your data you need to save it to your destination url
                    guard
                        let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                        let mimeType = response?.mimeType, mimeType.hasPrefix("audio"),
                        let location = location, error == nil
                    else { return }
                    do {
                        
                        
                        try FileManager.default.moveItem(at: location, to: destination)
                        print("MP3 file saved")
                        self.messageForDownload = "MP3 file saved to \(destination)"
                        url = destination
                        
                        
                    } catch {
                        print(error)
                    }
                }).resume()
            }
        }
        self.timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { timer in
            
            let alert = UIAlertController(title: "Download Status", message: self.messageForDownload, preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            var rv = URLResourceValues()
            print("self.midiFilename = \(self.midiFilename)")
            let fileName = self.mp3Filename.replacingOccurrences(of: "/", with: "-", options: NSString.CompareOptions.literal, range: nil)
            print("self.mp3Filename = \(fileName)")
            rv.name = "\(fileName).mp3"
            try? url!.setResourceValues(rv)
            //url!.setTemporaryResourceValue("newName.mp3", forKey: .nameKey)
            timer.invalidate()
        }
        
    }
    
    @objc func settingsPressed() {
        let settingsScreen = SettingsViewController()
        let myNavigationController = UINavigationController(rootViewController: settingsScreen)
        settingsScreen.delegate = self
        settingsScreen.modalPresentationStyle = .fullScreen
        self.present(myNavigationController, animated: true)
    }
    
    @objc func genresBtnPressed() {
        if self.sliderStepAi == 1 || self.sliderStepAi == 2 {
            let alert = UIAlertController(title: "Attention", message: "You can select genre only in ai3 or ai4 mode", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
            getSongsBtn.isHidden = true
            downloadBtn.isHidden = true
            shareBtn.isHidden = true
            generateBtn.isHidden = false
        } else {
            UIPicker.isHidden = false
            blackView.backgroundColor = .black
            blackView.alpha = 0.7
            view.addSubview(blackView)
            blackView.anchor(top: view.topAnchor, left: view.leftAnchor, paddingTop: 0, paddingLeft: 0, width: Constants.screenSize.width, height: Constants.screenSize.height)
            UIPicker.delegate = self as UIPickerViewDelegate
            UIPicker.dataSource = self as UIPickerViewDataSource
            self.view.addSubview(UIPicker)
            UIPicker.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, paddingTop: 20, paddingLeft: 0)
            UIPicker.centerX(inView: view)
            UIPicker.isHidden = false
            UIPicker.setValue(UIColor.orange, forKeyPath: "textColor")
            
            getSongsBtn.isHidden = true
            downloadBtn.isHidden = true
            shareBtn.isHidden = true
            generateBtn.isHidden = false
        }
        
    }
    
    @objc func pianoBtnPressed() {
        instrumentBtnDisabled()
        let image = UIImage(named: "pianoBtnPressed")
        pianoBtn.setImage(image, for: .normal)
    }
    
    @objc func guitarBtnPressed() {
        instrumentBtnDisabled()
        let image = UIImage(named: "guitarBtnPressed")
        guitarBtn.setImage(image, for: .normal)
    }
    
    @objc func stringsBtnPressed() {
        instrumentBtnDisabled()
        let image = UIImage(named: "stringsBtnPressed")
        stringsBtn.setImage(image, for: .normal)
    }
    
    @objc func bassBtnPressed() {
        instrumentBtnDisabled()
        let image = UIImage(named: "bassBtnPressed")
        bassBtn.setImage(image, for: .normal)
    }
    
    @objc func drumsBtnPressed() {
        instrumentBtnDisabled()
        let image = UIImage(named: "drumsBtnPressed")
        drumsBtn.setImage(image, for: .normal)
    }
    
    @objc func switchChardsDidChange(_ sender:UISwitch!)
    {
        if (sender.isOn == true){
            print("UISwitch state is now ON")
            switchChardsDidChange = true
        }
        else{
            print("UISwitch state is now Off")
            switchChardsDidChange = false
        }
    }
    @objc func generateBtnPressed() {
        if self.bpmValue < 80 {
            self.bpmValue = 80
        }
        print("bpmValue = \(self.bpmValue)")
        self.audioPlayers.player?.pause()
        self.audioPlayers.removeFromSuperview()
        self.percentLoadLabel.text = ""
        if self.sliderStepAi == 3 || self.sliderStepAi == 4 {
            print("self.sliderStepAi= \(self.sliderStepAi)")
            /*  let alert = UIAlertController(title: "Sorry", message: "ai3 and ai4 we are working to fix it now.", preferredStyle: UIAlertController.Style.alert)
             alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
             self.present(alert, animated: true, completion: nil)*/
            // picker controller
            /* let audiopicker = MPMediaPickerController(mediaTypes: .anyAudio)
             audiopicker.prompt = "Audio"
             audiopicker.delegate = self
             audiopicker.allowsPickingMultipleItems = false
             self.present(audiopicker, animated: true, completion: nil)*/
            
            var allSeconds = 0
            if hoursLabel.text != "0" {
                let seconds = Int(minutesLabel.text!)
                let hours = Int(hoursLabel.text!)
                allSeconds = hours!*60+seconds!
            } else {
                allSeconds = Int(minutesLabel.text!)!
            }
            print("allSeconds = \(allSeconds)")
            globalSeconds = allSeconds
            
            var add_chords = [Int]()
            if saveInstrumentsBtnInt.count == 1 {
                add_chords = [1]
            }
            if saveInstrumentsBtnInt.count == 2 {
                add_chords = [1,2]
            }
            if saveInstrumentsBtnInt.count == 3 {
                add_chords = [1,2,3]
            }
            if saveInstrumentsBtnInt.count == 4 {
                add_chords = [1,2,3,4]
            }
            if saveInstrumentsBtnInt.count == 5 {
                add_chords = [1,2,3,4,5]
            }
            var track_1 = 0
            var track_2 = 0
            var track_3 = 0
            var track_4 = 0
            var track_5 = 0
            
            
            if saveInstrumentsBtnInt.count == 1 { track_1 = saveInstrumentsBtnInt[0] }
            if saveInstrumentsBtnInt.count == 2
            {   track_1 = saveInstrumentsBtnInt[0]
                track_2 = saveInstrumentsBtnInt[1]
            }
            if saveInstrumentsBtnInt.count == 3
            {
                track_1 = saveInstrumentsBtnInt[0]
                track_2 = saveInstrumentsBtnInt[1]
                track_3 = saveInstrumentsBtnInt[2]
            }
            if saveInstrumentsBtnInt.count == 4
            {
                track_1 = saveInstrumentsBtnInt[0]
                track_2 = saveInstrumentsBtnInt[1]
                track_3 = saveInstrumentsBtnInt[2]
                track_4 = saveInstrumentsBtnInt[3]
            }
            if saveInstrumentsBtnInt.count == 5
            {
                track_1 = saveInstrumentsBtnInt[0]
                track_2 = saveInstrumentsBtnInt[1]
                track_3 = saveInstrumentsBtnInt[2]
                track_4 = saveInstrumentsBtnInt[3]
                track_5 = saveInstrumentsBtnInt[4]
                
            }
            
            
            let json: [String: Any] = ["change_instruments": [
                "track_1": track_1,
                "track_2": track_2,
                "track_3": track_3,
                "track_4": track_4,
                "track_5": track_5
            ],
            "add_chords": add_chords, "add_drums": true, "set_bpm": self.bpmValue, "modify_length": globalSeconds, "genre": "\(self.genres)"]
            print("json = \(json)")
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            // create post request
            print("sliderStepAi = \(sliderStepAi)")
            let url = URL(string: "http://147.182.236.169/songs?gen_type=ai\(self.sliderStepAi)")!
           
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("\(idToken)", forHTTPHeaderField: "id-token")
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                
                if let responseJSON = responseJSON as? [String: Any] {
                    print("responseJSON = \(responseJSON)")
                }
            }
            
            let progressView = UIProgressView(progressViewStyle: .bar)
            progressView.center = self.view.center
            progressView.setProgress(5.0 , animated: true)
            progressView.trackTintColor = UIColor.darkGray
            progressView.tintColor = UIColor.purpleApp
            self.view.addSubview(progressView)
            progressView.anchor(top: self.generateBtn.bottomAnchor, left: self.view.leftAnchor, paddingTop: 30, paddingLeft: 20, width: Constants.screenSize.width-40, height: 60)
            progressView.addSubview(self.percentLoadLabel)
            self.percentLoadLabel.anchor(top: progressView.topAnchor, right: progressView.rightAnchor, paddingTop: 10, paddingRight: 20, width: 100, height: 50)
            self.percentLoadLabel.centerY(inView: progressView)
            
            progressView.addSubview(self.waitingLoadLabel)
            self.waitingLoadLabel.anchor(top: progressView.topAnchor, left: progressView.leftAnchor, paddingTop: 10, paddingLeft: 20, width: 200, height: 50)
            self.waitingLoadLabel.centerY(inView: progressView)
            self.waitingLoadLabel.font = self.waitingLoadLabel.font.withSize(25)
            self.percentLoadLabel.font = self.percentLoadLabel.font.withSize(25)
            self.percentLoadLabel.isHidden = false
            self.waitingLoadLabel.isHidden = false
            var i = 50
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if i != 100 {
                    i += 2
                }
                
                //  self.percentLoadLabel.text = "\(i) %"
                
                if self.waitingLoadLabel.text == "Waiting.." {
                    self.waitingLoadLabel.text = "Waiting..."
                } else {
                    
                    self.waitingLoadLabel.text = "Waiting.."
                    
                }
            }
            self.generateBtn.isHidden = true
            self.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                
                // self.percentLoadLabel.text = "100 %"
                self.waitingLoadLabel.text = "Complete"
                
                self.getSongsBtn.isHidden = false
                self.downloadBtn.isHidden = true
                self.shareBtn.isHidden = true
                
                progressView.removeFromSuperview()
                timer.invalidate()
            }
            
            task.resume()
            
            
        }
        if self.sliderStepAi == 1 || self.sliderStepAi == 2 {
            
            var allSeconds = 0
            if hoursLabel.text != "0" {
                let seconds = Int(minutesLabel.text!)
                let hours = Int(hoursLabel.text!)
                allSeconds = hours!*60+seconds!
            } else {
                allSeconds = Int(minutesLabel.text!)!
            }
            print("allSeconds = \(allSeconds)")
            globalSeconds = allSeconds
            
            var add_chords = [Int]()
            if saveInstrumentsBtnInt.count == 1 {
                add_chords = [1]
            }
            if saveInstrumentsBtnInt.count == 2 {
                add_chords = [1,2]
            }
            if saveInstrumentsBtnInt.count == 3 {
                add_chords = [1,2,3]
            }
            if saveInstrumentsBtnInt.count == 4 {
                add_chords = [1,2,3,4]
            }
            if saveInstrumentsBtnInt.count == 5 {
                add_chords = [1,2,3,4,5]
            }
            var track_1 = 0
            var track_2 = 0
            var track_3 = 0
            var track_4 = 0
            var track_5 = 0
            
            
            if saveInstrumentsBtnInt.count == 1 { track_1 = saveInstrumentsBtnInt[0] }
            if saveInstrumentsBtnInt.count == 2
            {   track_1 = saveInstrumentsBtnInt[0]
                track_2 = saveInstrumentsBtnInt[1]
            }
            if saveInstrumentsBtnInt.count == 3
            {
                track_1 = saveInstrumentsBtnInt[0]
                track_2 = saveInstrumentsBtnInt[1]
                track_3 = saveInstrumentsBtnInt[2]
            }
            if saveInstrumentsBtnInt.count == 4
            {
                track_1 = saveInstrumentsBtnInt[0]
                track_2 = saveInstrumentsBtnInt[1]
                track_3 = saveInstrumentsBtnInt[2]
                track_4 = saveInstrumentsBtnInt[3]
            }
            if saveInstrumentsBtnInt.count == 5
            {
                track_1 = saveInstrumentsBtnInt[0]
                track_2 = saveInstrumentsBtnInt[1]
                track_3 = saveInstrumentsBtnInt[2]
                track_4 = saveInstrumentsBtnInt[3]
                track_5 = saveInstrumentsBtnInt[4]
                
            }
            // prepare json data
            var json: [String: Any]
            if instrumentsAvailableForCV.count > 0 {
                json = ["change_instruments": [
                    "track_1": track_1,
                    "track_2": track_2,
                    "track_3": track_3,
                    "track_4": track_4,
                    "track_5": track_5
                ],
                "add_chords": add_chords, "add_drums": true, "set_bpm": self.bpmValue, "modify_length": globalSeconds, "genre": "pop", "soundfonts": "\(currentMusicFont)"]
            } else {
                json = ["change_instruments": [
                    "track_1": track_1,
                    "track_2": track_2,
                    "track_3": track_3,
                    "track_4": track_4,
                    "track_5": track_5
                ],
                "add_chords": add_chords, "add_drums": true, "set_bpm": self.bpmValue, "modify_length": globalSeconds, "genre": "pop"]
            }
            
            print("json = \(json)")
            
            let jsonData = try? JSONSerialization.data(withJSONObject: json)
            
            // create post request
            print("sliderStepAi = \(sliderStepAi)")
            let url = URL(string: "http://147.182.236.169/songs?gen_type=ai\(self.sliderStepAi)")!
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("\(idToken)", forHTTPHeaderField: "id-token")
            
            // insert json data to the request
            request.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                guard let data = data, error == nil else {
                    print(error?.localizedDescription ?? "No data")
                    return
                }
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                
                if let responseJSON = responseJSON as? [String: Any] {
                    print("responseJSON = \(responseJSON)")
                }
            }
            
            task.resume()
            
            let progressView = UIProgressView(progressViewStyle: .bar)
            progressView.center = self.view.center
            progressView.setProgress(5.0 , animated: true)
            progressView.trackTintColor = UIColor.darkGray
            progressView.tintColor = UIColor.purpleApp
            self.view.addSubview(progressView)
            progressView.anchor(top: self.generateBtn.bottomAnchor, left: self.view.leftAnchor, paddingTop: 30, paddingLeft: 20, width: Constants.screenSize.width-40, height: 60)
            progressView.addSubview(self.percentLoadLabel)
            self.percentLoadLabel.anchor(top: progressView.topAnchor, right: progressView.rightAnchor, paddingTop: 10, paddingRight: 20, width: 100, height: 50)
            self.percentLoadLabel.centerY(inView: progressView)
            
            progressView.addSubview(self.waitingLoadLabel)
            self.waitingLoadLabel.anchor(top: progressView.topAnchor, left: progressView.leftAnchor, paddingTop: 10, paddingLeft: 20, width: 200, height: 50)
            self.waitingLoadLabel.centerY(inView: progressView)
            self.waitingLoadLabel.font = self.waitingLoadLabel.font.withSize(25)
            self.percentLoadLabel.font = self.percentLoadLabel.font.withSize(25)
            self.percentLoadLabel.isHidden = false
            self.waitingLoadLabel.isHidden = false
            var i = 50
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
                if i != 100 {
                    i += 2
                }
                
                //  self.percentLoadLabel.text = "\(i) %"
                
                if self.waitingLoadLabel.text == "Waiting.." {
                    self.waitingLoadLabel.text = "Waiting..."
                } else {
                    
                    self.waitingLoadLabel.text = "Waiting.."
                    
                }
            }
            self.generateBtn.isHidden = true
            self.timer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { timer in
                
                // self.percentLoadLabel.text = "100 %"
                self.waitingLoadLabel.text = "Complete"
                
                self.getSongsBtn.isHidden = false
                self.downloadBtn.isHidden = true
                self.shareBtn.isHidden = true
                
                progressView.removeFromSuperview()
                timer.invalidate()
            }
        }
        
        
    }
    var audioPlayers = AudioPlayerView()
    
    @objc func getSongsBtnPressed() {
        print("getSongs BTN")
        
        
        // guard let strURL = URL(string: "http://147.182.236.169/songs?gen_type=ai\(self.sliderStepAi)") else { return }
        // for get songs
        guard let strURL = URL(string: "http://147.182.236.169/songs") else { return }
        print("strURL = \(strURL)")
        
        let headers: HTTPHeaders =  [ "id-token" : "\(self.idToken)"]
        //let params2 =  ["add_chords": [], "add_drums": true, "set_bpm": 180, "modify_length": 120, "genre": "blues"] as [String : Any]
        let params = [
            "change_instruments": [
                "track_1": 0,
                "track_2": 0,
                "track_3": 0,
                "track_4": 0,
                "track_5": 0
            ],
            "add_chords": [],
            "add_drums": true,
            "set_bpm": self.bpmValue,
            "modify_length": 60,
            "genre": "\(self.genres)"
        ] as [String : Any]
        print("params = \(params) \(self.genres)")
        /*let params = [
         "add_drums": true,
         "set_bpm": self.bpmValue,
         "modify_length": 130,
         "genre": "\(self.genres)"
         ] as [String : Any]*/
        self.percentLoadLabel.text = ""
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.center = self.view.center
        progressView.setProgress(5.0 , animated: true)
        progressView.trackTintColor = UIColor.darkGray
        progressView.tintColor = UIColor.purpleApp
        self.view.addSubview(progressView)
        progressView.anchor(top: self.generateBtn.bottomAnchor, left: self.view.leftAnchor, paddingTop: 30, paddingLeft: 20, width: Constants.screenSize.width-40, height: 60)
        progressView.addSubview(self.percentLoadLabel)
        self.percentLoadLabel.anchor(top: progressView.topAnchor, right: progressView.rightAnchor, paddingTop: 10, paddingRight: 20, width: 100, height: 50)
        self.percentLoadLabel.centerY(inView: progressView)
        
        progressView.addSubview(self.waitingLoadLabel)
        self.waitingLoadLabel.anchor(top: progressView.topAnchor, left: progressView.leftAnchor, paddingTop: 10, paddingLeft: 20, width: 200, height: 50)
        self.waitingLoadLabel.centerY(inView: progressView)
        self.waitingLoadLabel.font = self.waitingLoadLabel.font.withSize(25)
        self.percentLoadLabel.font = self.percentLoadLabel.font.withSize(25)
        self.percentLoadLabel.isHidden = false
        self.waitingLoadLabel.isHidden = false
        var i = 0
        self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { timer in
            if i != 100 {
                i += 1
            }
            
            self.percentLoadLabel.text = "\(i) %"
            
            if self.waitingLoadLabel.text == "Waiting.." {
                self.waitingLoadLabel.text = "Waiting..."
            } else {
                
                self.waitingLoadLabel.text = "Waiting.."
                
            }
        }
        
        
        AF.request( strURL, method: .get, headers: headers).responseJSON { response in
            debugPrint(response)
            
            //  print("data =\(response.response)")
            switch (response.result) {
            case .success(let json):
                
                if let arry = json as? [[String:Any]] {
                    for dictionary in arry {
                        print("fileName =\(dictionary)")
                        print(dictionary["output_midi_filename"]!)
                        self.midiFilename = dictionary["file_name"] as! String
                        self.mp3Filename = dictionary["file_name"] as! String
                        print(dictionary["uid"]!)
                        print("http://147.182.236.169/files?file_name=data%2Fresults%\(self.midiFilename)")
                    }
                }
                globalMidiUrl = "http://147.182.236.169/files?file_name=%2Fapp%2Fdata%2Fresults%2F\(self.midiFilename)_midi_to_mp3.mp3"
                //self.timer?.invalidate()
                //http://147.182.236.169/files?file_name=%2Fapp%2Fdata%2Fresults%2Fdmitrykartini%2Fai2_100_rock_12-09-2021-20-34-33_midi_to_mp3.mp3
                
                //http://147.182.236.169/files?file_name=%2Fapp%2Fdata%2Fresults%2FWH2OrrClocO7ZiF8Jq8muUmSjse2/ai1_180_country_13-09-2021-05-56-27_midi_to_mp3.mp3
                let player = AudioPlayerView()
                self.audioPlayers = player
              
                print("url midi track =\(globalMidiUrl)")
                player.delegate = self
                self.view.addSubview(player)
                
                player.player?.pause()
                let image = UIImage(named: "play1X")
                player.playButton.setImage(image, for: .normal)
                player.anchor(top: self.barDown.topAnchor, paddingTop: -20, width: Constants.screenSize.width-40, height: 70)
                player.centerX(inView: self.view)
                
                self.donateBtn.removeFromSuperview()
                self.shareBtn.removeFromSuperview()
                self.downloadBtn.removeFromSuperview()
                self.view.addSubview(self.downloadBtn)
                self.downloadBtn.anchor(top: self.barDown.topAnchor, left: self.view.leftAnchor, paddingTop: 0, paddingLeft: 50, width: 80, height: 80)
                self.downloadBtn.isHidden = true
                
                self.view.addSubview(self.shareBtn)
                self.shareBtn.anchor(top: self.barDown.topAnchor, left: self.view.leftAnchor, paddingTop: 15, paddingLeft: 120, width: 50, height: 50)
                self.shareBtn.isHidden = true
                self.view.addSubview(self.donateBtn)
                self.donateBtn.anchor(top: self.barDown.topAnchor, right: self.view.rightAnchor, paddingTop: 0, paddingLeft: 50, width: 80, height: 80)
                
                // self.createDownDesign()
                self.generateBtn.isHidden = false
                self.waitingLoadLabel.text = "Complete"
                self.percentLoadLabel.text = "100%"
                progressView.removeFromSuperview()
                self.downloadBtn.isHidden = false
                self.shareBtn.isHidden = false
                self.timer?.invalidate()
                
            case .failure(let error):
                print("error = \(error)")
                let alert = UIAlertController(title: "We apologize", message: "Could not connect to the server. Check your network connection.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                self.generateBtn.isHidden = false
                self.percentLoadLabel.text = "0%"
                progressView.removeFromSuperview()
                self.timer?.invalidate()
            }
            
        }
        self.getSongsBtn.isHidden = true
        
    }
    
    
    
    
    // MARK: user interaction methods
    
    @objc func updateHours() {
        var selectedHour = Int(hoursCircularSlider.endPointValue)
        // TODO: use date formatter
        selectedHour = (selectedHour == 0 ? 6 : selectedHour)
        hoursLabel.text = String(format: "%02d", selectedHour)
    }
    
    @objc func adjustHours() {
        let selectedHour = round(hoursCircularSlider.endPointValue)
        hoursCircularSlider.endPointValue = selectedHour
        updateHours()
    }
    var hourDefoult = 0
    var hourDefoultCheck = false
    @objc func fireTimer() {
        print("Timer fired!")
        hourDefoultCheck = false
    }
    @objc func updateMinutes() {
        var selectedHour = Int(hoursCircularSlider.endPointValue)
        var selectedMinute = Int(minutesCircularSlider.endPointValue)
        // TODO: use date formatter
        
        if selectedMinute >= 55 && selectedMinute <= 60  {
            //selectedHour = selectedHour + 1
            if hourDefoultCheck == false {
                let timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: false)
                hourDefoult += 1
                print("www done = \(hourDefoult)")
            }
            
            hourDefoultCheck = true
        }
        hourDefoult = (hourDefoult == 05 ? 0 : hourDefoult)
        selectedMinute = (selectedMinute == 60 ? 0 : selectedMinute)
        
        minutesLabel.text = String(format: "%02d", selectedMinute)
        hoursLabel.text = String(format: "%02d", hourDefoult)
        print(" minutesLabel.text = \( selectedMinute)")
        print(" hoursLabel.text = \( hourDefoult)")
    }
    
    @objc func adjustMinutes() {
        let selectedMinute = round(minutesCircularSlider.endPointValue)
        minutesCircularSlider.endPointValue = selectedMinute
        updateMinutes()
    }
    
    //COLLECTION VIEW
    var imagescv = ["cv1","cv2","cv3","cv4","cv5"]
    
    
    
    
    
}

extension MainViewController:  UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var count = 0
        if pickerView == UIPickerInstruments {
            count = instumentsArray.count
        }
        if pickerView == UIPicker {
            count = genresArray.count
        }
        return count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var row2 = String()
        if pickerView == UIPickerInstruments {
            row2 = instumentsArray[row]
        }
        if pickerView == UIPicker {
            row2 = genresArray[row]
        }
        
        
        return row2
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == UIPickerInstruments {
            let current = instumentsArray[row]
            print(current)
            instrumentsBtn.setTitle(current, for: .normal)
            UIPickerInstruments.isHidden = true
            UIPickerInstruments.removeFromSuperview()
        }
        if pickerView == UIPicker {
            let current = genresArray[row]
            print(current)
            genresBtn.setTitle(current, for: .normal)
            UIPicker.isHidden = true
            UIPicker.removeFromSuperview()
            genres = current
        }
        blackView.removeFromSuperview()
    }
    
    
    
}

extension MainViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if self.sliderStepAi == 1 || self.sliderStepAi == 2 {
            return instrumentsAvailableForCV.count
        } else {
            return Instruments.allCases.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! InstrumentsCollectionViewCell
        //if collectionView == instrumentsCollectionView {
        if self.sliderStepAi == 1 || self.sliderStepAi == 2 {
            cell.instrumentLabel.text = "\(instrumentsAvailableForCV[indexPath.row])"
        } else {
            cell.instrumentLabel.text = "\(Instruments.statusList[indexPath.row])"
        }
       
        cell.addShadow()
        //cell.instrumentLabel.frame.width = self.sizeWidthCellInstruments.width
        //   cell.frame.width = self.sizeWidthCellInstruments.width
        //  cell.frame.height = 30
        
        cell.tag = indexPath.row
        
        /* for i in 0..<saveInstrumentsBtn.count {
         if self.saveInstrumentsBtn[i].tag == cell.tag {
         cell.backgroundColor = .orangeApp
         } else {
         cell.backgroundColor = .purpleApp
         }
         }*/
        if arrSelectedIndex.contains(indexPath) { // You need to check wether selected index array contain current index if yes then change the color
            cell.backgroundColor = UIColor.orangeApp
        }
        else {
            cell.backgroundColor = UIColor.purpleApp
        }
       /* if self.sliderStepAi == 1 || self.sliderStepAi == 2 {
            for i in 0..<instrumentsAvailableForCV.count {
                if cell.instrumentLabel.text == instrumentsAvailableForCV[i] {
                    cell.isHidden = false
                } else {
                    cell.isHidden = true
                    cell.frame.size.width = 0
                }
            }
        }
        if self.sliderStepAi == 3 || self.sliderStepAi == 4 {
           // for i in 0..<instrumentsAvailableForCV.count {
                cell.isHidden = false
           // cell.frame.size.width = 100
          //  }
        }*/
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("User tapped on item \(indexPath.row)")
        
        print("You selected cell #\(indexPath.item)!")
        var strData = String()
        if self.sliderStepAi == 1 || self.sliderStepAi == 2 {
             strData = instrumentsAvailableForCV[indexPath.item]
        } else {
             strData = Instruments.statusList[indexPath.item]
        }
       
        for i in 0..<saveInstrumentsBtn.count {
            if saveInstrumentsBtn[i] == strData {
                saveInstrumentsBtn.remove(at: i)
                saveInstrumentsBtnInt.remove(at: i)
                break
            }
        }
        if arrSelectedIndex.count == 5 {
            arrSelectedIndex.removeAll()
            arrSelectedData.removeAll()
            saveInstrumentsBtn.removeAll()
            saveInstrumentsBtnInt.removeAll()
            if arrSelectedIndex.contains(indexPath) {
                arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
                arrSelectedData = arrSelectedData.filter { $0 != strData}
            }
            else {
                arrSelectedIndex.append(indexPath)
                arrSelectedData.append(strData)
                if self.sliderStepAi == 1 || self.sliderStepAi == 2 {
                    saveInstrumentsBtn.append("\(instrumentsAvailableForCV[indexPath.item])")
                } else {
                    saveInstrumentsBtn.append("\(Instruments.statusList[indexPath.item])")
                }
                
                saveInstrumentsBtnInt.append(indexPath.item+1)
            }
        } else {
            if arrSelectedIndex.contains(indexPath) {
                arrSelectedIndex = arrSelectedIndex.filter { $0 != indexPath}
                arrSelectedData = arrSelectedData.filter { $0 != strData}
            }
            else {
                arrSelectedIndex.append(indexPath)
                arrSelectedData.append(strData)
                if self.sliderStepAi == 1 || self.sliderStepAi == 2 {
                    saveInstrumentsBtn.append("\(instrumentsAvailableForCV[indexPath.item])")
                } else {
                    saveInstrumentsBtn.append("\(Instruments.statusList[indexPath.item])")
                }
                //saveInstrumentsBtn.append("\(Instruments.statusList[indexPath.item])")
                saveInstrumentsBtnInt.append(indexPath.item+1)
            }
        }
        
        print(saveInstrumentsBtn)
        print(saveInstrumentsBtnInt)
        collectionView.reloadData()
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        //print(self.sizeWidthCellInstruments[indexPath.row].width+20)
        return CGSize(width: self.sizeWidthCellInstruments[indexPath.row].width+20, height: 30)
    }
    
    /*  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
     {
     return UIEdgeInsets(top: 20, left: 8, bottom: 5, right: 8)
     }*/
}

extension MainViewController: SettingsViewControllerDelegate {
    func logoutUserToMVC() {
        logoutUser()
        self.view.window!.rootViewController?.dismiss(animated: false, completion: nil)
        let vc = LoginViewController()
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true, completion: nil)
    }
    
    
}
extension MainViewController: AudioPlayerViewDelegate {
    func audioCheckGlobal() {
        let alert = UIAlertController(title: "We apologize", message: "Something went wrong. Check your network connection.", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
}


extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}



