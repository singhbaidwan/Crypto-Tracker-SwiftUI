//
//  ChartView.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 27/12/22.
//

import SwiftUI

struct ChartView: View {
    
    private let data:[Double]
    private let minY:Double
    private let maxY:Double
    private let lineColor:Color
    private let startingDate:Date
    private let endingDate:Date
    @State private var percentage:CGFloat = 0
    
    init(coin:CoinModel)
    {
        self.data = coin.sparklineIn7D?.price ?? []
        maxY = data.max() ?? 0
        minY = data.min() ?? 0
        let priceChange = (data.last ?? 0 ) - (data.first ?? 0)
        lineColor = priceChange > 0 ? Color.theme.green : Color.theme.red
        
        endingDate = Date(coinDateString: coin.lastUpdated ?? "")
        startingDate = endingDate.addingTimeInterval(-7*24*60*60)
        
    }
    
    var body: some View {
        VStack{
            lineChart
                .frame(height: 200)
                .background(
                    chartBackground
                )
                .overlay(alignment: .leading) {
                    chartYAxis.padding(.horizontal,4)
                }
            chartDetailLabel
                .padding(.horizontal,4)
        }
        .font(.caption)
        .foregroundColor(Color.theme.secondaryText)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
                withAnimation(.linear(duration: 2.0)){
                    percentage = 1.0
                }
            })
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView(coin: dev.coin)
    }
}

extension ChartView{
    private var lineChart:some View{
        GeometryReader{ geometry in
            let size = geometry.size
            Path{ path in
                for index in data.indices{
                    // to equally divide the points
                    let xPosition = size.width/CGFloat(data.count) * CGFloat(index+1)
                    
                    let yAxis = maxY - minY // get the difference so that we can normalize
                    
                    //                    let yPosition = CGFloat((data[index]-minY)/yAxis) * size.height //  calculating the offset
                    // the geomerty system in iphone is inverse as 0 , 0 is in top left corner and max is at bottom right corner , so to correct it we need to subtract ypoistion from 1 that will inverse the results and make correct chart
                    
                    let yPosition = (1-CGFloat((data[index]-minY)/yAxis)) * size.height
                    
                    if index == 0{
                        path.move(to: CGPoint(x: xPosition, y: yPosition))
                    }
                    path.addLine(to: CGPoint(x: xPosition, y: yPosition))
                    
                }
            }
            .trim(from: 0, to: percentage)
            .stroke(lineColor, style: StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round))
            .shadow(color: lineColor, radius: 10, x: 0, y: 10)
            .shadow(color: lineColor.opacity(0.5), radius: 10, x: 0, y: 20)
            .shadow(color: lineColor.opacity(0.2), radius: 10, x: 0, y: 30)
            .shadow(color: lineColor.opacity(0.1), radius: 10, x: 0, y: 40)
        
        }
    }
    
    private var chartBackground:some View{
        VStack{
            Divider()
            Spacer()
            Divider()
            Spacer()
            Divider()
        }
        
    }
    
    private var chartYAxis:some View{
        VStack{
            Text(maxY.formattedWithAbbreviations())
            Spacer()
            Text(((maxY + minY)/2).formattedWithAbbreviations())
            Spacer()
            Text(minY.formattedWithAbbreviations())
        }
    }
    
    private var chartDetailLabel:some View{
        HStack{
            Text(startingDate.convertDateToString())
            Spacer()
            Text(endingDate.convertDateToString())
        }
    }
    
}
