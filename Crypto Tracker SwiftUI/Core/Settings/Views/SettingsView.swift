//
//  SettingsView.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 28/12/22.
//

import SwiftUI

struct SettingsView: View {
    
    let defaultURL = URL(string: "https://google.com")!
    let youtubeURL = URL(string: "https://youtube.com")!
    let coingeckoURL = URL(string: "https://coingecko.com")!
    let linkedInURL = URL(string: "https://linkedin.com/singbaidwan")!
    let githubURL = URL(string: "https://github.com/singhbaidwan")!
    
    @Binding var dismiss:Bool
    
    var body: some View {
        NavigationView {
            List{
                introductionSection
                coinGeckoSection
                developerSection
                applicationSection
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    XMarkButton(dismiss: $dismiss)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(dismiss: .constant(false))
    }
}


extension SettingsView{
    private var introductionSection:some View{
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .frame(width: 100,height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("This app is created by following MVVM architecture,Combine and Core Data")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            Group{
                Link("Follow me on linkedin 😀", destination: linkedInURL)
                Link("Checkout my Github 😀",destination: githubURL)
            }
            .tint(.blue)
        } header: {
            Text("About App")
        }
    }
    private var coinGeckoSection:some View{
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                Text("The API used in this App are from coingecko website . For this App free APIs are used.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
            Link("Visit CoinGecko", destination: coingeckoURL)
                .tint(.blue)
            
        } header: {
            Text("CoinGecko")
        }
    }
    private var developerSection:some View{
        Section {
            VStack(alignment: .leading) {
                Text("This app is created by Dalveer Singh. It uses SwiftUI and is written completly in swift")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundColor(Color.theme.accent)
                
            }
            .padding(.vertical)
        } header: {
            Text("About Developer")
        }
    }
    private var applicationSection:some View{
        Section {
            Link("Terms of Service",destination: defaultURL)
            Link("Privacy Policy",destination: defaultURL)
            Link("Company website",destination: defaultURL)
            Link("Learn More",destination: defaultURL)
            
        } header: {
            Text("Application")
        }
    }
}
