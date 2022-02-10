import * as React from 'react';
import { WebView } from 'react-native-webview';
import { StyleSheet, View, } from 'react-native';


export default function Weather() {


    return (
        <>
        
            <WebView source={{ uri: 'https://www.meteoblue.com/en/weather/widget/three/bratislava_slovakia_3060972?geoloc=fixed&nocurrent=0&noforecast=0&days=4&tempunit=CELSIUS&windunit=KILOMETER_PER_HOUR&layout=image' }} 
            resizeMode={'contain'}
            scalesPageToFit={true}
            style={{       
                flex: 1,
                flexDirection: 'row',
                alignSelf: 'stretch',
                alignItems: 'stretch',
                backgroundColor: '#19334d',
                width: '100%',
                height: '10%',
             }}
            />
        </>
    )
}
