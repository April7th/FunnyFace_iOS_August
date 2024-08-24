//
//  UserVideoViewController.swift
//  funnyface2222
//
//  Created by Lê Duy Tân on 7/8/24.
//


import UIKit
import Kingfisher

class UserVideoViewController: UIViewController {

    @IBOutlet weak var cacluachonimageclv22:UICollectionView!
    @IBOutlet weak var backbtn:UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var userVideo: [ResultVideoModel] = [ResultVideoModel]()
    
    
    @IBAction func BackApp(){
        self.dismiss(animated: true)
    }
    @IBAction func listCate(){
        let refreshAlert = UIAlertController(title: "Choose list video", message: "", preferredStyle: .alert)

        // Tùy chỉnh nền và màu sắc chữ
        if let alertView = refreshAlert.view.subviews.first?.subviews.first {
            alertView.backgroundColor = UIColor.black

            // Tìm các label trong alertView và đặt màu chữ là trắng
            for subview in alertView.subviews {
                if let label = subview as? UILabel {
                    label.textColor = UIColor.white
                }
            }
        }
        for index in 1...10 {
            refreshAlert.addAction(UIAlertAction(title: "album \(index)", style: .default, handler: { (action: UIAlertAction!) in
                
                APIService.shared.listAllVideoSwaped(page:index){response,error in
                    self.userVideo = response
                    self.cacluachonimageclv22.reloadData()
                }
            }))
        }
       

        present(refreshAlert, animated: true, completion: nil)

    }
    @IBOutlet weak var listCategory:UIButton!
    @IBAction func swapnext(){
//        if let parentVC = findParentViewController(of: UIViewController.self) {
//                let nextViewController = SwapVideoDetailVC(nibName: "SwapVideoDetailVC", bundle: nil)
//                nextViewController.itemLink = self.listTemplateVideo[indexPath.row]
//
//                parentVC.present(nextViewController, animated: true, completion: nil)
//            }
    }
    var listTemplateVideo : [ResultVideoModel] = [ResultVideoModel]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "Video Collections"
        titleLabel.font = .quickSandBold(size: 20)
        
        backbtn.setTitle("", for: .normal)
        listCategory.setTitle("", for: .normal)
        print("lít dataa ")
        //print(self.listData)
        cacluachonimageclv22.register(UINib(nibName: "cellVideoSwaped", bundle: nil), forCellWithReuseIdentifier: "cellVideoSwaped")
        print("List video is: \(listTemplateVideo)")
        
        
        print("List vide: \(listTemplateVideo.count)")
        
        for i in 0..<listTemplateVideo.count {
            if AppConstant.userId.asStringOrEmpty() == listTemplateVideo[i].id_user.asStringOrEmpty() {
                userVideo.append(listTemplateVideo[i])
            }
        }
        print("User video: \(userVideo.count)")
        
    }


}
extension UserVideoViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
       
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      
        
        return userVideo.count
     
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = DetailSwapVideoVC(nibName: "DetailSwapVideoVC", bundle: nil)
        var itemLink:DetailVideoModel = DetailVideoModel()
        itemLink.linkimg = self.userVideo[indexPath.row].link_image
        itemLink.link_vid_swap = self.userVideo[indexPath.row].link_vid_swap
        itemLink.noidung = self.userVideo[indexPath.row].noidung_sukien
        itemLink.id_sukien_video = self.userVideo[indexPath.row].id_video
        itemLink.id_video_swap = self.userVideo[indexPath.row].id_video
        itemLink.ten_video = self.userVideo[indexPath.row].ten_su_kien
        itemLink.idUser = self.userVideo[indexPath.row].id_user
        itemLink.thoigian_sukien = self.userVideo[indexPath.row].thoigian_taosk
        itemLink.link_video_goc = self.userVideo[indexPath.row].link_vid_swap
        itemLink.ip_tao_vid = self.userVideo[indexPath.row].id_video
        itemLink.link_vid_swap = self.userVideo[indexPath.row].link_vid_swap
        vc.itemDataSend = itemLink
        vc.modalPresentationStyle = .fullScreen //or .overFullScreen for transparency
        self.present(vc, animated: true, completion: nil)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
 
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellVideoSwaped", for: indexPath) as! cellVideoSwaped
        cell.labelTime.text = self.userVideo[indexPath.row].thoigian_swap ?? ""
        cell.imageview.layer.cornerRadius = 10
        cell.imageview.layer.masksToBounds = true
        cell.labelName.text = self.userVideo[indexPath.row].noidung_sukien ?? ""
        let url = URL(string: self.userVideo[indexPath.row].link_image ?? "")
        let processor = DownsamplingImageProcessor(size: cell.imageview.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 10)
        cell.imageview.kf.indicatorType = .activity
        cell.imageview.kf.setImage(
            with: url,
            placeholder: UIImage(named: "hoapro"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        }
        return cell
        
     
    }
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
    

        return UICollectionReusableView()
    }
    
}

extension UserVideoViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
       
            if UIDevice.current.userInterfaceIdiom == .pad{
                return CGSize(width: (UIScreen.main.bounds.width)/3.2 - 20, height: 400)
            }
        return CGSize(width: (UIScreen.main.bounds.width)/2.5-10, height: 200)
       
    }}



