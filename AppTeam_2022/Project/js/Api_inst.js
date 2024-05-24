var IotApi = require('@arduino/arduino-iot-client');
var rp = require('request-promise');

async function getToken() {
    var options = {
        method: 'POST',
        url: 'https://api2.arduino.cc/iot/v1/clients/token',
        headers: { 'content-type': 'application/x-www-form-urlencoded' },
        json: true,
        form: {
            grant_type: 'client_credentials',
            client_id: 'Ij7686MXMIXCS4JyGJTe5nyQNQM6w7R9',
            client_secret: 'BWbnmLopN6lUDPncNZ5zDmAYvHk81TQUbHWFACt9FwysSfqiBgQYhpkVeIYLtYDQ',
            audience: 'https://api2.arduino.cc/iot'
        }
    };

    try {
        const response = await rp(options);
        return response['access_token'];
    }
    catch (error) {
        console.error("Failed getting an access token: " + error)
    }
}

async function run() {
    var client = IotApi.ApiClient.instance;
    // Configure OAuth2 access token for authorization: oauth2
    var oauth2 = client.authentications['oauth2'];
    oauth2.accessToken = await getToken();
    var prop = new IotApi.PropertiesV2Api(client)
    var api = new IotApi.DevicesV2Api(client)    
    var id = '95e254c8-7421-4d0e-bcb6-4b6991c87b4f'
    /*api.devicesV2Show(id).then(devices => {
        console.log(devices);
    }, error => {
        console.log(error)
    });*/
    var prop = new IotApi.PropertiesV2Api(client)
    var id = '95e254c8-7421-4d0e-bcb6-4b6991c87b4f'; // {String} The id of the thing
    var pid = 'd6653286-1d51-49d0-83b9-0dd6bf6b54fe'; // {String} ID of a numerical property
    var opts = {
        'from': '2022-03-29T11:00:00Z', // {String} Get data with a timestamp >= to this date (default: 2 weeks ago, min: 1842-01-01T00:00:00Z, max: 2242-01-01T00:00:00Z)
        'interval': 1, // {Integer} Binning interval in seconds (defaut: the smallest possible value compatibly with the limit of 1000 data points in the response)
        'to': '2022-03-29T11:29:00Z' // {String} Get data with a timestamp < to this date (default: now, min: 1842-01-01T00:00:00Z, max: 2242-01-01T00:00:00Z)
    };
    prop.propertiesV2Timeseries(id,pid,opts).then(data => {

        console.log(data);
    },error => {
        console.log(error)
    });
}
run();

async function send_value() {
    var client = IotApi.ApiClient.instance;
    // Configure OAuth2 access token for authorization: oauth2
    var oauth2 = client.authentications['oauth2'];
    oauth2.accessToken = await getToken();

    var val = new IotApi.PropertiesV2Api(client)
    var id = 'aa0190a8-9312-4a17-8842-25a1dd483860'; // {String} The id of the thing
    var pid = '0c8a7441-7894-4d36-b4ec-7df63dfebd2a';
    var propertyValue = {'value':40}; // 0-255
    val.propertiesV2Publish(id, pid, propertyValue).then(function() {
        console.log('API called successfully.');
      }, function(error) {
        console.error(error);
    });
}

//send_value()