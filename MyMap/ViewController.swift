//
//  ViewController.swift
//  MyMap
//
//  Created by Sakurako Shimbori on 2020/06/23.
//  Copyright © 2020 Taisei Hikawa. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController , UITextFieldDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Text Fieldのdelegate通知先を設定
        inputText.delegate = self
    }
    @IBOutlet weak var inputText: UITextField!
    @IBOutlet weak var dispMap: MKMapView!
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //キーボードを閉じる
        textField.resignFirstResponder()
        
        //入力された文字を取り出す
        if let searchKey = textField.text{
            //入力された文字をデバッグエリアに表示
            print(searchKey)
            
            //CLGeocoderインスタンスを取得
            let geocoder = CLGeocoder()
            
            //入力された文字から位置情報を取得
            geocoder.geocodeAddressString(searchKey, completionHandler: {(placemarks,error) in
                
                //位置情報が存在する場合は、unwrapPlacemarksに取り出す
                if let unwrapPlacemaraks = placemarks{
                    
                    //１件目の情報を取り出す
                    if let firstPlacemark = unwrapPlacemaraks.first{
                    
                        //位置情報を取り出す
                        if let location = firstPlacemark.location{
                            
                            //位置情報から緯度経度をtargetCoordinateに取り出す
                            let targetCoordinate = location.coordinate
                            
                            //位置情報をデバッグエリアに表示
                            print(targetCoordinate)
                            
                            //MKPointAnnotationインスタンスを取得し、ピンを生成
                            let pin = MKPointAnnotation()
                            
                            //ピンの置く場所に緯度経度を設定
                            pin.coordinate = targetCoordinate
                            
                            //ピンのタイトルを設定
                            pin.title = searchKey
                            
                            //ピンを地図に置く
                            self.dispMap.addAnnotation(pin)
                            
                            //緯度経度を中心にして半径５００mの範囲を表示
                            self.dispMap.region = MKCoordinateRegion(center: targetCoordinate, latitudinalMeters: 500.0, longitudinalMeters: 500.0)
                        }
                        
                    }
                }
            })
        }
        return true
    }
    @IBAction func changeMapButton(_ sender: Any) {
        //mapTypeプロパティー値をトグル
        //標準 → 航空写真 → 航空写真＋標準 → ３D Flyover → ３D Flyiver+標準 →　交通機関
        if dispMap.mapType == .standard{
            dispMap.mapType = .satellite
        }else if dispMap.mapType == .satellite{
            dispMap.mapType = .hybrid
        }else if dispMap.mapType == .hybrid{
            dispMap.mapType = .satelliteFlyover
        }else if dispMap.mapType == .satelliteFlyover{
            dispMap.mapType = .hybridFlyover
        }else if dispMap.mapType == .hybridFlyover{
            dispMap.mapType = .mutedStandard
        }else {
            dispMap.mapType = .standard
        }
        
    }
    

}

