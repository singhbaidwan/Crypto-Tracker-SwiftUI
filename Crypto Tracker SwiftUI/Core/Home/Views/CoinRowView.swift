//
//  CoinRowView.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 22/12/22.
//

import SwiftUI

struct CoinRowView: View {
    let coin:CoinModel
    let showHoldingsColumn:Bool
    var body: some View {
        HStack(spacing:0){
            leftColumn
            Spacer()
            if showHoldingsColumn{
                middleColumn
            }
            Spacer()
            rightColumn
            //.frame(width:UIScreen.main.bounds.width/3.5,alignment:.trailing)
        }
        .font(.subheadline)
        
    }
    
}

struct CoinRowView_Previews: PreviewProvider {
    static var previews: some View {
        CoinRowView(coin: dev.coin,showHoldingsColumn: true)
            .previewLayout(.sizeThatFits)
    }
}

extension CoinRowView{
    
    private var leftColumn:some View{
        HStack{
            Text("\(coin.rank)")
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
                .frame(minWidth: 30)
            CoinImageView(coin: coin)
                .frame(width: 30,height: 30)
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading,6)
                .foregroundColor(Color.theme.accent)
        }
    }
    private var rightColumn: some View{
        VStack(alignment:.trailing){
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundColor(Color.theme.accent)
            Text(coin.priceChangePercentage24H?.asPercentageString() ?? "")
                .foregroundColor(
                    (coin.priceChangePercentage24H ?? 0 )>=0 ?
                    Color.theme.green :
                        Color.theme.red
                )
        }
    }
    private var middleColumn: some View{
        VStack(alignment:.trailing){
            Text(coin.currentHoldingsValue.asCurrencyWith6Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
        }
        .foregroundColor(Color.theme.accent)
    }
}
