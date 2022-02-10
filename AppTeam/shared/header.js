import React from "react";
import { StyleSheet, Text, View, SafeAreaView, Image, StatusBar } from "react-native";
import { MaterialIcons } from '@expo/vector-icons';


export default function Header({ navigation, title }) {

    const pressHandler = () => {
        navigation.openDrawer()
    }

    return (
      <>
        
        <MaterialIcons name='menu' color='#FFFFFF' size={35} onPress={pressHandler} styles={styles.icon} />
        <View style={styles.header}>
          <View>
              <Text style={styles.headerText}>{ title }</Text>
          </View>
        </View>
    
        {/* <MaterialIcons name='menu' size={30} onPress={pressHandler} styles={styles.icon} />
        <View style={styles.header}>
          <View>
              <Text style={styles.headerText}>{ title }</Text>
          </View>
        </View> */}
      </>
    );
}

const styles = StyleSheet.create({
    header: {
        width: '900%',
        height: '100%',
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'center',
        backgroundColor: '#7EB37A',
        position: 'absolute',
        left: 25
    },
    headerText: {
        fontWeight: 'bold',
        fontSize: 30,
        // fontFamily: "Cochin",
        color: '#E6E2DD',
        letterSpacing: 1,
        textAlign: "center",
    },
    icon: {
        position: 'absolute',
        left: 0,
        color: '#FFFFFF',

    }
});
