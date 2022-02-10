import { createDrawerNavigator } from 'react-navigation-drawer';
import { createAppContainer } from 'react-navigation';
import HomeStack from './vesnaStack';
import MainStack from './menuStack';
import LogStack from './logStack';
import SecStack from './weatherStack';

const mainMenu = createDrawerNavigator({
    VESNA: {
        screen: HomeStack,
    },
    Plants: {
        screen: MainStack,
    },
    Weather: {
        screen: SecStack,
    },
    Logout: {
        screen: LogStack,
    }
}, 
    { 
        drawerBackgroundColor: '#D9E8D8',
        drawerWidth: 200,
        overlayColor: '#7EB37A',
});

export default createAppContainer(mainMenu);
