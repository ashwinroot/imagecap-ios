# imagecap-ios

## Image Captioning - Where images tells stories

An iOS app for image captioning- a final year project

It is currently hosted in gct server, and the service provided is invoked throught the app. The code the service is present in bitbucket account(for privacy).The code can be viewed on request.

The simple deeplearning with layers of cnn and rnn for classification based on supervised learning on MSCOCO dataset. The dataset for the project was not completely trained due to time and hardware constrains. The accuracy seems to be the same as previous test, and the future work on getting user feedback and appending the results without retraining is proposed.

```
This is my ** first ** ios app.
```

### Installing and using the app
In order to use the app:

1. You must be having the latest [xcode](https://developer.apple.com/xcode/) installed in the computer.
2. Clone the repository.
3. Inside imagecap-ios/ double click on upload_images.xcodeproj
4. This will open the file, with all the dependencies in it.


### Dependencies:

* Using UIKit : For the layout and standard UI operations.
* Using AVFoundation:  For Converting the text into voice after the captions are generated.
