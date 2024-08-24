//
//  SwapVideoDetailVC.swift
//  FutureLove
//
//  Created by khongtinduoc on 11/4/23.
//

import UIKit
import TrailerPlayer
import HGCircularSlider
import Kingfisher
import Vision

class SwapVideoDetailVC: UIViewController {
    var itemLink:Temple2VideoModel = Temple2VideoModel()
    @IBOutlet weak var buttonBack: UIButton!
    @IBOutlet weak var continueLabel: UIButton!

    var IsStopBoyAnimation = true
  //  @IBOutlet weak var boyImage: UIImageView!
    var image_Data_Nam:UIImage = UIImage()
    var linkImageVideoSwap:String = ""
  //  @IBOutlet weak var circularSlider: CircularSlider!
   // @IBOutlet weak var timerLabel: UILabel!
  //  @IBOutlet weak var percentLabel: UILabel!
    let dateComponentsFormatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad
        formatter.allowedUnits = [.minute, .second]
        return formatter
    }()
    @AutoLayout
    private var playerView: TrailerPlayerView = {
        let view = TrailerPlayerView()
        view.enablePictureInPicture = true
        return view
    }()
    private let autoPlay = false
    private let autoReplay = false
    @AutoLayout
    private var controlPanel: ControlPanel = {
        let view = ControlPanel()
        return view
    }()
    
    @AutoLayout
    private var replayPanel: ReplayPanel = {
        let view = ReplayPanel()
        return view
    }()
    
    @IBAction func BackApp(){
        self.dismiss(animated: true)
    }
    @IBAction func nextdd(){
                let vc = swapvideo2(nibName: "swapvideo2", bundle: nil)
        print(self.itemLink.id)
        vc.itemLink=self.itemLink
                vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                self.present(vc, animated: true, completion: nil)
    }
    
    var timerNow: Timer = Timer()
    func uploadGenVideoByImages(completion: @escaping ApiCompletion){
        APIService.shared.UploadImagesToGenRieng("https://api.funface.online/upload-gensk/" + String(AppConstant.userId ?? 0) + "?type=src_vid", ImageUpload: self.image_Data_Nam,method: .POST, loading: true){data,error in
            completion(data, nil)
        }
    }

    
    @objc func imageBoyTapped(_ sender: UITapGestureRecognizer) {
        let refreshAlert = UIAlertController(title: "Use Old Images Uploaded", message: "Do You Want Select Old Images For AI Generate Images", preferredStyle: UIAlertController.Style.alert)
        refreshAlert.addAction(UIAlertAction(title: "Load Old Images", style: .default, handler: { (action: UIAlertAction!) in
            let vc = ListImageOldVC(nibName: "ListImageOldVC", bundle: nil)
            vc.type = "video"
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        }))
        refreshAlert.addAction(UIAlertAction(title: "Upload Image New", style: .cancel, handler: { (action: UIAlertAction!) in
            var alertStyle = UIAlertController.Style.actionSheet
            if (UIDevice.current.userInterfaceIdiom == .pad) {
                alertStyle = UIAlertController.Style.alert
            }
            let ac = UIAlertController(title: "Select Image", message: "Select image from", preferredStyle: alertStyle)
            let cameraBtn = UIAlertAction(title: "Camera", style: .default) {_ in
                self.IsStopBoyAnimation = true
                self.showImagePicker(selectedSource: .camera)
            }
            let libaryBtn = UIAlertAction(title: "Libary", style: .default) { _ in
                self.IsStopBoyAnimation = true
                self.showImagePicker(selectedSource: .photoLibrary)
            }
                //them
            let libaryBtn1 = UIAlertAction(title: "Libary11", style: .default) { _ in
                let storyboard = UIStoryboard(name: "mhchinh", bundle: nil)
                let vc = storyboard.instantiateViewController(withIdentifier: "mhtestViewController") as! mhtestViewController
                vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
                self.present(vc, animated: true, completion: nil)
            }
            let libaryBtn2 = UIAlertAction(title: "Libary", style: .default) { _ in
                self.IsStopBoyAnimation = true
                self.showImagePicker(selectedSource: .photoLibrary)
            }
            let libaryBtn3 = UIAlertAction(title: "Libary", style: .default) { _ in
                self.IsStopBoyAnimation = true
                self.showImagePicker(selectedSource: .photoLibrary)
            }
            let libaryBtn4 = UIAlertAction(title: "Libary", style: .default) { _ in
                self.IsStopBoyAnimation = true
                self.showImagePicker(selectedSource: .photoLibrary)
            }
            let libaryBtn5 = UIAlertAction(title: "Libary", style: .default) { _ in
                self.IsStopBoyAnimation = true
                self.showImagePicker(selectedSource: .photoLibrary)
            }
            let libaryBtn6 = UIAlertAction(title: "Libary", style: .default) { _ in
                self.IsStopBoyAnimation = true
                self.showImagePicker(selectedSource: .photoLibrary)
            }
            let libaryBtn7 = UIAlertAction(title: "Libary", style: .default) { _ in
                self.IsStopBoyAnimation = true
                self.showImagePicker(selectedSource: .photoLibrary)
            }
            let libaryBtn8 = UIAlertAction(title: "Libary", style: .default) { _ in
                self.IsStopBoyAnimation = true
                self.showImagePicker(selectedSource: .photoLibrary)
            }
            //them
            let cancel = UIAlertAction(title: "Cancel", style: .cancel){ _ in
                self.dismiss(animated: true)
            }
            ac.addAction(cameraBtn)
            ac.addAction(libaryBtn)
            ac.addAction(libaryBtn1)
            ac.addAction(libaryBtn2)
            ac.addAction(libaryBtn3)
            ac.addAction(libaryBtn4)
            ac.addAction(libaryBtn5)
            ac.addAction(libaryBtn6)
            ac.addAction(libaryBtn7)
            ac.addAction(libaryBtn8)
            ac.addAction(cancel)
            
            self.present(ac, animated: true)
        }))
        present(refreshAlert, animated: true, completion: nil)
    }
    func updatePlayerUI(withCurrentTime currentTime: CGFloat) {
     //   circularSlider.endPointValue = currentTime
        var components = DateComponents()
        components.second = Int(currentTime)
       // timerLabel.text = dateComponentsFormatter.string(from: components)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        continueLabel.setTitle("    Use this video", for: .normal)
        continueLabel.titleLabel?.font = .quickSandBold(size: 14)
        continueLabel.layer.cornerRadius = 10
        continueLabel.layer.masksToBounds = true
        
//        NotificationCenter.default.addObserver(self, selector: #selector(Send_OLD_Images_Click), name: NSNotification.Name(rawValue: "Notification_SEND_IMAGES"), object: nil)

        self.buttonBack.setTitle("", for: UIControl.State.normal)
      //  circularSlider.endPointValue = 0
        buttonBack.setTitle("", for: .normal)
        view.addSubview(playerView)
        playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        playerView.heightAnchor.constraint(equalTo: playerView.widthAnchor, multiplier: 0.65).isActive = true
        if #available(iOS 11.0, *) {
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80).isActive = true
        } else {
            playerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        }
        
       // let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageBoyTapped(_:)))
      //  boyImage.addGestureRecognizer(tapGesture)
      //  boyImage.isUserInteractionEnabled = true
        
        controlPanel.delegate = self
        playerView.addControlPanel(controlPanel)
        
        if !autoReplay {
            replayPanel.delegate = self
            playerView.addReplayPanel(replayPanel)
        }
        
        if !autoPlay {
            let button = UIButton()
            button.tintColor = .white
            button.setImage(UIImage(named: "play")?.withRenderingMode(.alwaysTemplate), for: .normal)
            playerView.manualPlayButton = button
        }
        
        let item = TrailerPlayerItem(
            url: URL(string: itemLink.link_video ?? ""),
            thumbnailUrl: URL(string: itemLink.thumbnail ?? ""),
            autoPlay: autoPlay,
            autoReplay: autoReplay)
        playerView.playbackDelegate = self
        playerView.set(item: item)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let enableFullscreen = UIDevice.current.orientation.isLandscape
        controlPanel.fullscreenButton.isSelected = enableFullscreen
        playerView.fullscreen(enabled: enableFullscreen)
    }

}
extension SwapVideoDetailVC: TrailerPlayerPlaybackDelegate {
    
    func trailerPlayer(_ player: TrailerPlayer, didUpdatePlaybackTime time: TimeInterval) {
        controlPanel.setProgress(withValue: time, duration: playerView.duration)
    }
    
    func trailerPlayer(_ player: TrailerPlayer, didChangePlaybackStatus status: TrailerPlayerPlaybackStatus) {
        controlPanel.setPlaybackStatus(status)
    }
}

extension SwapVideoDetailVC: ControlPanelDelegate {
    
    func controlPanel(_ panel: ControlPanel, didTapMuteButton button: UIButton) {
        playerView.toggleMute()
        playerView.autoFadeOutControlPanelWithAnimation()
    }
    
    func controlPanel(_ panel: ControlPanel, didTapPlayPauseButton button: UIButton) {
        if playerView.status == .playing {
            playerView.pause()
        } else {
            playerView.play()
        }
        playerView.autoFadeOutControlPanelWithAnimation()
    }
    
    func controlPanel(_ panel: ControlPanel, didTapFullscreenButton button: UIButton) {
        playerView.fullscreen(enabled: button.isSelected,
                              rotateTo: button.isSelected ? .landscapeRight: .portrait)
        playerView.autoFadeOutControlPanelWithAnimation()
    }
    
    func controlPanel(_ panel: ControlPanel, didTouchDownProgressSlider slider: UISlider) {
        playerView.pause()
        playerView.cancelAutoFadeOutAnimation()
    }
    
    func controlPanel(_ panel: ControlPanel, didChangeProgressSliderValue slider: UISlider) {
        playerView.seek(to: TimeInterval(slider.value))
        playerView.play()
        playerView.autoFadeOutControlPanelWithAnimation()
    }
}

extension SwapVideoDetailVC: ReplayPanelDelegate {
    
    func replayPanel(_ panel: ReplayPanel, didTapReplayButton: UIButton) {
        playerView.replay()
    }
}

extension SwapVideoDetailVC : UIPickerViewDelegate,
                               UINavigationControllerDelegate,
                               UIImagePickerControllerDelegate {
    func showImagePicker(selectedSource: UIImagePickerController.SourceType) {
        guard UIImagePickerController.isSourceTypeAvailable(selectedSource) else {
            return
        }
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = selectedSource
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
//    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
//        if let selectedImage = info[.originalImage] as? UIImage {
//            picker.dismiss(animated: true)
//            self.detectFaces(in: selectedImage)
//        } else {
//            print("Image not found")
//        }
//    }
//    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
