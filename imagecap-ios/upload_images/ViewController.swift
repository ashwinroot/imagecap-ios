//
//  ViewController.swift
//  upload_images


import UIKit
import AVFoundation

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //@IBOutlet weak var activitymonitor: UIActivityIndicatorView!
    
    @IBOutlet var image: UIImageView!
    var textData = " "
    let label = UILabel(frame: CGRect(x: 30, y: 470, width: 300, height: 151))
    let messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    var strLabel = UILabel()
    let effectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    override func viewDidLoad() {
        
        //label.center = CGPoint(x: 160, y: 385)
        //label.textAlignment = .center
        label.text = self.textData
        label.numberOfLines = 2
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        self.view.addSubview(label)
        super.viewDidLoad()
    }


    @IBAction func selectPicture(_ sender: AnyObject) {
        
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        ImagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        self.present(ImagePicker, animated: true, completion: nil)
        
        
    }
    
    @IBAction func cameraselect(_ sender: UIButton) {
        let ImagePicker = UIImagePickerController()
        ImagePicker.delegate = self
        ImagePicker.sourceType = UIImagePickerControllerSourceType.camera
        
        self.present(ImagePicker, animated: true, completion: nil)
        

    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("image selected");
        label.text = " "
        self.view.addSubview(label)
        let selectedImage = info[UIImagePickerControllerOriginalImage] as? UIImage
        print(info.debugDescription)
        self.dismiss(animated: true, completion: nil)
        image.image = selectedImage
        //UploadRequest()
    }
    
    @IBAction func upload_request(_ sender: AnyObject) {
        print("Sending Upload request")
        activityIndicator("Uploading")
        UploadRequest()
       //
    }
    
    
    
    func UploadRequest()
    {
        let url = URL(string: "http://14.139.188.98/ios.php")
        
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        
        let boundary = generateBoundaryString()
        
  
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        if (image.image == nil)
        {
            return
        }
        
       // let image_data = UIImagePNGRepresentation(image.image!)
        let image_data = UIImageJPEGRepresentation(image.image!, 0.5)
        
        
        if(image_data == nil)
        {
            return
        }
        

        let body = NSMutableData()
        
        let fname = "test.jpg"
        let mimetype = "image/jpeg"
        


        body.append("--\(boundary)\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Disposition:form-data; name=\"file\"; filename=\"\(fname)\"\r\n".data(using: String.Encoding.utf8)!)
        body.append("Content-Type: \(mimetype)\r\n\r\n".data(using: String.Encoding.utf8)!)
        body.append(image_data!)
        body.append("\r\n".data(using: String.Encoding.utf8)!)
        body.append("--\(boundary)--\r\n".data(using: String.Encoding.utf8)!)

    
        request.httpBody = body as Data
        
        
        
        let session = URLSession.shared

        
        let task = session.dataTask(with: request as URLRequest, completionHandler: {
            (
            data, response, error) in
            
            guard ((data) != nil), let _:URLResponse = response, error == nil else {
                print("error with execution. Try again later.")
                return
            }
            
            if let dataString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            {
                print(dataString)
                self.textData = dataString as String
                self.printResult()
            }
        

            
        })
        
        task.resume()

        
        
    }
    func printResult()
    {
        DispatchQueue.global(qos: .userInitiated).async {
            // Bounce back to the main thread to update the UI
            DispatchQueue.main.sync{
                let synth = AVSpeechSynthesizer()
                var myUtterance = AVSpeechUtterance(string: "Null")
                self.label.text = self.textData
                self.label.textColor = UIColor.black
                self.view.addSubview(self.label)
                self.effectView.removeFromSuperview()
                myUtterance = AVSpeechUtterance(string: self.label.text!)
                myUtterance.rate = 0.5
                synth.speak(myUtterance)
            }
        }
        
    }
    
    func activityIndicator(_ title: String) {
        
        strLabel.removeFromSuperview()
        activityIndicator.removeFromSuperview()
        effectView.removeFromSuperview()
        
        strLabel = UILabel(frame: CGRect(x: 50, y: 0, width: 160, height: 46))
        strLabel.text = title
        strLabel.font = UIFont.systemFont(ofSize: 14, weight: UIFontWeightMedium)
        strLabel.textColor = UIColor(white: 0.9, alpha: 0.7)
        
        effectView.frame = CGRect(x: view.frame.midX - strLabel.frame.width/2, y: view.frame.midY - strLabel.frame.height/2 , width: 160, height: 46)
        effectView.layer.cornerRadius = 15
        effectView.layer.masksToBounds = true
        
        activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 46, height: 46)
        activityIndicator.startAnimating()
        
        effectView.addSubview(activityIndicator)
        effectView.addSubview(strLabel)
        view.addSubview(effectView)
        
    }

    
    
    func generateBoundaryString() -> String
    {
        return "Boundary-\(UUID().uuidString)"
    }

}

