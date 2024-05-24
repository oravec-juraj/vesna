import { createStackNavigator } from 'react-navigation-stack';
import Login from '../screens/Login';

const screens = {
  Logout: {
    screen: Login,
    navigationOptions: ({ navigation }) => {
        return {
          headerLeft: () => null,
          headerTitle: () => null,
        }
      }
  }
}

const LogStack = createStackNavigator(screens, {
  defaultNavigationOptions: {
    headerTintColor: '#7EB37A',
    headerStyle: {backgroundColor: '#7EB37A'}
  }
});

export default LogStack;
