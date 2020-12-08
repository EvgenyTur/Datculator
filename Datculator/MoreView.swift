//
//  MoreView.swift
//  Datculator
//
//  Created by Evgeny Turchaninov on 11.04.2020.
//  Copyright © 2020 Evgeny Turchaninov. All rights reserved.
//

import SwiftUI
import StoreKit

struct MoreView: View {
    @State private var appId = "1135287767"
    var body: some View {
        VStack {
            // Полоска вверху
            RoundedRectangle(cornerRadius: 2)
                .frame(width: 80, height: 4, alignment: .center)
                .foregroundColor(.gray)
                .padding(.top)

            Image("dc_icon")
            .resizable()
                .frame(width: 100, height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 20))
//                .scaledToFit()
            .shadow(radius: 10)
                .padding(.top, 50)
            
            Text("main_title")
                .font(.headline)
            HStack {
                Text("version")
                Text(ThisApp.appVersion())
            }
            .font(.caption)
            .padding(.bottom, 50)


            
            VStack (alignment: .leading) {
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.rowBackColor)
                    .frame(height: 52)
                    .overlay(HStack {
                        Image(systemName: "arrow.up.forward.app")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 28, height: 28, alignment: .center)
//                            .padding(.horizontal)
                            .padding()
                            .foregroundColor(Color("buttonColor"))

                        Text("show_appstore")
                    }, alignment: .leading)
                    .padding(3)
                    .foregroundColor(Color.textColor)
                    .onTapGesture {
                        self.showAppInAppstore()
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.rowBackColor)
                    .frame(height: 52)
                    .overlay(HStack {
                        Image(systemName: "star.fill")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 28, height: 28, alignment: .center)
//                            .padding(.horizontal)
                            .padding()
                            .foregroundColor(Color("buttonColor"))

                        Text("rate_app")
                    }, alignment: .leading)
                    .padding(3)
                    .foregroundColor(Color.textColor)
                    .onTapGesture {
                        rateApp()
                }

                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(Color.rowBackColor)
                    .frame(height: 52)
                    .overlay(HStack {
                        Image(systemName: "apps.ipad")
//                            .resizable()
//                            .scaledToFit()
//                            .frame(width: 32, height: 32, alignment: .center)
//                            .padding(.horizontal)
                            .padding()
                            .foregroundColor(Color("buttonColor"))

                        Text("other_apps")
                    }, alignment: .leading)
                    .padding(3)
                    .foregroundColor(Color.textColor)
                    .onTapGesture {
                        self.gotoOtherApps()
//                            rateApp()
                }

                

            }

            
            Spacer()
            Text(ThisApp.copyRightLabel())
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.bottom)

        }
    .foregroundColor(Color("contrastLabelColor"))
    .background(Color("backColor"))
    }
    
    /*
    func mailToDev() {
        if MFMailComposeViewController.canSendMail() {
            present(createMailComposeViewController(), animated: true, completion: nil)
        } else { // can't send email
            let noMailMessage = NSLocalizedString("no_mail", comment: "")
            let doneTitle = NSLocalizedString("ok", comment: "")
            
            let alertController = UIAlertController(title: nil, message: noMailMessage, preferredStyle: UIAlertController.Style.alert)
            
            let cancelAction = UIAlertAction(title: doneTitle, style: UIAlertAction.Style.default, handler: nil)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
            
        }
    }
    func createMailComposeViewController() -> MFMailComposeViewController {
        let appName = NSLocalizedString("main_title", comment: "")
        let mailSubject = appName + " " + versionLabel.text!
        let mailComposer = MFMailComposeViewController()
        mailComposer.mailComposeDelegate = self
        mailComposer.setToRecipients(["avencode@gmail.com"])
        mailComposer.setSubject(mailSubject)
        let currentLocale: String = NSLocale.current.description
        if !currentLocale.contains("ru") {
            mailComposer.setMessageBody("Please note that our support team will better understand your message in English.\n", isHTML: false)
        }
        return mailComposer
    }
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
 */
    
//    private func showAppInAppstore() {
//        if let url = URL(string: "itms-apps://itunes.apple.com/app/id" + appId),
//            UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
//        }
//    }
//
//    private func gotoOtherApps() {
//        if let url = URL(string: "https://appstore.com/evgenyturchaninov"),
//            UIApplication.shared.canOpenURL(url) {
//            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
//
//        }
//
//    }
    
    private func showAppInAppstore() {
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id" + appId),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
    private func gotoOtherApps() {
        if let url = URL(string: "itms-apps://apps.apple.com/developer/evgeny-turchaninov/id517592625"),
            UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
    
    func rateApp() {
        
        if let scene = UIApplication.shared.currentScene {
            if #available(iOS 14.0, *) {
                SKStoreReviewController.requestReview(in: scene)
            } else {
                // Fallback on earlier versions
                SKStoreReviewController.requestReview()
            }
        }
    }

    
    /*
    func openStoreProductWithiTunesItemIdentifier(identifier: String) {
        let storeViewController = SKStoreProductViewController()
        storeViewController.delegate = self
//        activityIndicator.isHidden = false
        
//        activityIndicator.startAnimating()
        
        let parameters = [ SKStoreProductParameterITunesItemIdentifier : identifier]
        storeViewController.loadProduct(withParameters: parameters) { (loaded, error) -> Void in
            if loaded {
                // Parent class of self is UIViewContorller
//                self?.activityIndicator.isHidden = true
                sheet(isPresented: <#T##Binding<Bool>#>, content: { storeViewController })
                present(storeViewController, animated: true, completion: nil)
            }
        }
    }
    */
    func productViewControllerDidFinish(_ viewController: SKStoreProductViewController) {
        viewController.dismiss(animated: true, completion: nil)
    }

    
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}


struct MoreView_Previews: PreviewProvider {
    static var previews: some View {
        MoreView()
    }
}

extension UIApplication {
    var currentScene: UIWindowScene? {
        connectedScenes
            .first { $0.activationState == .foregroundActive } as? UIWindowScene
    }
}
