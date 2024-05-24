import { createStackNavigator } from 'react-navigation-stack';
import Weather from '../screens/Weather';
import Header from '../shared/header';
import React from 'react';

const screens = {
  Weather: {
    screen: Weather,
    navigationOptions: ({ navigation }) => {
        return {
          headerLeft: () => <Header navigation={navigation} title='    
          Weather Forecast'/>,
          headerTitle: () => null,
        }
      }
  },
}

const SecStack = createStackNavigator(screens, {
  defaultNavigationOptions: {
    headerTintColor: '#7EB37A',
    headerStyle: {backgroundColor: '#7EB37A'}
  }
});

export default SecStack;
