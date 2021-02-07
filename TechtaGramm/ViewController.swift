//
//  ViewController.swift
//  TechtaGramm
//
//  Created by Chihiro Nishiwaki on 2021/02/07.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet var cameraImageView: UIImageView!
    //写真加工元の画像
    var originalImage: UIImage!
    //画像加工するフィルターの宣言
    var filter: CIFilter!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        cameraImageView.image = info[.editedImage] as? UIImage
        originalImage = cameraImageView.image
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func takePhoto() {
        //カメラが使えるかの確認
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            //カメラを起動
            let picker = UIImagePickerController()
            picker.sourceType = .camera
            picker.delegate = self
            
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }else{
            //カメラが使えない時はコンソールにエラー表示
            print("error: camera is invalidate")
        }
        
        //カメラ、カメラロールを使った時に選択した画像をアプリ内に表示するためのメソット
//        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediawithInfo info: [UIImagePickerController.InfoKey : Any]){
//            cameraImageView.image = info[.editedImage] as? UIImage
//            originalImage = cameraImageView.image
//            dismiss(animated: true, completion: nil)
//        }
        
    }
    
    @IBAction func savePhoto() {
        UIImageWriteToSavedPhotosAlbum(cameraImageView.image!, nil, nil, nil)
    }
    
    @IBAction func colorFilter() {
        let filterImage: CIImage = CIImage(image: originalImage)!
        //フィルターの設定
        filter = CIFilter(name: "CIColorControls")
        filter.setValue(filterImage, forKey: kCIInputImageKey)
        //彩度調節
        filter.setValue(1.0, forKey: "inputSaturation")
        //明度調節
        filter.setValue(0.5, forKey: "inputBrightness")
        //コントラスト調節
        filter.setValue(2.5, forKey: "inputContrast")
        
        let ctx = CIContext(options: nil)
        let cgImage = ctx.createCGImage(filter.outputImage!, from: filter.outputImage!.extent)
        cameraImageView.image = UIImage(cgImage: cgImage!)
    }
    
    @IBAction func openAlbum() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            //カメラロールの画像を選択して画像を表示する
            let picker = UIImagePickerController()
            picker.sourceType = .photoLibrary
            picker.delegate = self
            picker.allowsEditing = true
            present(picker, animated: true, completion: nil)
        }
    
    }

    @IBAction func snsPhoto() {
        let shareText = "写真加工いえい"
        //投稿する画像の選択
        let shareImage = cameraImageView.image!
        //投稿するコメントと画像の準備
        let activityItems: [Any] = [shareText, shareImage]
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        let excludedActivityTypes = [UIActivity.ActivityType.postToWeibo, .saveToCameraRoll, .print]
        activityViewController.excludedActivityTypes = excludedActivityTypes
        present(activityViewController, animated: true, completion: nil)
        
        
    }

}

