//: [Previous](@previous)

import Foundation
import PlaygroundSupport

// Let asynchronous code run
PlaygroundPage.current.needsIndefiniteExecution = true

var str = "Hello, Bitcoin pricing and stuff"

class WeightedPriceInTime: Decodable {
	
	let timeStamp:String
	
	var thirtyDay:String
	var sevenDay:String
	var twentyFourHour:String
}

// endpoints
let weightedPrices = URL(string: "http://api.bitcoincharts.com/v1/weighted_prices.json")!
let marketsURL = URL(string: "http://api.bitcoincharts.com/v1/markets.json")!

class Market:Decodable {
	
	var currency:String
	var high:Double?
	var latestTrade:Double?
	var weightedPrice:Double?
	var bid:Double?
	var volume:Double?
	var ask:Double?
	var low:Double?
	var duration:Double?
	var close:Double?
	var average:Double?
	var symbol:String
	var currencyVolume:Double?
	
	private enum CodingKeys:String, CodingKey {
		case currency
		case high
		case latestTrade = "latest_trade"
		case weightedPrice = "weighted_price"
		case bid
		case volume
		case ask
		case low
		case duration
		case close
		case average = "avg"
		case symbol
		case currencyVolume = "currency_volume"
	}
}


URLSession(configuration: .default).dataTask(with: marketsURL) { (data, response, error) in
	if let error = error {
		
		print(error)
		
	} else {
		
		guard let data = data else { return }
		
		guard let string = String(data: data, encoding: .utf8) else { return }
		
		do {
			
			let markets = try JSONDecoder().decode([Market].self, from: data)
			
			let usdMarkets = markets.filter { $0.currency == "USD" }
			
			usdMarkets.count
			
			usdMarkets.last?.latestTrade
			
			let high = markets.reduce(0.0, { (average, market:Market) in
				
				guard let high = market.high else {
					
					return average
					
				}
				
//                return average + high/Double(markets.count)
                return high
			})
			
			high
			
		} catch {
			print(error) // any decoding error will be printed here!
		}
	}
	}.resume()
//: [Next](@next)
