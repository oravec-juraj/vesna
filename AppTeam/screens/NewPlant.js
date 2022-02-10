import * as React from 'react';
import { StatusBar } from 'expo-status-bar';
import { StyleSheet, SafeAreaView, View, Text, Image, TouchableOpacity, TextInput, Button, ImageBackground } from 'react-native';
import Constants from "expo-constants";


export default function Plants() {

  return (
    <>
      <View>
        <StatusBar style="light" />
        <View>
            <Text style={styles.text}>...</Text>
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
