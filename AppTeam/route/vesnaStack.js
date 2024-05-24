import { createStackNavigator } from 'react-navigation-stack';
import Home from '../screens/Home';
import Temperature from '../screens/Temperature';
import Light from '../screens/Light';
import AirQuality from '../screens/AirQuality';
import Login from '../screens/Login';
import Header from '../shared/header';
import React from 'react';

const screens = {
  Login: {
    screen: Login,
    navigationOptions: {
      headerShown: false,
    },
  },
  Home: {
    screen: Home,
    navigationOptions: ({ navigation }) => {
      return {
        headerLeft: () => <Header navigation={navigation} title='    VESNA' />,
        headerTitle: () => null,
        
      }
    }
  },
  Temperature: {
    screen: Temperature,
    navigationOptions: ({ navigation }) => {
      return {
        headerTitle: 'TEMPERATURE',
        headerTitleAlign: 'center',
      }
    }
  },
  Light: {
    screen: Light,
    navigationOptions: ({ navigation }) => {
      return {
        headerTitle: 'LUMINOSITY',
        headerTitleAlign: 'center',
      }
    }
  },
  AirQuality: {
    screen: AirQuality,
    navigationOptions: ({ navigation }) => {
      return {
        headerTitle: 'HUMIDITY',
        headerTitleAlign: 'center',
      }
    }
  },
}
const HomeStack = createStackNavigator(screens, {
  defaultNavigationOptions: {
    headerTintColor: '#FFFFFF',
    headerStyle: {backgroundColor: '#7EB37A', height: 60 }
  }
});

export default HomeStack;
