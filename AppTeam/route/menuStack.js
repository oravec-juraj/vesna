import { createStackNavigator } from 'react-navigation-stack';
import Main from '../screens/NewPlant';
import Header from '../shared/header';
import React from 'react';

const screens = {
  Main: {
    screen: Main,
    navigationOptions: ({ navigation }) => {
        return {
          headerLeft: () => <Header navigation={navigation} title='    
          Register of plants'/>,
          headerTitle: () => null,
        }
      }
  },
}

const MainStack = createStackNavigator(screens, {
  defaultNavigationOptions: {
    headerTintColor: '#7EB37A',
    headerStyle: {backgroundColor: '#7EB37A'}
  }
});

export default MainStack;
