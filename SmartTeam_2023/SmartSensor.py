import numpy as np
from pickle import load
import keras
import warnings
warnings.filterwarnings('ignore')
import os
os.environ['TF_CPP_MIN_LOG_LEVEL'] = '3' 

# load the model
model = keras.models.load_model('sensor_79.h5');
# load the scaler
scaler = load(open('scaler.pkl', 'rb'));
# transform and scale the input data
inputs = np.array(inputs).reshape(8,4);
inputs_scaled = scaler.transform(inputs).reshape(1,8,4);
# make prediction
prediction = model.predict(inputs_scaled,verbose=0);
# transform the output
output = prediction[0,0].round().astype(bool);
