@extends('_layouts.app')

@section('content')
<form class="jotform-form" action="/control/environment/stored" method="post" name="form_223546564962364" id="223546564962364" accept-charset="utf-8" autocomplete="off">
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
            <h1 id="header_1" class="form-header" data-component="header">{{__('environment.caption')}}</h1>
          </div>
        </div>
      </li>
      <li class="form-line" data-type="control_radio" id="id_24">
        <label class="form-label form-label-top form-label-auto" id="label_24" for="input_24"> {{__('environment.hum')}} <i class="fa-solid fa-droplet"></i></label>
        <div id="cid_24" class="form-input-wide" data-layout="full">
          <div class="form-multiple-column" data-columncount="2" role="group" aria-labelledby="label_24" data-component="radio">
            <span class="form-radio-item">
              <span class="dragger-item"></span>
              <input type="radio" aria-describedby="label_24" class="form-radio" id="pump_on" name="pump" {{$pump_show_on}} value="Turn on humidification" />
              <label id="label_input_24_0" for="pump_on">{{__('environment.hum_on')}}</label>
            </span>
            <span class="form-radio-item">
              <span class="dragger-item"></span>
              <input type="radio" aria-describedby="label_24" class="form-radio" id="pump_off" name="pump" {{$pump_show_off}} value="Turn off humidification" />
              <label id="label_input_24_1" for="pump_off">{{__('environment.hum_off')}}</label>
            </span>
          </div>
        </div>
      </li>
      <li class="form-line" data-type="control_divider" id="id_33">
        <div id="cid_33" class="form-input-wide" data-layout="full">
          <div class="divider" aria-label="Divider" data-component="divider" style="border-bottom-width:4px;border-bottom-style:solid;border-color:rgba(65,117,5,0.14);height:4px;margin-left:0px;margin-right:0px;margin-top:0px;margin-bottom:0px"></div>
        </div>
      </li>
      <li class="form-line" data-type="control_radio" id="id_31"><label class="form-label form-label-top form-label-auto" id="label_31" for="input_31"> {{__('environment.light')}} <i class="fa-regular fa-sun"></i></label>
        <div id="cid_31" class="form-input-wide" data-layout="full">
          <div class="form-multiple-column" data-columncount="2" role="group" aria-labelledby="label_31" data-component="radio">
            <span class="form-radio-item">
              <span class="dragger-item"></span>
              <input type="radio" aria-describedby="label_31" class="form-radio" id="lighting_on" name="lighting" {{$lighting_show_on}} checked="" value="Turn on lighting" />
              <label id="label_input_31_0" for="lighting_on">{{__('environment.light_on')}}</label>
            </span>
            <span class="form-radio-item"><span class="dragger-item"></span>
              <input type="radio" aria-describedby="label_31" class="form-radio" id="lighting_off" name="lighting" {{$lighting_show_off}} value="Turn off lighting" />
              <label id="label_input_31_1" for="lighting_off">{{__('environment.light_off')}}</label>
            </span>
          </div>
        </div>
      </li>
      <li class="form-line" data-type="control_divider" id="id_35">
        <div id="cid_35" class="form-input-wide" data-layout="full">
          <div class="divider" aria-label="Divider" data-component="divider" style="border-bottom-width:4px;border-bottom-style:solid;border-color:rgba(65,117,5,0.14);height:4px;margin-left:0px;margin-right:0px;margin-top:0px;margin-bottom:0px"></div>
        </div>
      </li>
      <li class="form-line" data-type="control_radio" id="id_32">
        <label class="form-label form-label-top form-label-auto" id="label_32" for="input_32"> {{__('environment.vent')}} <i class="fa-solid fa-wind"></i></label>
        <div id="cid_32" class="form-input-wide" data-layout="full">
          <div class="form-multiple-column" data-columncount="2" role="group" aria-labelledby="label_32" data-component="radio">
            <span class="form-radio-item">
              <span class="dragger-item"></span>
              <input type="radio" aria-describedby="label_32" class="form-radio" id="fans_on" name="fans" {{$fans_show_on}} value="Turn on the fan" />
              <label id="label_input_32_0" for="fans_on">{{__('environment.vent_on')}}</label>
            </span>
            <span class="form-radio-item">
              <span class="dragger-item"></span>
              <input type="radio" aria-describedby="label_32" class="form-radio" id="fans_off" name="fans" {{$fans_show_off}} value="Turn off the fan" />
              <label id="label_input_32_1" for="fans_off">{{__('environment.vent_off')}}</label>
            </span>
          </div>
        </div>
      </li>
      <li class="form-line" data-type="control_divider" id="id_34">
        <div id="cid_34" class="form-input-wide" data-layout="full">
          <div class="divider" aria-label="Divider" data-component="divider" style="border-bottom-width:4px;border-bottom-style:solid;border-color:rgba(65,117,5,0.14);height:4px;margin-left:0px;margin-right:0px;margin-top:0px;margin-bottom:0px"></div>
        </div>
      </li>
      <li class="form-line" data-type="control_radio" id="id_30">
        <label class="form-label form-label-top form-label-auto" id="label_30" for="input_30"> {{__('environment.irr')}} <i class="fa-solid fa-faucet-drip"></i></label>
        <div id="cid_30" class="form-input-wide" data-layout="full">
          <div class="form-multiple-column" data-columncount="2" role="group" aria-labelledby="label_30" data-component="radio">
            <span class="form-radio-item"><span class="dragger-item"></span>
            <input type="radio" aria-describedby="label_30" class="form-radio" id="irrigator_on" name="irrigator" {{$irrigator_show_on}} value="Turn on irrigation" />
            <label id="label_input_30_0" for="irrigator_on">{{__('environment.irr_on')}}</label>
          </span>
          <span class="form-radio-item">
            <span class="dragger-item"></span>
              <input type="radio" aria-describedby="label_30" class="form-radio" id="irrigator_off" name="irrigator" {{$irrigator_show_off}} value="Turn off irrigation" />
              <label id="label_input_30_1" for="irrigator_off">{{__('environment.irr_off')}}</label>
            </span>
          </div>
        </div>
      </li>
      <li class="form-line" data-type="control_button" id="id_2">
        <div id="cid_2" class="form-input-wide" data-layout="full">
          <div data-align="auto" class="form-buttons-wrapper form-buttons-auto   jsTest-button-wrapperField">
            <button id="input_2" type="submit" class="form-submit-button form-submit-button-simple_green_apple submit-button jf-form-buttons jsTest-submitField" data-component="button" data-content="">{{__('environment.submit')}}</button>
          </div>
        </div>
      </li>
    </ul>
  </div>  
</form>
@endsection('content')