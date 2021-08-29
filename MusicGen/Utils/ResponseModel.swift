//
//  ResponseModel.swift
//  MusicGen
//
//  Created by Kartinin Studio on 08.07.2021.
//

import Foundation
import SwiftyJSON

struct ResponceModel {
 
  var status: JSON
    var success : Bool
    var message : String
  var title_tovary : String
    var data : JSON
    var id : String?
    var tovar : JSON
    var razdel : JSON
    var nomerzakaza : JSON
    var action : JSON
    var comments : JSON
    var rekomend : JSON
    var osnovapodarki: JSON
    var textkorzina : JSON
    var namerazdely: JSON
    var paysystem: JSON
    var dostavka_informat: JSON
    var block: JSON
    var dannie: JSON
    var zakaz: JSON
    var text: JSON
    var textpodtovar: JSON
    var yslugi: JSON
    var title: JSON
    var tittle: JSON
    var stranic: JSON
    var glavtitle: JSON
    var tovarvsego: JSON
    var detail_page_url: JSON
  var detail_page_url_ios: JSON
    var keyWords: JSON
  var tovarpopyl: JSON
  var predtovar: JSON
  var titlerazdel: JSON
  var brand: JSON
  var pravilslovo: JSON
  var tovary: JSON
  
  var nettovar: JSON
  var titleNetTovar: String
  var mainTitleNetTovar: String
  var messageNetTovar: String
  var productsOffer: JSON
  
  var netvnalichii: JSON
  var TITLE: String
  var productsNotAvailable: JSON
  var productsNotAvailableAnotherProduct: JSON
  
  var glavTitle: String
  var tovarVsego: String
  var nalichie: JSON
  var nameNalichie: String
  var nameNetNalichie: String
  
  //Parkovka
  var parkovka: JSON // = data["PARKOVKA_SZORIN"] as! Dictionary<String, AnyObject>
  var priceParkovka: String //parkovka["PRICE"] as! Int
  var titleParkovka: String //parkovka["TITLE"] as! String
  
    init(_ any : Any?) {
        if any == nil {
            self = ResponceModel("Не удалось прочитать данные с сервера")
        } else {
            self = ResponceModel(JSON(any!), initFromData : false)
        }
    }
    
  init(_ success : Bool, _ message : String ) {
        self.success = success
        self.message = message
    self.title_tovary = ""
        self.data = JSON()
        self.tovar = JSON()
        self.razdel = JSON()
        self.nomerzakaza = JSON()
        self.action = JSON()
        self.comments = JSON()
        self.rekomend = JSON()
        self.osnovapodarki = JSON()
        self.textkorzina = JSON()
        self.namerazdely = JSON()
        self.paysystem = JSON()
        self.dostavka_informat = JSON()
        self.block = JSON()
        self.dannie = JSON()
        self.zakaz = JSON()
        self.text = JSON()
        self.textpodtovar = JSON()
        self.yslugi = JSON()
        self.title = JSON()
        self.tittle = JSON()
        self.stranic = JSON()
        self.glavtitle = JSON()
        self.tovarvsego = JSON()
        self.detail_page_url = JSON()
        self.keyWords = JSON()
      self.detail_page_url_ios = JSON()
      self.tovarpopyl = JSON()
      self.predtovar = JSON()
      self.titlerazdel = JSON()
      self.brand = JSON()
      self.pravilslovo = JSON()
      self.tovary = JSON()
      self.status = JSON()
      
      self.nettovar = JSON()
      self.titleNetTovar = "titleNetTovar"
      self.mainTitleNetTovar = "mainTitleNetTovar"
      self.messageNetTovar = "messageNetTovar"
      self.productsOffer = JSON()
    
    self.netvnalichii = JSON()
    self.TITLE = ""
    self.productsNotAvailable = JSON()
    self.productsNotAvailableAnotherProduct = JSON()
    
    self.glavTitle = ""
    self.tovarVsego = ""
    self.nalichie = JSON()
    self.nameNalichie = ""
    self.nameNetNalichie = ""
    
    //Parkovka
    self.parkovka = JSON() // = data["PARKOVKA_SZORIN"] as! Dictionary<String, AnyObject>
    self.priceParkovka = "" //parkovka["PRICE"] as! Int
    self.titleParkovka = "" //parkovka["TITLE"] as! String
    }
    
    init(_ json : JSON, initFromAuthModel : Bool = false) {
        self.success = json["status"].stringValue == "Success"
        self.message = json["message"].stringValue
      
        self.data = json["data"]
        self.tovar = json["tovar"]
        self.razdel = json["razdel"]
        self.nomerzakaza = json["nomerzakaza"]
        self.action = json["action"]
        self.comments = json["comments"]
        self.rekomend = json["rekomend"]
        self.osnovapodarki = json["osnovapodarki"]
        self.textkorzina = json["textkorzina"]
        self.namerazdely = json["namerazdely"]
        self.paysystem = json["paysystem"]
        self.dostavka_informat = json["dostavka_informat"]
        self.block = json["block"]
        self.dannie = json["dannie"]
        self.zakaz = json["zakaz"]
        self.text = json["text"]
        self.textpodtovar = json["textpodtovar"]
        self.yslugi = json["yslugi"]
        self.title = json["title"]
        self.tittle = json["tittle"]
        self.stranic = json["stranic"]
        self.glavtitle = json["glavtitle"]
        self.tovarvsego = json["tovarvsego"]
        self.detail_page_url = json["detail_page_url"]
      self.detail_page_url_ios = json["detail_page_url_ios"]
        self.keyWords = json["klyshslova"]
      self.tovarpopyl = json["tovarpopyl"]
      self.predtovar = json["predtovar"]
      self.titlerazdel = json["titlerazdel"]
      self.brand = json["brand"]
      self.pravilslovo = json["pravilslovo"]
      self.tovary = json["tovary"]
      self.status = json["status"]
      
      self.nettovar = json["nettovar"]
      self.titleNetTovar = json["nettovar"]["title"].stringValue
      self.mainTitleNetTovar = json["nettovar"]["glavtitle"].stringValue
      self.messageNetTovar = json["nettovar"]["message"].stringValue
      self.productsOffer = json["nettovar"]["data"]
      
      self.title_tovary = json["title_tovary"].stringValue
      
      self.netvnalichii = json["netvnalichii"]
      self.TITLE = json["netvnalichii"]["TITLE"].stringValue
      self.productsNotAvailable = json["netvnalichii"]["data"]
      self.productsNotAvailableAnotherProduct = json["netvnalichii"]["data"]["nettovar"]["data"]
      
      self.glavTitle = json["glavtitle"].stringValue
      self.tovarVsego = json["tovarvsego"].stringValue
      self.nalichie = json["nalichie"]
      self.nameNalichie = json["nalichie"]["NAMENALICHIE"].stringValue
      self.nameNetNalichie = json["nalichie"]["NAMENETNALICHIE"].stringValue
      
      //Parkovka
      self.parkovka = json["PARKOVKA_SZORIN"]
      self.priceParkovka = json["PARKOVKA_SZORIN"]["PRICE"].stringValue
      self.titleParkovka = json["PARKOVKA_SZORIN"]["TITLE"].stringValue
        
        if !json["errors"].arrayValue.isEmpty {
            self.success = false
            self.message = json["errors"].arrayValue.first?.stringValue ?? ""
          self.title_tovary = ""
          self.titleNetTovar = ""
          self.mainTitleNetTovar = ""
          self.messageNetTovar = ""
        }
        
        if initFromAuthModel {
            self.success = json["data"]["auth_status"]["TYPE"].stringValue != "ERROR"
            if !json["data"]["auth_status"]["MESSAGE"].stringValue.isEmpty {
                self.message = json["data"]["auth_status"]["MESSAGE"].stringValue
            }
        }
    }
    
    init(_ json : JSON, initFromData : Bool = false) {
        self.success = json["status"].stringValue == "Success"
        self.message = json["message"].stringValue
        self.data = json["data"]
        self.tovar = json["tovar"]
        self.razdel = json["razdel"]
        self.nomerzakaza = json["nomerzakaza"]
        self.action = json["action"]
        self.comments = json["comments"]
        self.rekomend = json["rekomend"]
        self.osnovapodarki = json["osnovapodarki"]
        self.textkorzina = json["textkorzina"]
        self.namerazdely = json["namerazdely"]
        self.paysystem = json["paysystem"]
        self.dostavka_informat = json["dostavka_informat"]
        self.block = json["block"]
        self.dannie = json["dannie"]
        self.zakaz = json["zakaz"]
        self.text = json["text"]
        self.textpodtovar = json["textpodtovar"]
        self.yslugi = json["yslugi"]
        self.title = json["title"]
        self.tittle = json["tittle"]
        self.stranic = json["stranic"]
        self.glavtitle = json["glavtitle"]
        self.tovarvsego = json["tovarvsego"]
        self.detail_page_url = json["detail_page_url"]
      self.detail_page_url_ios = json["detail_page_url_ios"]
        self.keyWords = json["klyshslova"]
        self.tovarpopyl = json["tovarpopyl"]
        self.predtovar = json["predtovar"]
      self.titlerazdel = json["titlerazdel"]
      self.brand = json["brand"]
      self.pravilslovo = json["pravilslovo"]
      self.tovary = json["tovary"]
      self.status = json["status"]
      //nettovar
      self.nettovar = json["nettovar"]
      self.titleNetTovar = json["nettovar"]["title"].stringValue
      self.mainTitleNetTovar = json["nettovar"]["glavtitle"].stringValue
      self.messageNetTovar = json["nettovar"]["message"].stringValue
      self.productsOffer = json["nettovar"]["data"]
      
      self.title_tovary = json["title_tovary"].stringValue
      
      self.nalichie = json["nalichie"]
      self.nameNalichie = json["nalichie"]["NAMENALICHIE"].stringValue
      self.nameNetNalichie = json["nalichie"]["NAMENETNALICHIE"].stringValue
      
      self.glavTitle = json["glavtitle"].stringValue
      self.tovarVsego = json["tovarvsego"].stringValue
      self.netvnalichii = json["netvnalichii"]
      self.TITLE = json["netvnalichii"]["TITLE"].stringValue
      self.productsNotAvailable = json["netvnalichii"]["data"]
      self.productsNotAvailableAnotherProduct = json["netvnalichii"]["data"]["nettovar"]
      
      //Parkovka
      self.parkovka = json["PARKOVKA_SZORIN"]
      self.priceParkovka = json["PARKOVKA_SZORIN"]["PRICE"].stringValue
      self.titleParkovka = json["PARKOVKA_SZORIN"]["TITLE"].stringValue
      
        
        if !json["errors"].arrayValue.isEmpty {
            self.success = false
            self.message = json["errors"].arrayValue.first?.stringValue ?? ""
        }

        if initFromData {
            self.success = json["data"]["TYPE"].stringValue == "OK"
            self.message = json["data"]["MESSAGE"].stringValue
        
        }
    }
    
    init(_ json : JSON, initFromId : Bool = false) {
        self.success = json["status"].stringValue == "Success"
        self.message = json["message"].stringValue
        self.data = JSON()
        self.id = json["id"].stringValue
        self.tovar = json["tovar"]
        self.razdel = json["razdel"]
        self.nomerzakaza = json["nomerzakaza"]
        self.action = json["action"]
        self.comments = json["comments"]
        self.rekomend = json["rekomend"]
        self.osnovapodarki = json["osnovapodarki"]
        self.textkorzina = json["textkorzina"]
        self.namerazdely = json["namerazdely"]
        self.paysystem = json["paysystem"]
        self.dostavka_informat = json["dostavka_informat"]
        self.block = json["block"]
        self.dannie = json["dannie"]
        self.zakaz = json["zakaz"]
        self.text = json["text"]
        self.textpodtovar = json["textpodtovar"]
        self.yslugi = json["yslugi"]
        self.title = json["title"]
        self.tittle = json["tittle"]
        self.stranic = json["stranic"]
        self.glavtitle = json["glavtitle"]
        self.tovarvsego = json["tovarvsego"]
        self.detail_page_url = json["detail_page_url"]
        self.keyWords = json["klyshslova"]
      self.detail_page_url_ios = json["detail_page_url_ios"]
      self.tovarpopyl = json["tovarpopyl"]
      self.predtovar = json["predtovar"]
      self.titlerazdel = json["titlerazdel"]
      self.brand = json["brand"]
      self.pravilslovo = json["pravilslovo"]
      self.tovary = json["tovary"]
      self.status = json["status"]
      
      self.nettovar = json["nettovar"]
      self.titleNetTovar = json["nettovar"]["title"].stringValue
      self.mainTitleNetTovar = json["nettovar"]["glavtitle"].stringValue
      self.messageNetTovar = json["nettovar"]["message"].stringValue
      self.productsOffer = json["nettovar"]["data"]
      
      self.title_tovary = json["title_tovary"].stringValue
      
      self.netvnalichii = json["netvnalichii"]
      self.TITLE = json["netvnalichii"]["TITLE"].stringValue
      self.productsNotAvailable = json["netvnalichii"]["data"]
      self.productsNotAvailableAnotherProduct = json["netvnalichii"]["data"]["nettovar"]
      
      self.glavTitle = json["glavtitle"].stringValue
      self.tovarVsego = json["tovarvsego"].stringValue
      self.nalichie = json["nalichie"]
      self.nameNalichie = json["nalichie"]["NAMENALICHIE"].stringValue
      self.nameNetNalichie = json["nalichie"]["NAMENETNALICHIE"].stringValue
      
      //Parkovka
      self.parkovka = json["PARKOVKA_SZORIN"]
      self.priceParkovka = json["PARKOVKA_SZORIN"]["PRICE"].stringValue
      self.titleParkovka = json["PARKOVKA_SZORIN"]["TITLE"].stringValue
    }
    
    private init(_ error : String) {
        self.success = false
        self.message = error
        self.data = JSON()
        self.tovar = JSON()
        self.razdel = JSON()
        self.nomerzakaza = JSON()
        self.action = JSON()
        self.comments = JSON()
        self.rekomend = JSON()
        self.osnovapodarki = JSON()
        self.textkorzina = JSON()
        self.namerazdely = JSON()
        self.paysystem = JSON()
        self.dostavka_informat = JSON()
        self.block = JSON()
        self.dannie = JSON()
        self.zakaz = JSON()
        self.text = JSON()
        self.textpodtovar = JSON()
        self.yslugi = JSON()
        self.title = JSON()
        self.tittle = JSON()
        self.stranic = JSON()
        self.glavtitle = JSON()
        self.tovarvsego = JSON()
        self.detail_page_url = JSON()
        self.keyWords = JSON()
      self.detail_page_url_ios = JSON()
      self.tovarpopyl = JSON()
      self.predtovar = JSON()
      self.titlerazdel = JSON()
      self.brand = JSON()
      self.pravilslovo = JSON()
      self.tovary = JSON()
      self.status = JSON()
      
      self.nettovar = JSON()
      self.titleNetTovar = error
      self.mainTitleNetTovar = error
      self.messageNetTovar = error
      self.productsOffer = JSON()
      
      self.title_tovary = error
      
      self.netvnalichii = JSON()
      self.TITLE = error
      self.productsNotAvailable = JSON()
      self.productsNotAvailableAnotherProduct = JSON()
      
      self.glavTitle = error
      self.tovarVsego = error
      self.nalichie = JSON()
      self.nameNalichie = error
      self.nameNetNalichie = error
      
      //Parkovka
      self.parkovka = JSON()
      self.priceParkovka = error
      self.titleParkovka = error
    }
    
    private init(_ json : Any?, yandexGeocoder : Bool = true) {
        self.success = true
        self.message = ""
        self.data = JSON(json ?? Data())
        self.tovar = JSON(json ?? Data())
        self.razdel = JSON(json ?? Data())
        self.nomerzakaza = JSON(json ?? Data())
        self.action = JSON(json ?? Data())
        self.comments = JSON(json ?? Data())
        self.rekomend = JSON(json ?? Data())
        self.osnovapodarki = JSON(json ?? Data())
        self.textkorzina = JSON(json ?? Data())
        self.namerazdely = JSON(json ?? Data())
        self.paysystem = JSON(json ?? Data())
        self.dostavka_informat = JSON(json ?? Data())
        self.block = JSON(json ?? Data())
        self.dannie = JSON(json ?? Data())
        self.zakaz = JSON(json ?? Data())
        self.text = JSON(json ?? Data())
        self.textpodtovar = JSON(json ?? Data())
        self.yslugi = JSON(json ?? Data())
        self.title = JSON(json ?? Data())
        self.tittle = JSON(json ?? Data())
        self.stranic = JSON(json ?? Data())
        self.glavtitle = JSON(json ?? Data())
        self.tovarvsego = JSON(json ?? Data())
        self.detail_page_url = JSON(json ?? Data())
        self.keyWords = JSON(json ?? Data())
      self.detail_page_url_ios = JSON(json ?? Data())
      self.tovarpopyl = JSON(json ?? Data())
      self.predtovar = JSON(json ?? Data())
      self.titlerazdel = JSON(json ?? Data())
      
      self.brand = JSON(json ?? Data())
      self.pravilslovo = JSON(json ?? Data())
      self.tovary = JSON(json ?? Data())
      self.status = JSON(json ?? Data())
      
      self.nettovar = JSON(json ?? Data())
      self.titleNetTovar = ""
      self.mainTitleNetTovar = ""
      self.messageNetTovar = ""
      self.productsOffer = JSON(json ?? Data())
      
      self.title_tovary = ""
      
      self.netvnalichii = JSON(json ?? Data())
      self.TITLE = ""
      self.productsNotAvailable = JSON(json ?? Data())
      self.productsNotAvailableAnotherProduct = JSON(json ?? Data())
      
      self.glavTitle = ""
      self.tovarVsego = ""
      self.nalichie = JSON()
      self.nameNalichie = ""
      self.nameNetNalichie = ""
      
      //Parkovka
      self.parkovka = JSON(json ?? Data())
      self.priceParkovka = ""
      self.titleParkovka = ""
      
    }
    
    static func connetionError(_ error : String) -> ResponceModel {
        return ResponceModel(error)
    }
    
    static func initFromYandexGeocoder(_ data : Any?) -> ResponceModel {
        return ResponceModel(data, yandexGeocoder: true)
    }
    
}

