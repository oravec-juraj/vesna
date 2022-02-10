import * as React from 'react';
import { StatusBar } from 'expo-status-bar';
import { StyleSheet, SafeAreaView, View, Text, Image, TouchableOpacity, TextInput, Button, ImageBackground } from 'react-native';
import Constants from "expo-constants";
import { IconButton, Colors } from 'react-native-paper'; // https://materialdesignicons.com

export default function Home({ navigation }) {

    const Temperature = () => {
        navigation.navigate('Temperature')
    }

    const Light = () => {
        navigation.navigate('Light')
    }

    const AirQuality = () => {
        navigation.navigate('AirQuality')
    }

  return (
    <>
      <View style={{backgroundColor: "white"}}>
        <StatusBar style="light" />
        <View>
            <Text style={styles.text}>Lemon Tree</Text>
        </View>
        <View style={{width: 210, height: 200, }}>
          <Image style={{height: '280%', width: "185%"}} source={require('../assets/lemon_tree_5.jpg')}></Image>
        </View>
      </View>
        <View style={{flex: 1}}>
          <View style={{flexDirection:"row", height: 50, bottom: -360, left: 20, }}>
            <View style={{flex:1}}>
              <IconButton icon="brightness-6" size={50} onPress={Light}/>
            </View>
            <View style={{flex:1}}>
              <IconButton icon="air-filter" size={50} onPress={AirQuality}/>
            </View>
            <View style={{flex:1}}>
              <IconButton icon="thermometer-lines" size={50} onPress={Temperature}/>
            </View>
          </View>
        </View>
      
    </>
    
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#7EB37A",
    paddingTop: Constants.statusBarHeight,
    opacity: 1,
  },

  text: {
    textAlign: "center",
    fontWeight: "bold",
    color: '#3A6238',
    fontSize: 30,
    lineHeight: 40,
    marginTop: 5,
    marginBottom: 5,
  },


});
