import React from "react";
import { StyleSheet, SafeAreaView, View, Text, TouchableOpacity, TextInput, ImageBackground, Button, Image } from "react-native";
import { StatusBar } from "expo-status-bar";
import { FontAwesome5 } from "@expo/vector-icons";
import Constants from "expo-constants";

export default function Login({navigation}) {

  const pressHandler = () => {
   navigation.navigate('Home')
  }

  return (
    <SafeAreaView style={styles.container}>
      <ImageBackground source={require('../assets/jungle2.jpg')} style={styles.image}>
      <StatusBar style="light" />
      <View style={styles.content}>
        <View style={styles.textWrapper}>
          <Text style={styles.hiText}>VESNA</Text>
          <Text style={styles.userText}>Versatile Simulator for Near-zero Emissions Agriculture</Text>
          <Text style={styles.userText}>UIAM - STU BA</Text>
        </View>
        <View style={styles.emailform}>
          <TextInput
            style={[styles.input, styles.inputUsername]}
            placeholder="E-mail adress"
            placeholderTextColor="#fff"
          />
        </View>
        <View style={styles.form}>
          <FontAwesome5 name="lock" style={styles.iconLock} />
          <TextInput
            style={styles.inputPassword}
            keyboardType="numeric"
            secureTextEntry={true}
            autoFocus={true}
            placeholder="Password"
            placeholderTextColor="#929292"
          />
          <TouchableOpacity style={styles.buttonLogin}>
            <Text style={styles.buttonLoginText} onPress={pressHandler}>LOG IN</Text>
          </TouchableOpacity>
        </View>
        <View style={styles.action1}>
          <TouchableOpacity>
            <Text style={styles.userText}>Forgot possword...</Text>
          </TouchableOpacity>
        </View>
        <View style={styles.action2}>
          <TouchableOpacity>
            <Text style={styles.userText}>No account? Register here!</Text>
          </TouchableOpacity>
        </View>
      </View>
      </ImageBackground>
    </SafeAreaView>

  );
}

const TEXT = {
  textAlign: "center",
  fontWeight: "bold",
  color: '#E6E2DD',
};

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: "#000",
    paddingTop: Constants.statusBarHeight,
    opacity: 1,
  },
  content: {
    paddingHorizontal: 30,
    
  },
  textWrapper: {
    marginTop: 60,
    marginBottom: 30,
  },
  hiText: {
    ...TEXT,
    fontSize: 50,
    lineHeight: 60,
  },
  userText: {
    ...TEXT,
    fontSize: 18,
    lineHeight: 30,
  },
  form: {
    marginBottom: 30,
  },
  emailform: {
    marginBottom: 5,
  },
  iconLock: {
    color: "#929292",
    position: "absolute",
    fontSize: 16,
    top: 22,
    left: 22,
    zIndex: 10,
  },
  inputPassword: {
    height: 50,
    borderRadius: 30,
    paddingHorizontal: 30,
    fontSize: 20,
    color: "#929292",
    textAlign: "center",
    textAlignVertical: "center",
    marginTop: 1,
  },
  buttonLogin: {
    height: 50,
    borderRadius: 25,
    backgroundColor: "#E6E2DD",
    justifyContent: "center",
    marginTop: 15,
  },
  buttonLoginText: {
    textAlign: "center",
    fontSize: 18,
      fontWeight: "bold",
  },
  action1: {
    textAlign: "center",
    textAlignVertical: "center",
    marginTop: 20,
  },
  action2: {
    textAlign: "center",
    textAlignVertical: "center",
    marginTop: 10,
  },
  input: {
    height: 50,
    borderRadius: 25,
    borderColor: "#cdcdcf",
    color: "#333333",
    fontSize: 18,
    textAlign: "center",
    paddingHorizontal: 15,
  },
  inputUsername: {
  },
  image: {
    flex: 1,
    justifyContent: "center",
    justifyContent: 'center',
    overflow: "hidden",
  },
});
