//
//  MarketDataModel.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 24/12/22.
//

import Foundation

/*
 URL:- https://api.coingecko.com/api/v3/global
 {
   "data": {
     "active_cryptocurrencies": 12907,
     "upcoming_icos": 0,
     "ongoing_icos": 49,
     "ended_icos": 3376,
     "markets": 623,
     "total_market_cap": {
       "btc": 50140297.523383975,
       "eth": 692435776.5998458,
       "ltc": 12841312268.214302,
       "bch": 8288845846.469084,
       "bnb": 3456117177.946413,
       "eos": 950619219761.1055,
       "xrp": 2395355797896.14,
       "xlm": 11302086823170.824,
       "link": 142734328008.90085,
       "dot": 189279910226.36597,
       "yfi": 153952646.89907318,
       "usd": 845611115271.1447,
       "aed": 3105422259721.7603,
       "ars": 147092666699186.88,
       "aud": 1258353900634.9941,
       "bdt": 89496594369561.84,
       "bhd": 318232213454.45197,
       "bmd": 845611115271.1447,
       "brl": 4368257899267.6914,
       "cad": 1153794086231.7146,
       "chf": 789204625826.9855,
       "clp": 742446559208066.9,
       "cny": 5910568012410.712,
       "czk": 19274394675377.105,
       "dkk": 5925281645816.442,
       "eur": 792724059288.7434,
       "gbp": 701577328395.8953,
       "hkd": 6601051768585.41,
       "huf": 319023705458345.44,
       "idr": 13185799855522018,
       "ils": 2961541528458.3765,
       "inr": 69851156529748.09,
       "jpy": 112267568826205.45,
       "krw": 1082588888138750.8,
       "kwd": 259145982385.9957,
       "lkr": 309031548479633.1,
       "mmk": 1775552771823441.2,
       "mxn": 16383038869486.25,
       "myr": 3741829185074.8223,
       "ngn": 377675292413552.1,
       "nok": 8359204118901.375,
       "nzd": 1343092590496.3174,
       "php": 46698876377682.45,
       "pkr": 190685306493643.44,
       "pln": 3696452847018.2603,
       "rub": 59404178310964.59,
       "sar": 3180060970422.283,
       "sek": 8906060827147.268,
       "sgd": 1142758861177.4294,
       "thb": 29388934413969.55,
       "try": 15783922548705.51,
       "twd": 26011082466852.027,
       "uah": 31223053930048.164,
       "vef": 84671040972.09995,
       "vnd": 19998702876162630,
       "zar": 14387142954111.785,
       "xdr": 635059021235.3242,
       "xag": 35614442675.76299,
       "xau": 470151323.9796049,
       "bits": 50140297523383.98,
       "sats": 5014029752338398
     }
 
 }
 */

// MARK: - Welcome
struct GlobalData: Codable {
    let data: MarketDataModel?
}

// MARK: - DataClass
struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double
    
    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    var marketCap:String{
        if let item = totalMarketCap.first(where: {$0.key == "usd"})
        {
            return "$ "+item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume:String{
        if let item = totalVolume.first(where: {$0.key == "usd"}){
            return "$ "+item.value.formattedWithAbbreviations()
        }
        return ""
    }
    var btcDominance:String{
        if let item = marketCapPercentage.first(where: {$0.key == "btc"})
        {
            return item.value.asPercentageString()
        }
        return ""
    }
}
