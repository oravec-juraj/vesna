@extends('_layouts.app')

@section('content')
<form class="jotform-form" action="/control/plant/stored" method="post" name="form_223435062226044" id="223435062226044" accept-charset="utf-8" autocomplete="off">
  @csrf  
  <div role="main" class="form-all">
    <style>
      .form-all:before
      {
        background: none;
      }
    </style>
    <ul class="form-section page-section">
      <li id="cid_1" class="form-input-wide" data-type="control_head">
        <div class="form-header-group  header-large">
          <div class="header-text httal htvam">
            <h1 id="header_1" class="form-header" data-component="header">{{__('plant.caption')}}</h1>
          </div>
        </div>
      </li>
      <li class="form-line" data-type="control_dropdown" id="id_3">
        <label class="form-label form-label-top" id="label_3" for="plant_id"> {{__('plant.plant')}} </label>
        <div id="cid_3" class="form-input-wide"> 
          <select class="form-dropdown" id="plant_id" name="plant_id" style="width:310px" data-component="dropdown" onchange="this.form.submit()">
            <option value="">{{__('plant.select')}}</option>
            <option value="Basil">{{__('plant.Basil')}}</option>
            <option value="Parsley">{{__('plant.Parsley')}}</option>
            <option value="Mint">{{__('plant.Mint')}}</option>
            <option value="Cucumber">{{__('plant.Cucumber')}}</option>
            <option value="Pepper">{{__('plant.Pepper')}}</option>
            <option value="Tomato">{{__('plant.Tomato')}}</option>
            <option value="Bean and pea">{{__('plant.Bean')}}</option>
            <option value="Lettuce">{{__('plant.Lettuce')}}</option>
            <option value="Cauliflower">{{__('plant.Cauliflower')}}</option>
            <option value="Eggplant">{{__('plant.Eggplant')}}</option>
            <option value="Head cabbage">{{__('plant.Cabbage')}}</option>
            <option value="Broccoli">{{__('plant.Broccoli')}}</option>
            <option value="Strawberry">{{__('plant.Strawberry')}}</option>
          </select> 
        </div>
          <label class="form-sub-label" for="plant_id" id="sublabel_input_3" style="font-size: medium; min-height:10px" aria-hidden="false">Currently chosen plant - <b>{{$plant_id_show}}</b></label>
      </li>
      <li class="form-line form-line-column form-col-1" data-type="control_number" id="id_5">
        <label class="form-label form-label-top" id="label_5" for="luminosity"> {{__('plant.luminosity')}} </label>
        <div id="cid_5" class="form-input-wide" data-layout="half"> 
          <input type="number" id="luminosity" name="luminosity" data-type="input-number" class=" form-number-input form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$luminosity_show}}" min="1500" max="3000" data-component="number" aria-labelledby="label_5" step="any" /> 
        </div>
      </li>
      <li class="form-line form-line-column form-col-2" data-type="control_number" id="id_10">
        <label class="form-label form-label-top" id="label_10" for="temp_max"> {{__('plant.temp_max')}} </label>
        <div id="cid_10" class="form-input-wide" data-layout="half"> 
          <input type="number" id="temp_max" name="temp_max" data-type="input-number" class=" form-number-input form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$temp_max_show}}" min="31" max="35" data-component="number" aria-labelledby="label_10" step="any" /> 
        </div>
      </li>
      <li class="form-line form-line-column form-col-3" data-type="control_number" id="id_11">
        <label class="form-label form-label-top" id="label_11" for="w_day"> {{__('plant.temp_day')}} </label>
        <div id="cid_11" class="form-input-wide" data-layout="half"> 
          <input type="number" id="w_day" name="w_day" data-type="input-number" class=" form-number-input form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$w_day_show}}" min="22" max="35" data-component="number" aria-labelledby="label_11" step="any" /> 
        </div>
      </li>
      <li class="form-line form-line-column form-col-4" data-type="control_number" id="id_12">
        <label class="form-label form-label-top" id="label_12" for="w_night"> {{__('plant.temp_night')}} </label>
        <div id="cid_12" class="form-input-wide" data-layout="half"> 
          <input type="number" id="w_night" name="w_night" data-type="input-number" class=" form-number-input form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$w_night_show}}" min="18" max="35" data-component="number" aria-labelledby="label_12" step="any" /> 
        </div>
      </li>
      <li class="form-line form-line-column form-col-5" data-type="control_number" id="id_13">
        <label class="form-label form-label-top" id="label_13" for="hum_min"> {{__('plant.hum_min')}} </label>
        <div id="cid_13" class="form-input-wide" data-layout="half"> 
          <input type="number" id="hum_min" name="hum_min" data-type="input-number" class=" form-number-input form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$hum_min_show}}" min="48" max="100" data-component="number" aria-labelledby="label_13" step="any" /> 
        </div>
      </li>
      <li class="form-line form-line-column form-col-6" data-type="control_number" id="id_14">
        <label class="form-label form-label-top" id="label_14" for="hum_max"> {{__('plant.hum_max')}} </label>
        <div id="cid_14" class="form-input-wide" data-layout="half"> 
          <input type="number" id="hum_max" name="hum_max" data-type="input-number" class=" form-number-input form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$hum_max_show}}" min="52" max="100" data-component="number" aria-labelledby="label_14" step="any" /> 
        </div>
      </li>
      <li class="form-line form-line-column form-col-7" data-type="control_number" id="id_21">
        <label class="form-label form-label-top form-label-auto" id="label_21" for="time_up"> {{__('plant.night')}} </label>
        <div id="cid_21" class="form-input-wide" data-layout="half"> 
          <input type="number" id="time_up" name="time_up" data-type="input-number" class=" form-number-input disallowDecimals form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$time_up_show}}" min="0" max="23" data-component="number" aria-labelledby="label_13" step="any" />
          <label class="form-sub-label" for="time_up" id="sublabel_input_21" style="min-height:13px" aria-hidden="false">{{__('plant.timeh')}}</label> 
        </div>
      </li>
      <li class="form-line form-line-column form-col-8" data-type="control_number" id="id_22">
        <label class="form-label form-label-top form-label-auto" id="label_22" for="time_down"> {{__('plant.night')}} </label>
        <div id="cid_22" class="form-input-wide" data-layout="half"> 
          <input type="number" id="time_down" name="time_down" data-type="input-number" class=" form-number-input disallowDecimals form-textbox" data-defaultvalue="" style="width:310px" size="310" value="" placeholder="Last value: {{$time_down_show}}" min="0" max="23" data-component="number" aria-labelledby="label_13" step="any" />
          <label class="form-sub-label" for="time_down" id="sublabel_input_22" style="min-height:13px" aria-hidden="false">{{__('plant.timeh')}}</label> 
        </div>
      </li>
      <li class="form-line" data-type="control_button" id="id_2">
        <div id="cid_2" class="form-input-wide" data-layout="full">
          <div data-align="auto" class="form-buttons-wrapper form-buttons-auto   jsTest-button-wrapperField">
            <button id="input_2" type="submit" class="form-submit-button form-submit-button-simple_green_apple submit-button jf-form-buttons jsTest-submitField" data-component="button" data-content="">{{__('plant.submit')}}</button>
          </div>
        </div>
      </li>
    </ul>
  </div>
</form>
@endsection('content')