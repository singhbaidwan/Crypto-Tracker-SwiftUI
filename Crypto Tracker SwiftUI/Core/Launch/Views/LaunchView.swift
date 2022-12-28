//
//  LaunchView.swift
//  Crypto Tracker SwiftUI
//
//  Created by Dalveer singh on 28/12/22.
//

import SwiftUI

struct LaunchView: View {
    @State private var loadingText:[String] = "Loading your Portfolio ...".map{ String($0) }
    @State private var showLoadingText:Bool = false
    private let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    @State private var counter:Int = 0
    @State private var loops:Int = 0
    @Binding var showLaunchView:Bool
    var body: some View {
        ZStack{
            Color.launch.background
                .ignoresSafeArea()
            Image("logo-transparent")
                .resizable()
                .frame(width: 100,height: 100)
            
            ZStack{
                if showLoadingText{
                    //                    Text(loadingText)
                    //                        .font(.headline)
                    //                        .foregroundColor(Color.launch.accent)
                    //                        .fontWeight(.heavy)
                    //                        .transition(AnyTransition.scale.animation(.easeIn))
                    LazyHStack(spacing:0){
                        ForEach(loadingText.indices){index in
                            Text(loadingText[index])
                                .font(.headline)
                                .foregroundColor(Color.launch.accent)
                                .fontWeight(.heavy)
                                .offset(y: counter==index ? -5:0)
                        }
                    }
                }
                
            }
            .offset(y:70)
            .onAppear {
                showLoadingText.toggle()
            }
            .onReceive(timer) { _ in
                withAnimation(.spring())
                {
                    if counter == loadingText.count{
                        counter = -1
                        loops+=1
                    }
                    counter+=1
                    if loops>=2{
                        showLaunchView = false
                    }
                }
            }
        }
    }
}

struct LaunchView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchView(showLaunchView: .constant(true))
    }
}
