import * as React from 'react';
import {useState, useEffect } from 'react';
import { WebView } from 'react-native-webview';
import { StatusBar } from 'expo-status-bar';
import { StyleSheet, SafeAreaView, View, Text, TouchableOpacity, TextInput, Button, ImageBackground, Switch, FlatList } from 'react-native';
import { IconButton, Colors } from 'react-native-paper';
import Slider from '@react-native-community/slider';

export default function Light({ navigation }) {

  const pressHandler = () => {
    navigation.goBack();
  }

  const Temperature = () => {
      navigation.replace('Temperature')
  }

  const AirQuality = () => {
      navigation.replace('AirQuality')
  }

  const Home = () => {
    navigation.replace('Home')
  }

  // Switch for on/off manual control
  const [isEnabled, setIsEnabled] = useState(false);
  const toggleSwitch = () => setIsEnabled(previousState => !previousState);

  // Slider for actuator
  const [avalue, setAvalue] = useState(50);

  // Actual value
  const [data, setData] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await fetch('https://thingspeak.com/channels/1632859/fields/2.json?results=1');
        const json = await res.json();
        setData(json);
      } catch (error) {
        console.log(error);
      }
    };
      
    const id = setInterval(() => {
      fetchData();
    }, 6000);
  
    fetchData();
  
    return () => clearInterval(id);
  }, [])

  // Actuator
  const [data1, setData1] = useState([]);
  useEffect(() => {
    const fetchData = async () => {
      try {
        const res = await fetch('https://thingspeak.com/channels/1635834/fields/1.json?results=1');
        const json = await res.json();
        setData1(json);
      } catch (error) {
        console.log(error);
      }
    };        
    const id = setInterval(() => {
      fetchData();
    }, 6000);    
    fetchData();
    return () => clearInterval(id);
  }, [])

  // Manual Control on/off
  try {
    fetch('https://api.thingspeak.com/update.json' , {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(
        {
          "api_key": "846KEBTSUQ9518BO",
          // "api_key": "KSG00DQ8OT0HHI0S",
          "field5":  isEnabled ? '0' : '1',
        }
      )
    });
  } catch(error) {
  console.log(error);
  }

  // Actuator control
  try {
    fetch('https://api.thingspeak.com/update.json' , {
      method: 'POST',
      headers: {
        Accept: 'application/json',
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(
        {
          // "api_key": "846KEBTSUQ9518BO",
          "api_key": "KSG00DQ8OT0HHI0S",
          "field2": avalue,
        }
      )
    });
  } catch(error) {
  console.log(error);
  }

  return (
    <>
      <StatusBar style="light" />

      <WebView source={{ uri: 'https://thingspeak.com/channels/1632859/charts/2?bgcolor=%23ffffff&color=%23d62020&dynamic=true&results=60&type=line&update=15' }} 
      scalesPageToFit={true}
      style={{ width: '220%', marginBottom: 7}}
      />

      <View style={{flex: 0.2}}>
        <View style={{flexDirection:"row",  height: 40, }}>
          <View style={{flex:1}}>
            <Text style={styles.text}>Actual value</Text>
          </View>

          <View style={{flex:0.9}}>
            <FlatList
              data ={data.feeds}
              keyExtractor={({ field2 }, index) => field2}
              renderItem={({ item }) => (
                <Text style={styles.t_text}>{parseFloat(item.field2).toFixed(2)} lx</Text>
              )}
            />
          </View>
        </View>
      </View>
      
      <View style={{flex: 0.2}}>
        <View style={{flexDirection:"row",  height: 50}}>
          <View style={{flex:1}}>
            <Text style={styles.text}>Manual Control</Text>
          </View>

          <View style={{flex:1}} style={styles.container}>
          <Switch
            trackColor={{ false: "#767577", true: "#3A6238" }}
            thumbColor={isEnabled ? "#7EB37A" : "#f4f3f4"}
            ios_backgroundColor="#3e3e3e"
            onValueChange={toggleSwitch}
            value={isEnabled}
          />
          </View>
        </View>
      </View>

      <View style={{flex: 0.1}}>
        <View style={{flexDirection:"row",  height: 55}}>
          <View style={{flex:1}}>
            <FlatList
              data ={data1.feeds}
              keyExtractor={({ field1 }, index) => field1}
              renderItem={({ item }) => (
                <Text style={styles.text}>Actuator {parseFloat(item.field1).toFixed()} %</Text>
              )}
            />
          </View>

          <View style={{flex:1}} style={styles.container}>
            <Slider 
             value={avalue}
             disabled={isEnabled ? false : true}
             style={{width: 200, height: 40}}
             minimumValue={0}
             maximumValue={100}
             minimumTrackTintColor="#7EB37A"
             maximumTrackTintColor="#3A6238"
             onValueChange={avalue => setAvalue(avalue)}
             step={1}
            />
          
          </View>
        </View>
      </View>

      <View style={{flex: 0.1}}>
        <View style={{flexDirection:"row",  height: 55}}>
          <View style={{flex:1}}></View>
          <View style={{flex:1}} style={styles.container}>
            <Text style={styles.text_small}>{avalue}</Text>
          </View>
        </View>
      </View>

      <WebView source={{ uri: 'https://thingspeak.com/channels/1635834/charts/1?bgcolor=%23ffffff&color=%23d62020&dynamic=true&results=60&type=line&update=15' }} 
      scalesPageToFit={true}
      style={{ width: '220%', marginTop: 2,marginBottom: 5}}
      />

      <View style={{flex: 0.4}}>
        <View style={{flexDirection:"row", height: 50, bottom: 5, left: 20}}>
          <View style={{flex:1}}>
            <IconButton icon="thermometer-lines" size={50} onPress={Temperature}/>
          </View>
          <View style={{flex:1}}>
            <IconButton icon="air-filter" size={50} onPress={AirQuality}/>
          </View>
          <View style={{flex:1}}>
           <IconButton icon="home" size={50} onPress={Home}/>
         </View>
        </View>
      </View>
    </>
  );
}

const styles = StyleSheet.create({
  
  main_text: {
    textAlign: "center",
    fontWeight: "bold",
    color: '#3A6238',
    fontSize: 30,
    lineHeight: 40,

  },

  text: {
    textAlign: "center",
    fontWeight: "bold",
    color: '#3A6238',
    fontSize: 20,
    lineHeight: 30,

  },

  text_small: {
    textAlign: "center",
    fontWeight: "bold",
    color: '#3A6238',
    fontSize: 12,
    lineHeight: 30,

  },

  t_text: {
    textAlign: "center",
    color: '#3A6238',
    fontSize: 20,
    lineHeight: 30,
    backgroundColor: "#d9e8d8"
  },

  container: {
    flex: 1,
    alignItems: "center",
  },


});